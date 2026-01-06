// LogServer.cpp
#include <windows.h>
#include <cstdio>
#include <string>
#include <vector>
#include <sstream>

static const wchar_t* PIPE_NAME = L"\\\\.\\pipe\\LogServer";
static const int MAX_INSTANCES = 16;
static const DWORD BUFFER_SIZE = 8192;

enum class PipeState { Connecting, Reading };

struct PipeInstance {
    HANDLE hPipe = INVALID_HANDLE_VALUE;
    OVERLAPPED ovl{};
    HANDLE hEvent = NULL;
    PipeState state = PipeState::Connecting;
    std::vector<char> buffer;
    DWORD bytesTransferred = 0;
    int index = -1;
};

std::wstring timestamp() {
    SYSTEMTIME st;
    GetLocalTime(&st);
    wchar_t buf[64];
    swprintf(buf, 64, L"%04d-%02d-%02d %02d:%02d:%02d.%03d",
        st.wYear, st.wMonth, st.wDay,
        st.wHour, st.wMinute, st.wSecond, st.wMilliseconds);
    return buf;
}

void writeLog(HANDLE hFile, int pipeIndex, const std::string& msg) {
    std::wstring ts = timestamp();
    std::ostringstream oss;
    oss << "[" << std::string(ts.begin(), ts.end()) << "] "
        << "[pipe-" << pipeIndex << "] "
        << msg << "\r\n";
    std::string line = oss.str();
    DWORD written = 0;
    WriteFile(hFile, line.c_str(), (DWORD)line.size(), &written, NULL);
}

HANDLE createLogFile(const wchar_t* path) {
    HANDLE h = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ, NULL,
        OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (h != INVALID_HANDLE_VALUE) SetFilePointer(h, 0, NULL, FILE_END);
    return h;
}

HANDLE createPipeInstance() {
    return CreateNamedPipeW(
        PIPE_NAME,
        PIPE_ACCESS_DUPLEX | FILE_FLAG_OVERLAPPED,
        PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
        MAX_INSTANCES,
        BUFFER_SIZE, BUFFER_SIZE,
        0, NULL
    );
}

bool beginConnect(PipeInstance& pi) {
    ZeroMemory(&pi.ovl, sizeof(OVERLAPPED));
    pi.ovl.hEvent = pi.hEvent;
    BOOL ok = ConnectNamedPipe(pi.hPipe, &pi.ovl);
    if (ok) { pi.state = PipeState::Reading; return true; }
    DWORD err = GetLastError();
    if (err == ERROR_IO_PENDING) { pi.state = PipeState::Connecting; return true; }
    if (err == ERROR_PIPE_CONNECTED) {
        pi.state = PipeState::Reading;
        SetEvent(pi.hEvent);
        return true;
    }
    return false;
}

bool beginRead(PipeInstance& pi) {
    ZeroMemory(&pi.ovl, sizeof(OVERLAPPED));
    pi.ovl.hEvent = pi.hEvent;
    pi.buffer.assign(BUFFER_SIZE, 0);
    BOOL ok = ReadFile(pi.hPipe, pi.buffer.data(), BUFFER_SIZE, NULL, &pi.ovl);
    if (ok || GetLastError() == ERROR_IO_PENDING) {
        pi.state = PipeState::Reading;
        return true;
    }
    return false;
}

void disconnectAndReconnect(PipeInstance& pi) {
    DisconnectNamedPipe(pi.hPipe);
    pi.state = PipeState::Connecting;
    beginConnect(pi);
}

int wmain() {
    HANDLE hLog = createLogFile(L"log.txt");
    if (hLog == INVALID_HANDLE_VALUE) {
        wprintf(L"Failed to open log.txt (err=%lu)\n", GetLastError());
        return 1;
    }

    std::vector<PipeInstance> pipes;
    std::vector<HANDLE> events;
    for (int i = 0; i < MAX_INSTANCES; ++i) {
        PipeInstance pi;
        pi.hPipe = createPipeInstance();
        pi.hEvent = CreateEventW(NULL, FALSE, FALSE, NULL); // auto-reset
        pi.index = i;
        beginConnect(pi);
        pipes.push_back(pi);
        events.push_back(pi.hEvent);
    }

    wprintf(L"LogServer ready. Pipe name: %ls\n", PIPE_NAME);
    wprintf(L"Waiting for clients...\n");

    while (true) {
        DWORD wait = WaitForMultipleObjects((DWORD)events.size(), events.data(), FALSE, INFINITE);
        if (wait == WAIT_FAILED) break;
        DWORD idx = wait - WAIT_OBJECT_0;
        if (idx >= pipes.size()) continue;

        PipeInstance& pi = pipes[idx];
        DWORD bytes = 0;
        BOOL ok = GetOverlappedResult(pi.hPipe, &pi.ovl, &bytes, FALSE);

        if (pi.state == PipeState::Connecting) {
            if (!ok && GetLastError() != ERROR_PIPE_CONNECTED) {
                disconnectAndReconnect(pi);
                continue;
            }
            beginRead(pi);
        }
        else if (pi.state == PipeState::Reading) {
            if (!ok) {
                DWORD err = GetLastError();
                if (err == ERROR_BROKEN_PIPE || err == ERROR_PIPE_NOT_CONNECTED) {
                    disconnectAndReconnect(pi);
                    continue;
                }
                if (err == ERROR_MORE_DATA) {
                    continue;
                }
            }
            if (bytes > 0) {
                std::string msg(pi.buffer.data(), pi.buffer.data() + bytes);
                writeLog(hLog, pi.index, msg);
            }
            if (!beginRead(pi)) disconnectAndReconnect(pi);
        }
    }

    for (auto& pi : pipes) {
        DisconnectNamedPipe(pi.hPipe);
        CloseHandle(pi.hPipe);
        CloseHandle(pi.hEvent);
    }
    CloseHandle(hLog);
    return 0;
}
