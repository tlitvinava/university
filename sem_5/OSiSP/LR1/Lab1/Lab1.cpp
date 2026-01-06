#include <windows.h>    
#include <iostream>     
#include <vector>       
#include <chrono>       
#include <iomanip>      
#include <algorithm>    


struct ThreadData {
    int* start;         
    size_t length;      
    bool done;          
};

double GetCPUUsage() {
    static FILETIME prevIdleTime = { 0 }, prevKernelTime = { 0 }, prevUserTime = { 0 };

    FILETIME idleTime, kernelTime, userTime;
    if (!GetSystemTimes(&idleTime, &kernelTime, &userTime)) {
        return -1.0; 
    }

    ULONGLONG idleDiff =
        (((ULONGLONG)idleTime.dwHighDateTime << 32) | idleTime.dwLowDateTime) -
        (((ULONGLONG)prevIdleTime.dwHighDateTime << 32) | prevIdleTime.dwLowDateTime);

    ULONGLONG kernelDiff =
        (((ULONGLONG)kernelTime.dwHighDateTime << 32) | kernelTime.dwLowDateTime) -
        (((ULONGLONG)prevKernelTime.dwHighDateTime << 32) | prevKernelTime.dwLowDateTime);

    ULONGLONG userDiff =
        (((ULONGLONG)userTime.dwHighDateTime << 32) | userTime.dwLowDateTime) -
        (((ULONGLONG)prevUserTime.dwHighDateTime << 32) | prevUserTime.dwLowDateTime);

    prevIdleTime = idleTime;
    prevKernelTime = kernelTime;
    prevUserTime = userTime;

    ULONGLONG total = kernelDiff + userDiff;
    if (total == 0) return 0.0;

    double usage = (double)(total - idleDiff) * 100.0 / total;
    return usage;
}

DWORD WINAPI SortFragment(LPVOID param) {
    ThreadData* data = (ThreadData*)param;
    std::sort(data->start, data->start + data->length);
    data->done = true; 
    return 0;
}

void LinearSort(std::vector<int>& arr) {
    std::sort(arr.begin(), arr.end());
}

int main() {
    size_t arraySize;
    int numWorkers;

    std::cout << "Введите размер массива: ";
    std::cin >> arraySize;
    std::cout << "Введите количество потоков: ";
    std::cin >> numWorkers;

    if (numWorkers < 1) numWorkers = 1;
    if (numWorkers > (int)arraySize) numWorkers = (int)arraySize;

    //исходный массив
    std::vector<int> original(arraySize);
    for (size_t i = 0; i < arraySize; i++) {
        original[i] = rand() % 1000;
    }

    //линейная сортировка
    {
        auto arr = original; 
        auto startTime = std::chrono::high_resolution_clock::now();
        LinearSort(arr);
        auto endTime = std::chrono::high_resolution_clock::now();
        double elapsed = std::chrono::duration<double>(endTime - startTime).count();

        std::cout << std::fixed << std::setprecision(6)
            << "\n[Линейная] Время: " << elapsed << " сек.\n";
    }

    //многопоточная
    {
        auto arr = original;
        size_t fragmentSize = arraySize / numWorkers;
        std::vector<ThreadData> threadData(numWorkers);
        std::vector<HANDLE> threads(numWorkers);

        auto startTime = std::chrono::high_resolution_clock::now();

        for (int i = 0; i < numWorkers; i++) {
            threadData[i].start = arr.data() + i * fragmentSize;
            threadData[i].length = (i == numWorkers - 1)
                ? (arraySize - i * fragmentSize)
                : fragmentSize;
            threadData[i].done = false;
            threads[i] = CreateThread(NULL, 0, SortFragment, &threadData[i], 0, NULL);
        }

        GetCPUUsage(); 
        Sleep(1);

        double cpuSum = 0.0;
        int cpuSamples = 0;

        bool allDone = false;
        while (!allDone) {
            allDone = true;
            double cpuLoad = GetCPUUsage();
            cpuSum += cpuLoad;
            cpuSamples++;

            for (int i = 0; i < numWorkers; i++) {
                if (!threadData[i].done) allDone = false;
            }
            Sleep(1);
        }

        WaitForMultipleObjects(numWorkers, threads.data(), TRUE, INFINITE);
        for (HANDLE h : threads) CloseHandle(h);

        auto endTime = std::chrono::high_resolution_clock::now();

        double elapsed = std::chrono::duration<double>(endTime - startTime).count();
        double avgCpu = (cpuSamples > 0) ? (cpuSum / cpuSamples) : 0.0;

        std::cout << "[Многопоточная] Время: "
            << std::fixed << std::setprecision(4) << elapsed;
            //<< " сек., Средняя загрузка CPU: "
            //<< std::fixed << std::setprecision(1) << avgCpu << "%\n";
    }

    return 0;
}
