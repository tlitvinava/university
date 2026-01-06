// LogClient.cpp
#include <windows.h>
#include <cstdio>
#include <string>

static const wchar_t* PIPE_NAME = L"\\\\.\\pipe\\LogServer";
static const int MAX_RETRIES = 10;
static const int RETRY_DELAY_MS = 500;

HANDLE connectPipe() {
    HANDLE hPipe = INVALID_HANDLE_VALUE;
    for (int attempt = 0; attempt < MAX_RETRIES; ++attempt) {
        hPipe = CreateFileW(PIPE_NAME, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hPipe != INVALID_HANDLE_VALUE) return hPipe;
        DWORD err = GetLastError();
        if (err == ERROR_PIPE_BUSY) {
            WaitNamedPipeW(PIPE_NAME, 2000);
        }
        Sleep(RETRY_DELAY_MS);
    }
    return INVALID_HANDLE_VALUE;
}

int wmain(int argc, wchar_t** argv) {
    int clientId = (argc >= 2) ? _wtoi(argv[1]) : 1;
    int count = (argc >= 3) ? _wtoi(argv[2]) : 10;
    DWORD pauseMs = (argc >= 4) ? _wtoi(argv[3]) : 200;

    wprintf(L"Client #%d connecting...\n", clientId);
    HANDLE hPipe = connectPipe();
    if (hPipe == INVALID_HANDLE_VALUE) {
        wprintf(L"Failed to connect to server.\n");
        return 1;
    }

    DWORD mode = PIPE_READMODE_MESSAGE;
    SetNamedPipeHandleState(hPipe, &mode, NULL, NULL);

    for (int i = 0; i < count; ++i) {
        std::wstring wmsg = L"client=" + std::to_wstring(clientId) + L" msg=" + std::to_wstring(i);
        std::string msg(wmsg.begin(), wmsg.end());
        DWORD written = 0;
        BOOL ok = WriteFile(hPipe, msg.c_str(), (DWORD)msg.size(), &written, NULL);
        if (!ok) {
            DWORD err = GetLastError();
            if (err == ERROR_PIPE_NOT_CONNECTED || err == ERROR_BROKEN_PIPE) {
                CloseHandle(hPipe);
                hPipe = connectPipe();
                if (hPipe == INVALID_HANDLE_VALUE) break;
                SetNamedPipeHandleState(hPipe, &mode, NULL, NULL);
                WriteFile(hPipe, msg.c_str(), (DWORD)msg.size(), &written, NULL);
            }
            else {
                wprintf(L"WriteFile failed at %d (err=%lu)\n", i, err);
                break;
            }
        }
        Sleep(pauseMs);
    }

    CloseHandle(hPipe);
    wprintf(L"Client #%d done.\n", clientId);
    return 0;
}
