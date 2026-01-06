#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <iostream>
#include <vector>
#include <thread>
#include <atomic>
#include <mutex>
#include <condition_variable>
#include <algorithm>

using u64 = unsigned long long;

// Проверка: отсортированы ли первые N байт
bool is_sorted_prefix(const std::vector<BYTE>& data, size_t count) {
    size_t limit = (count < data.size()) ? count : data.size();
    for (size_t i = 1; i < limit; ++i) {
        if (data[i - 1] > data[i]) return false;
    }
    return true;
}

// Обработка: сортировка копии буфера
bool process_block_sort(const BYTE* data, SIZE_T size) {
    std::vector<BYTE> copy(data, data + size);
    std::sort(copy.begin(), copy.end());
    return is_sorted_prefix(copy, 16); // проверяем первые 16 байт
}

// Запись ошибок
static void show_error(const char* msg) {
    std::cerr << msg << " error=" << GetLastError() << "\n";
}

// Структура для одного "слота" операции
struct OpSlot {
    OVERLAPPED ov;
    std::vector<BYTE> buffer;
    DWORD bytesTransferred;
    bool sortedOk;
    size_t index;
    OpSlot(size_t bufSize) : buffer(bufSize), bytesTransferred(0), sortedOk(false), index(0) {
        ZeroMemory(&ov, sizeof(ov));
    }
};

// Параметры
struct Params {
    std::wstring path;
    SIZE_T bufferSize;
    int concurrency;
};

// -------------------- АСИНХРОННАЯ РЕАЛИЗАЦИЯ --------------------
void run_async(const Params& p) {
    HANDLE hFile = CreateFileW(p.path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED | FILE_FLAG_SEQUENTIAL_SCAN, nullptr);
    if (hFile == INVALID_HANDLE_VALUE) { show_error("CreateFileW async"); return; }

    LARGE_INTEGER fileSizeLi;
    if (!GetFileSizeEx(hFile, &fileSizeLi)) { show_error("GetFileSizeEx async"); CloseHandle(hFile); return; }
    LONGLONG fileSize = fileSizeLi.QuadPart;
    if (fileSize == 0) { std::cerr << "Empty file\n"; CloseHandle(hFile); return; }

    LONGLONG totalBlocks = (fileSize + (LONGLONG)p.bufferSize - 1) / (LONGLONG)p.bufferSize;

    HANDLE hIOCP = CreateIoCompletionPort(hFile, nullptr, 0, 0);
    if (!hIOCP) { show_error("CreateIoCompletionPort"); CloseHandle(hFile); return; }

    std::vector<OpSlot*> slots;
    slots.reserve(p.concurrency);
    for (int i = 0; i < p.concurrency; ++i) slots.push_back(new OpSlot(p.bufferSize));

    std::atomic<LONGLONG> nextBlock(0);
    std::atomic<int> outstanding(0);
    std::atomic<int> sortedOkCount(0);
    std::atomic<int> sortedFailCount(0);

    int workerCount = std::max<int>(1, static_cast<int>(std::thread::hardware_concurrency()) - 1);
    std::vector<std::thread> workers;
    std::mutex qmut;
    std::condition_variable qcv;
    std::vector<OpSlot*> workQueue;
    std::atomic<bool> stopping(false);

    auto workerFunc = [&]() {
        while (true) {
            OpSlot* task = nullptr;
            {
                std::unique_lock<std::mutex> lk(qmut);
                qcv.wait(lk, [&]() { return !workQueue.empty() || stopping.load(); });
                if (stopping.load() && workQueue.empty()) return;
                task = workQueue.back();
                workQueue.pop_back();
            }
            bool ok = process_block_sort(task->buffer.data(), task->bytesTransferred);
            task->sortedOk = ok;
            if (ok) sortedOkCount++;
            else sortedFailCount++;
        }
        };

    for (int i = 0; i < workerCount; ++i) workers.emplace_back(workerFunc);

    ULONGLONG t0 = GetTickCount64();

    // Инициируем первые асинхронные чтения
    for (int i = 0; i < p.concurrency; ++i) {
        LONGLONG b = nextBlock.fetch_add(1);
        if (b >= totalBlocks) break;
        OpSlot* sslot = slots[i];
        sslot->index = (size_t)b;
        sslot->bytesTransferred = 0;
        LONGLONG offset = b * (LONGLONG)p.bufferSize;
        sslot->ov.Offset = (DWORD)(offset & 0xFFFFFFFF);
        sslot->ov.OffsetHigh = (DWORD)((offset >> 32) & 0xFFFFFFFF);
        outstanding.fetch_add(1);
        BOOL rc = ReadFile(hFile, sslot->buffer.data(), (DWORD)p.bufferSize, nullptr, &sslot->ov);
        if (!rc && GetLastError() != ERROR_IO_PENDING) { show_error("ReadFile initial"); CloseHandle(hIOCP); CloseHandle(hFile); return; }
    }

    // Получаем завершения и ставим задачи воркерам
    while (true) {
        DWORD bytes = 0;
        ULONG_PTR key = 0;
        LPOVERLAPPED pov = nullptr;
        BOOL ok = GetQueuedCompletionStatus(hIOCP, &bytes, &key, &pov, INFINITE);
        if (!ok && pov == nullptr) { show_error("GetQueuedCompletionStatus"); break; }

        OpSlot* completed = nullptr;
        for (auto* s : slots) {
            if (&s->ov == pov) { completed = s; break; }
        }
        if (!completed) { show_error("Unknown completion"); break; }
        completed->bytesTransferred = bytes;
        outstanding.fetch_sub(1);

        if (bytes > 0) {
            {
                std::lock_guard<std::mutex> lk(qmut);
                workQueue.push_back(completed);
            }
            qcv.notify_one();
        }

        LONGLONG b = nextBlock.fetch_add(1);
        if (b < totalBlocks) {
            completed->bytesTransferred = 0;
            completed->sortedOk = false;
            completed->index = (size_t)b;
            LONGLONG offset = b * (LONGLONG)p.bufferSize;
            completed->ov.Offset = (DWORD)(offset & 0xFFFFFFFF);
            completed->ov.OffsetHigh = (DWORD)((offset >> 32) & 0xFFFFFFFF);
            outstanding.fetch_add(1);
            BOOL rc = ReadFile(hFile, completed->buffer.data(), (DWORD)p.bufferSize, nullptr, &completed->ov);
            if (!rc && GetLastError() != ERROR_IO_PENDING) { show_error("ReadFile submit"); break; }
        }
        else {
            if (outstanding.load() == 0) {
                // дождёмся опустошения очереди задач
                while (true) {
                    {
                        std::lock_guard<std::mutex> lk(qmut);
                        if (workQueue.empty()) break;
                    }
                    Sleep(1);
                }
                break;
            }
        }
    }

    // Останавливаем воркеров
    stopping.store(true);
    qcv.notify_all();
    for (auto& th : workers) if (th.joinable()) th.join();

    ULONGLONG t1 = GetTickCount64();

    std::cout << "[ASYNC] Total time ms: " << (t1 - t0) << "\n";
    std::cout << "[ASYNC] Blocks sorted OK: " << sortedOkCount.load() << "\n";
    std::cout << "[ASYNC] Blocks failed check: " << sortedFailCount.load() << "\n";

    for (auto* s : slots) delete s;
    CloseHandle(hIOCP);
    CloseHandle(hFile);
}

// -------------------- СИНХРОННАЯ РЕАЛИЗАЦИЯ --------------------
void run_sync(const Params& p) {
    HANDLE hFile = CreateFileW(p.path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING,
        FILE_FLAG_SEQUENTIAL_SCAN, nullptr);
    if (hFile == INVALID_HANDLE_VALUE) { show_error("CreateFileW sync"); return; }

    LARGE_INTEGER fileSizeLi;
    if (!GetFileSizeEx(hFile, &fileSizeLi)) { show_error("GetFileSizeEx sync"); CloseHandle(hFile); return; }
    LONGLONG fileSize = fileSizeLi.QuadPart;
    if (fileSize == 0) { std::cerr << "Empty file\n"; CloseHandle(hFile); return; }

    LONGLONG totalBlocks = (fileSize + (LONGLONG)p.bufferSize - 1) / (LONGLONG)p.bufferSize;
    std::vector<BYTE> buffer(p.bufferSize);

    int okCount = 0, failCount = 0;
    ULONGLONG t0 = GetTickCount64();

    for (LONGLONG b = 0; b < totalBlocks; ++b) {
        DWORD bytesRead = 0;
        BOOL rc = ReadFile(hFile, buffer.data(), (DWORD)p.bufferSize, &bytesRead, nullptr);
        if (!rc) { show_error("ReadFile sync"); break; }
        if (bytesRead == 0) break;

        bool ok = process_block_sort(buffer.data(), bytesRead);
        if (ok) okCount++; else failCount++;
    }

    ULONGLONG t1 = GetTickCount64();
    std::cout << "[SYNC] Total time ms: " << (t1 - t0) << "\n";
    std::cout << "[SYNC] Blocks sorted OK: " << okCount << "\n";
    std::cout << "[SYNC] Blocks failed check: " << failCount << "\n";

    CloseHandle(hFile);
}

// -------------------- main --------------------
int wmain(int argc, wchar_t** argv) {
    if (argc < 2) {
        std::wcout << L"Usage: async_file_process.exe <file> [bufferKB=65536] [concurrency=4]\n";
        return 1;
    }

    Params p;
    p.path = argv[1];
    SIZE_T bufferKB = 64 * 1024;
    p.concurrency = 4;
    if (argc >= 3) bufferKB = std::stoull(std::wstring(argv[2]));
    if (argc >= 4) p.concurrency = std::stoi(std::wstring(argv[3]));
    p.bufferSize = bufferKB * 1024ULL;

    std::wcout << L"File: " << p.path << L"\nBuffer: " << (p.bufferSize / 1024) << L" KB\nConcurrency: " << p.concurrency << L"\n\n";

    // Сначала асинхронный проход
    run_async(p);

    // Затем синхронный проход
    run_sync(p);

    return 0;
}

