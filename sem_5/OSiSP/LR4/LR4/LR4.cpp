#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <atomic>
#include <string>
#include <vector>
#include <random>
#include <chrono>
#include <algorithm>
#include <iostream>
#include <limits>

struct Config {
    std::string name;
    int readers = 4;
    int writers = 2;
    int operations_per_thread = 50;
    int mean_think_ms_reader = 20;
    int mean_think_ms_writer = 30;
    int mean_read_ms = 15;
    int mean_write_ms = 20;
    int wait_timeout_ms = 500;
    unsigned seed = 0;
};

struct Limits {
    static constexpr int MIN_THREADS = 1;
    static constexpr int MAX_THREADS = 1000;
    static constexpr int MIN_OPERATIONS = 1;
    static constexpr int MAX_OPERATIONS = 1000000;
    static constexpr int MIN_MS = 1;
    static constexpr int MAX_MS = 60000;
    static constexpr int MIN_TIMEOUT_MS = 1;
    static constexpr int MAX_TIMEOUT_MS = 300000;
};

static HANDLE mutex1 = NULL;
static HANDLE mutex2 = NULL;
static HANDLE w = NULL;
static HANDLE r = NULL;
static std::atomic<int> readcount{ 0 };
static std::atomic<int> writecount{ 0 };
static std::atomic<int> RESOURCE{ 0 };

struct ThreadStats {
    int successes = 0;
    int failures = 0;
    int64_t blocked_ms = 0;
    int64_t active_ms = 0;
    int64_t blocked_writes_ms = 0;
};

struct GlobalStats {
    std::atomic<int> total_reads{ 0 };
    std::atomic<int> total_writes{ 0 };
    std::atomic<int> failed_reads{ 0 };
    std::atomic<int> failed_writes{ 0 };
    std::atomic<int64_t> blocked_reads_ms{ 0 };
    std::atomic<int64_t> blocked_writes_ms{ 0 };
    std::atomic<int64_t> active_reads_ms{ 0 };
    std::atomic<int64_t> active_writes_ms{ 0 };
} GST;

static int jitter(std::mt19937& rng, int mean_ms) {
    if (mean_ms <= 0) return 0;
    int lower = (mean_ms - mean_ms / 2 < 0) ? 0 : (mean_ms - mean_ms / 2);
    int upper = mean_ms + mean_ms / 2;
    std::uniform_int_distribution<int> d(lower, upper);
    return d(rng);
}

static DWORD wait_or_time(HANDLE h, DWORD timeout_ms, int64_t& blocked_accum_ms) {
    auto t0 = std::chrono::high_resolution_clock::now();
    DWORD res = WaitForSingleObject(h, timeout_ms);
    auto t1 = std::chrono::high_resolution_clock::now();
    blocked_accum_ms += std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();
    return res;
}

static void release_mutex(HANDLE h) {
    if (h) ReleaseMutex(h);
}

static void release_semaphore(HANDLE h) {
    if (h) ReleaseSemaphore(h, 1, NULL);
}

struct ReaderArgs {
    Config cfg;
    int id;
    unsigned seed;
};

DWORD WINAPI ReaderThread(LPVOID param) {
    ReaderArgs* A = reinterpret_cast<ReaderArgs*>(param);
    std::mt19937 rng(A->seed ? A->seed : (unsigned)std::random_device{}());
    ThreadStats stats;

    printf("[Reader %d] started (seed=%u)\n", A->id, A->seed);

    for (int op = 0; op < A->cfg.operations_per_thread; ++op) {
        Sleep(jitter(rng, A->cfg.mean_think_ms_reader));

        int64_t blocked_now = 0;
        DWORD rr = wait_or_time(r, A->cfg.wait_timeout_ms, blocked_now);
        if (rr != WAIT_OBJECT_0) {
            stats.failures++;
            GST.failed_reads++;
            stats.blocked_ms += blocked_now;
            GST.blocked_reads_ms += blocked_now;
            printf("[Reader %d] op %d: wait r failed code=%lu blocked_ms=%lld\n", A->id, op, (unsigned long)rr, (long long)blocked_now);
            continue;
        }

        rr = wait_or_time(mutex1, A->cfg.wait_timeout_ms, blocked_now);
        if (rr != WAIT_OBJECT_0) {
            release_semaphore(r);
            stats.failures++;
            GST.failed_reads++;
            stats.blocked_ms += blocked_now;
            GST.blocked_reads_ms += blocked_now;
            printf("[Reader %d] op %d: wait mutex1 failed code=%lu blocked_ms=%lld\n", A->id, op, (unsigned long)rr, (long long)blocked_now);
            continue;
        }

        int rc = ++readcount;
        if (rc == 1) {
            DWORD wr = wait_or_time(w, A->cfg.wait_timeout_ms, blocked_now);
            if (wr != WAIT_OBJECT_0) {
                --readcount;
                release_mutex(mutex1);
                release_semaphore(r);
                stats.failures++;
                GST.failed_reads++;
                stats.blocked_ms += blocked_now;
                GST.blocked_reads_ms += blocked_now;
                printf("[Reader %d] op %d: wait w failed for first reader code=%lu blocked_ms=%lld\n", A->id, op, (unsigned long)wr, (long long)blocked_now);
                continue;
            }
        }

        release_mutex(mutex1);
        release_semaphore(r);

        auto t0 = std::chrono::high_resolution_clock::now();
        Sleep(jitter(rng, A->cfg.mean_read_ms));
        int val = RESOURCE.load();
        auto t1 = std::chrono::high_resolution_clock::now();
        int64_t active_now = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();

        DWORD mr = wait_or_time(mutex1, A->cfg.wait_timeout_ms, blocked_now);
        if (mr == WAIT_OBJECT_0) {
            int rc2 = --readcount;
            if (rc2 == 0) {
                release_semaphore(w);
            }
            release_mutex(mutex1);

            stats.successes++;
            stats.active_ms += active_now;
            stats.blocked_ms += blocked_now;

            GST.total_reads++;
            GST.active_reads_ms += active_now;
            GST.blocked_reads_ms += blocked_now;
        }
        else {
            stats.failures++;
            stats.blocked_ms += blocked_now;
            GST.failed_reads++;
            GST.blocked_reads_ms += blocked_now;
        }
    }

    printf("[Reader %d] finished: success=%d fail=%d blocked_ms=%lld active_ms=%lld\n",
        A->id, stats.successes, stats.failures,
        (long long)stats.blocked_ms, (long long)stats.active_ms);
    delete A;
    return 0;
}

struct WriterArgs {
    Config cfg;
    int id;
    unsigned seed;
};

DWORD WINAPI WriterThread(LPVOID param) {
    WriterArgs* A = reinterpret_cast<WriterArgs*>(param);
    std::mt19937 rng(A->seed ? A->seed : (unsigned)std::random_device{}());
    ThreadStats stats;

    printf("[Writer %d] started (seed=%u)\n", A->id, A->seed);

    for (int op = 0; op < A->cfg.operations_per_thread; ++op) {
        Sleep(jitter(rng, A->cfg.mean_think_ms_writer));

        int64_t blocked_now = 0;
        DWORD m2 = wait_or_time(mutex2, A->cfg.wait_timeout_ms, blocked_now);
        if (m2 != WAIT_OBJECT_0) {
            stats.failures++;
            GST.failed_writes++;
            GST.blocked_writes_ms += blocked_now;
            stats.blocked_writes_ms += blocked_now;
            continue;
        }

        int wc = ++writecount;
        if (wc == 1) {
            DWORD rr = wait_or_time(r, A->cfg.wait_timeout_ms, blocked_now);
            if (rr != WAIT_OBJECT_0) {
                --writecount;
                release_mutex(mutex2);
                stats.failures++;
                GST.failed_writes++;
                GST.blocked_writes_ms += blocked_now;
                stats.blocked_writes_ms += blocked_now;
                continue;
            }
        }
        release_mutex(mutex2);

        DWORD wr = wait_or_time(w, A->cfg.wait_timeout_ms, blocked_now);
        if (wr != WAIT_OBJECT_0) {
            DWORD m2b = wait_or_time(mutex2, A->cfg.wait_timeout_ms, blocked_now);
            if (m2b == WAIT_OBJECT_0) {
                int wc2 = --writecount;
                if (wc2 == 0) release_semaphore(r);
                release_mutex(mutex2);
            }
            stats.failures++;
            GST.failed_writes++;
            GST.blocked_writes_ms += blocked_now;
            stats.blocked_writes_ms += blocked_now;
            continue;
        }

        auto t0 = std::chrono::high_resolution_clock::now();
        Sleep(jitter(rng, A->cfg.mean_write_ms));
        int newval = RESOURCE.load() + 1;
        RESOURCE.store(newval);
        auto t1 = std::chrono::high_resolution_clock::now();
        int64_t active_now = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();

        release_semaphore(w);

        DWORD m2c = wait_or_time(mutex2, A->cfg.wait_timeout_ms, blocked_now);
        if (m2c == WAIT_OBJECT_0) {
            int wc3 = --writecount;
            if (wc3 == 0) release_semaphore(r);
            release_mutex(mutex2);

            stats.successes++;
            stats.active_ms += active_now;
            stats.blocked_writes_ms += blocked_now;

            GST.total_writes++;
            GST.active_writes_ms += active_now;
            GST.blocked_writes_ms += blocked_now;
        }
        else {
            stats.failures++;
            stats.blocked_writes_ms += blocked_now;
            GST.failed_writes++;
            GST.blocked_writes_ms += blocked_now;
        }
    }

    printf("[Writer %d] finished: success=%d fail=%d blocked_ms=%lld active_ms=%lld\n",
        A->id, stats.successes, stats.failures,
        (long long)stats.blocked_ms, (long long)stats.active_ms);
    delete A;
    return 0;
}

static bool init_sync() {
    mutex1 = CreateMutex(NULL, FALSE, NULL);
    mutex2 = CreateMutex(NULL, FALSE, NULL);
    w = CreateSemaphore(NULL, 1, 1, NULL);
    r = CreateSemaphore(NULL, 1, 1, NULL);
    return mutex1 && mutex2 && w && r;
}

static void destroy_sync() {
    if (mutex1) { CloseHandle(mutex1); mutex1 = NULL; }
    if (mutex2) { CloseHandle(mutex2); mutex2 = NULL; }
    if (w) { CloseHandle(w); w = NULL; }
    if (r) { CloseHandle(r); r = NULL; }
}

static void reset_globals() {
    readcount.store(0);
    writecount.store(0);
    RESOURCE.store(0);

    GST.total_reads.store(0);
    GST.total_writes.store(0);
    GST.failed_reads.store(0);
    GST.failed_writes.store(0);
    GST.blocked_reads_ms.store(0);
    GST.blocked_writes_ms.store(0);
    GST.active_reads_ms.store(0);
    GST.active_writes_ms.store(0);
}

static void run_test(const Config& cfg) {
    printf("\n\n=== Running test: %s ===\n", cfg.name.c_str());
    reset_globals();

    if (!init_sync()) {
        printf("Failed to init sync primitives for test %s\n", cfg.name.c_str());
        return;
    }

    printf("Config: R=%d W=%d ops=%d thinkR=%dms thinkW=%dms read=%dms write=%dms timeout=%dms seed=%u\n",
        cfg.readers, cfg.writers, cfg.operations_per_thread,
        cfg.mean_think_ms_reader, cfg.mean_think_ms_writer,
        cfg.mean_read_ms, cfg.mean_write_ms, cfg.wait_timeout_ms, cfg.seed);

    std::vector<HANDLE> threads;
    threads.reserve(cfg.readers + cfg.writers);

    for (int i = 0; i < cfg.readers; ++i) {
        ReaderArgs* A = new ReaderArgs{ cfg, i, cfg.seed ? cfg.seed + (unsigned)i : 0 };
        HANDLE h = CreateThread(NULL, 0, ReaderThread, A, 0, NULL);
        if (h) {
            threads.push_back(h);
            printf("Created Reader %d (handle=%p)\n", i, (void*)h);
        }
        else {
            delete A;
            printf("Failed to create reader %d\n", i);
        }
    }

    for (int i = 0; i < cfg.writers; ++i) {
        WriterArgs* A = new WriterArgs{ cfg, i, cfg.seed ? cfg.seed + (unsigned)(1000 + i) : 0 };
        HANDLE h = CreateThread(NULL, 0, WriterThread, A, 0, NULL);
        if (h) {
            threads.push_back(h);
            printf("Created Writer %d (handle=%p)\n", i, (void*)h);
        }
        else {
            delete A;
            printf("Failed to create writer %d\n", i);
        }
    }

    printf("Total threads created: %zu\n", threads.size());

    if (!threads.empty()) {
        WaitForMultipleObjects((DWORD)threads.size(), threads.data(), TRUE, INFINITE);
        for (HANDLE h : threads) CloseHandle(h);
    }
    else {
        printf("No threads created for test %s\n", cfg.name.c_str());
    }

    printf("\n---- Results for %s ----\n", cfg.name.c_str());
    printf("Reads: success=%d fail=%d | Writes: success=%d fail=%d\n",
        GST.total_reads.load(), GST.failed_reads.load(),
        GST.total_writes.load(), GST.failed_writes.load());

    auto br = GST.blocked_reads_ms.load();
    auto bw = GST.blocked_writes_ms.load();
    auto ar = GST.active_reads_ms.load();
    auto aw = GST.active_writes_ms.load();

    printf("Blocked time: readers=%lld ms writers=%lld ms\n", (long long)br, (long long)bw);
    printf("Active time:  readers=%lld ms writers=%lld ms\n", (long long)ar, (long long)aw);

    double total_time_s = (double)(br + bw + ar + aw) / 1000.0;
    double throughput_r = total_time_s > 0 ? (double)GST.total_reads.load() / total_time_s : 0.0;
    double throughput_w = total_time_s > 0 ? (double)GST.total_writes.load() / total_time_s : 0.0;

    printf("Throughput: read=%.2f ops/s, write=%.2f ops/s\n", throughput_r, throughput_w);

    destroy_sync();
}

int main() {
    std::vector<Config> tests;

    tests.push_back(Config{
        "Balanced",
        4, 4, 50,
        20, 20, 10, 15,
        500, 42
        });

    tests.push_back(Config{
        "Writer-heavy",
        2, 8, 100,
        30, 10, 10, 20,
        1000, 123
        });

    tests.push_back(Config{
        "Reader-heavy",
        10, 1, 50,
        10, 50, 5, 20,
        500, 777
        });

    tests.push_back(Config{
        "Stress-short-timeout",
        5, 5, 20,
        5, 5, 5, 5,
        10, 999
        });

    for (const auto& cfg : tests) {
        run_test(cfg);
    }

    printf("\nAll tests finished.\n");
    return 0;
}
