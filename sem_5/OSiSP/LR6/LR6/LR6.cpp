#define WIN32_LEAN_AND_MEAN
#define _WIN32_WINNT 0x0600
#define _WIN32_DCOM

#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <iphlpapi.h>
#include <wbemidl.h>
#include <comdef.h>

#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <locale>

#pragma comment(lib, "wbemuuid.lib")
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "oleaut32.lib")
#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "Ws2_32.lib")

std::wstring BStrToWString(BSTR bstr) {
    if (!bstr) return L"";
    return std::wstring(bstr, SysStringLen(bstr));
}

std::wstring FormatBytes(unsigned long long bytes) {
    const double KB = 1024.0;
    const double MB = KB * 1024.0;
    const double GB = MB * 1024.0;
    const double TB = GB * 1024.0;
    double b = static_cast<double>(bytes);
    std::wstringstream ss;
    ss << std::fixed << std::setprecision(2);
    if (b >= TB) ss << (b / TB) << L" TB";
    else if (b >= GB) ss << (b / GB) << L" GB";
    else if (b >= MB) ss << (b / MB) << L" MB";
    else if (b >= KB) ss << (b / KB) << L" KB";
    else ss << bytes << L" B";
    return ss.str();
}

std::wstring IpAddrToString(const SOCKADDR* addr) {
    if (!addr) return L"";
    wchar_t buf[128] = { 0 };
    DWORD buflen = sizeof(buf) / sizeof(wchar_t);
    DWORD addrLen = (addr->sa_family == AF_INET) ? sizeof(SOCKADDR_IN) : sizeof(SOCKADDR_IN6);
    if (WSAAddressToStringW((LPSOCKADDR)addr, addrLen, nullptr, buf, &buflen) == 0) {
        return std::wstring(buf);
    }
    return L"";
}

std::wstring MacToString(const BYTE* mac, ULONG len) {
    if (!mac || len == 0) return L"(n/a)";
    std::wstringstream ss;
    ss << std::hex << std::setfill(L'0');
    for (ULONG i = 0; i < len; ++i) {
        ss << std::setw(2) << (int)mac[i];
        if (i + 1 < len) ss << L":";
    }
    return ss.str();
}

void PrintHeader(const std::wstring& title) {
    std::wcout << L"\n=== " << title << L" ===\n";
}

struct WmiContext {
    IWbemLocator* pLocator = nullptr;
    IWbemServices* pServices = nullptr;
    bool ok = false;

    bool Initialize() {
        HRESULT hr = CoInitializeEx(0, COINIT_MULTITHREADED);
        if (FAILED(hr)) {
            std::wcerr << L"[Ошибка] CoInitializeEx: 0x" << std::hex << hr << std::dec << L"\n";
            return false;
        }
        hr = CoInitializeSecurity(
            NULL,
            -1,
            NULL,
            NULL,
            RPC_C_AUTHN_LEVEL_DEFAULT,
            RPC_C_IMP_LEVEL_IMPERSONATE,
            NULL,
            EOAC_NONE,
            NULL
        );
        if (FAILED(hr) && hr != RPC_E_TOO_LATE) {
            std::wcerr << L"[Ошибка] CoInitializeSecurity: 0x" << std::hex << hr << std::dec << L"\n";
            CoUninitialize();
            return false;
        }

        hr = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (LPVOID*)&pLocator);
        if (FAILED(hr)) {
            std::wcerr << L"[Ошибка] CoCreateInstance(IWbemLocator): 0x" << std::hex << hr << std::dec << L"\n";
            CoUninitialize();
            return false;
        }

        hr = pLocator->ConnectServer(
            _bstr_t(L"ROOT\\CIMV2"),
            NULL,
            NULL,
            0,
            NULL,
            0,
            0,
            &pServices
        );
        if (FAILED(hr)) {
            std::wcerr << L"[Ошибка] ConnectServer(ROOT\\CIMV2): 0x" << std::hex << hr << std::dec << L"\n";
            pLocator->Release();
            CoUninitialize();
            return false;
        }

        hr = CoSetProxyBlanket(
            pServices,
            RPC_C_AUTHN_WINNT,
            RPC_C_AUTHZ_NONE,
            NULL,
            RPC_C_AUTHN_LEVEL_CALL,
            RPC_C_IMP_LEVEL_IMPERSONATE,
            NULL,
            EOAC_NONE
        );
        if (FAILED(hr)) {
            std::wcerr << L"[Ошибка] CoSetProxyBlanket: 0x" << std::hex << hr << std::dec << L"\n";
            pServices->Release();
            pLocator->Release();
            CoUninitialize();
            return false;
        }

        ok = true;
        return true;
    }

    void Cleanup() {
        if (pServices) { pServices->Release(); pServices = nullptr; }
        if (pLocator) { pLocator->Release(); pLocator = nullptr; }
        CoUninitialize();
        ok = false;
    }
};

bool WmiQuery(IWbemServices* svc, const wchar_t* wql, const std::vector<std::wstring>& fields, std::vector<std::vector<std::wstring>>& rows) {
    if (!svc) return false;

    IEnumWbemClassObject* pEnumerator = nullptr;
    HRESULT hr = svc->ExecQuery(
        bstr_t("WQL"),
        bstr_t(wql),
        WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY,
        NULL,
        &pEnumerator
    );
    if (FAILED(hr)) {
        std::wcerr << L"[Ошибка] ExecQuery: " << wql << L" hr=0x" << std::hex << hr << std::dec << L"\n";
        return false;
    }

    IWbemClassObject* pObj = nullptr;
    ULONG uReturn = 0;

    while (pEnumerator) {
        hr = pEnumerator->Next(WBEM_INFINITE, 1, &pObj, &uReturn);
        if (uReturn == 0) break;
        std::vector<std::wstring> row;
        for (const auto& f : fields) {
            VARIANT vtProp;
            VariantInit(&vtProp);
            hr = pObj->Get(bstr_t(f.c_str()), 0, &vtProp, 0, 0);
            if (SUCCEEDED(hr)) {
                if (vtProp.vt == VT_BSTR && vtProp.bstrVal != nullptr) {
                    row.push_back(BStrToWString(vtProp.bstrVal));
                }
                else if (vtProp.vt == VT_NULL) {
                    row.push_back(L"");
                }
                else if (vtProp.vt == VT_I4 || vtProp.vt == VT_INT) {
                    row.push_back(std::to_wstring(vtProp.intVal));
                }
                else if (vtProp.vt == VT_UI4) {
                    row.push_back(std::to_wstring(vtProp.uintVal));
                }
                else if (vtProp.vt == VT_I8) {
                    row.push_back(std::to_wstring(vtProp.llVal));
                }
                else if (vtProp.vt == VT_R8) {
                    std::wstringstream ss; ss << vtProp.dblVal; row.push_back(ss.str());
                }
                else if (vtProp.vt == VT_BOOL) {
                    row.push_back(vtProp.boolVal ? L"True" : L"False");
                }
                else {
                    try {
                        _bstr_t tmp(vtProp);
                        BSTR b = tmp.GetBSTR();
                        row.push_back(BStrToWString(b));
                    }
                    catch (...) {
                        row.push_back(L"(n/a)");
                    }
                }
            }
            else {
                row.push_back(L"(n/a)");
            }
            VariantClear(&vtProp);
        }
        rows.push_back(row);
        pObj->Release();
    }

    if (pEnumerator) pEnumerator->Release();
    return true;
}

void PrintComputerAndUser() {
    PrintHeader(L"Имена компьютера и пользователя");
    WCHAR comp[MAX_COMPUTERNAME_LENGTH + 1]{};
    DWORD size = MAX_COMPUTERNAME_LENGTH + 1;
    if (GetComputerNameW(comp, &size)) {
        std::wcout << L"- Компьютер: " << comp << L"\n";
    }
    else {
        std::wcout << L"- Компьютер: (ошибка)\n";
    }
    WCHAR user[256]{};
    DWORD ulen = 256;
    if (GetUserNameW(user, &ulen)) {
        std::wcout << L"- Пользователь: " << user << L"\n";
    }
    else {
        std::wcout << L"- Пользователь: (ошибка)\n";
    }
}

void PrintOSViaWMI(IWbemServices* svc) {
    PrintHeader(L"Операционная система (WMI)");
    std::vector<std::vector<std::wstring>> rows;
    std::vector<std::wstring> fields = { L"Caption", L"Version", L"BuildNumber", L"OSArchitecture" };
    if (WmiQuery(svc, L"SELECT Caption, Version, BuildNumber, OSArchitecture FROM Win32_OperatingSystem", fields, rows) && !rows.empty()) {
        const auto& r = rows[0];
        std::wcout << L"- Название: " << r[0] << L"\n";
        std::wcout << L"- Версия: " << r[1] << L" (сборка " << r[2] << L")\n";
        std::wcout << L"- Архитектура ОС: " << r[3] << L"\n";
    }
    else {
        std::wcout << L"- (не удалось получить сведения о ОС)\n";
    }
}

void PrintSystemInfoWinAPI() {
    PrintHeader(L"Системная информация (WinAPI)");
    SYSTEM_INFO si{};
    GetNativeSystemInfo(&si);

    std::wstring arch = L"Unknown";
    switch (si.wProcessorArchitecture) {
    case PROCESSOR_ARCHITECTURE_AMD64: arch = L"x64 (AMD or Intel)"; break;
    case PROCESSOR_ARCHITECTURE_INTEL: arch = L"x86"; break;
    case PROCESSOR_ARCHITECTURE_ARM: arch = L"ARM"; break;
    case PROCESSOR_ARCHITECTURE_ARM64: arch = L"ARM64"; break;
    default: break;
    }

    std::wcout << L"- Архитектура процессора: " << arch << L"\n";
    std::wcout << L"- Количество логических процессоров: " << si.dwNumberOfProcessors << L"\n";

    MEMORYSTATUSEX ms{};
    ms.dwLength = sizeof(ms);
    if (GlobalMemoryStatusEx(&ms)) {
        std::wcout << L"- Всего RAM: " << FormatBytes(ms.ullTotalPhys) << L"\n";
        std::wcout << L"- Доступно RAM: " << FormatBytes(ms.ullAvailPhys) << L"\n";
    }
    else {
        std::wcout << L"- RAM: (ошибка)\n";
    }
}

void PrintCPUviaWMI(IWbemServices* svc) {
    PrintHeader(L"Процессор (WMI)");
    std::vector<std::vector<std::wstring>> rows;
    std::vector<std::wstring> fields = { L"Name", L"Manufacturer", L"NumberOfCores", L"NumberOfLogicalProcessors", L"MaxClockSpeed" };
    if (WmiQuery(svc, L"SELECT Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed FROM Win32_Processor", fields, rows)) {
        for (size_t i = 0; i < rows.size(); ++i) {
            const auto& r = rows[i];
            std::wcout << L"* CPU #" << (i + 1) << L"\n";
            std::wcout << L"  - Модель: " << r[0] << L"\n";
            std::wcout << L"  - Производитель: " << r[1] << L"\n";
            std::wcout << L"  - Ядер: " << r[2] << L", Логических: " << r[3] << L"\n";
            std::wcout << L"  - Частота (MaxClockSpeed): " << r[4] << L" MHz\n";
        }
    }
    else {
        std::wcout << L"- (не удалось получить сведения о CPU)\n";
    }
}

void PrintGPUviaWMI(IWbemServices* svc) {
    PrintHeader(L"Видеокарта (WMI)");
    std::vector<std::vector<std::wstring>> rows;
    std::vector<std::wstring> fields = { L"Name", L"DriverVersion", L"AdapterRAM" };
    if (WmiQuery(svc, L"SELECT Name, DriverVersion, AdapterRAM FROM Win32_VideoController", fields, rows)) {
        for (size_t i = 0; i < rows.size(); ++i) {
            const auto& r = rows[i];
            std::wcout << L"* GPU #" << (i + 1) << L"\n";
            std::wcout << L"  - Модель: " << r[0] << L"\n";
            std::wcout << L"  - Версия драйвера: " << r[1] << L"\n";
            unsigned long long vram = 0;
            try { vram = std::stoull(std::string(r[2].begin(), r[2].end())); }
            catch (...) {}
            if (vram) std::wcout << L"  - Память адаптера: " << FormatBytes(vram) << L"\n";
        }
    }
    else {
        std::wcout << L"- (не удалось получить сведения о GPU)\n";
    }
}

void PrintDisksViaWMI(IWbemServices* svc) {
    PrintHeader(L"Диски (WMI)");
    std::vector<std::vector<std::wstring>> rows;
    std::vector<std::wstring> fields = { L"Model", L"InterfaceType", L"Size" };
    if (WmiQuery(svc, L"SELECT Model, InterfaceType, Size FROM Win32_DiskDrive", fields, rows)) {
        for (size_t i = 0; i < rows.size(); ++i) {
            const auto& r = rows[i];
            std::wcout << L"* Диск #" << (i + 1) << L"\n";
            std::wcout << L"  - Модель: " << r[0] << L"\n";
            std::wcout << L"  - Интерфейс: " << r[1] << L"\n";
            unsigned long long sz = 0;
            try { sz = std::stoull(std::string(r[2].begin(), r[2].end())); }
            catch (...) {}
            if (sz) std::wcout << L"  - Объём: " << FormatBytes(sz) << L"\n";
        }
    }
    else {
        std::wcout << L"- (не удалось получить сведения о дисках)\n";
    }
}

void PrintNetworkAdapters() {
    PrintHeader(L"Сетевые адаптеры (IP Helper API)");
    ULONG flags = GAA_FLAG_SKIP_ANYCAST | GAA_FLAG_SKIP_MULTICAST | GAA_FLAG_SKIP_DNS_SERVER;
    ULONG family = AF_UNSPEC;
    ULONG outBufLen = 15 * 1024;
    std::vector<BYTE> buffer(outBufLen);

    DWORD ret = GetAdaptersAddresses(family, flags, nullptr, (IP_ADAPTER_ADDRESSES*)buffer.data(), &outBufLen);
    if (ret == ERROR_BUFFER_OVERFLOW) {
        buffer.resize(outBufLen);
        ret = GetAdaptersAddresses(family, flags, nullptr, (IP_ADAPTER_ADDRESSES*)buffer.data(), &outBufLen);
    }
    if (ret != NO_ERROR) {
        std::wcout << L"- (ошибка GetAdaptersAddresses: " << ret << L")\n";
        return;
    }

    IP_ADAPTER_ADDRESSES* aa = (IP_ADAPTER_ADDRESSES*)buffer.data();
    for (; aa != nullptr; aa = aa->Next) {
        if (aa->IfType == IF_TYPE_SOFTWARE_LOOPBACK) continue;

        std::wstring name = aa->FriendlyName ? aa->FriendlyName : L"(n/a)";
        std::wstring descr = aa->Description ? aa->Description : L"(n/a)";
        std::wcout << L"* Адаптер: " << name << L"\n";
        std::wcout << L"  - Описание: " << descr << L"\n";
        std::wcout << L"  - MAC: " << MacToString(aa->PhysicalAddress, aa->PhysicalAddressLength) << L"\n";
        if (aa->TransmitLinkSpeed != 0)
            std::wcout << L"  - Скорость: " << (aa->TransmitLinkSpeed / 1000000ULL) << L" Mbps\n";
        else
            std::wcout << L"  - Скорость: (n/a)\n";

        std::wcout << L"  - DHCP: " << ((aa->Flags & IP_ADAPTER_DHCP_ENABLED) ? L"Enabled" : L"Disabled") << L"\n";
        std::wcout << L"  - Up: " << ((aa->OperStatus == IfOperStatusUp) ? L"Yes" : L"No") << L"\n";

        IP_ADAPTER_UNICAST_ADDRESS* unicast = aa->FirstUnicastAddress;
        while (unicast) {
            auto fam = unicast->Address.lpSockaddr->sa_family;
            std::wstring ip = IpAddrToString(unicast->Address.lpSockaddr);
            if (!ip.empty()) {
                std::wcout << L"  - " << (fam == AF_INET ? L"IPv4" : L"IPv6") << L": " << ip << L"\n";
            }
            unicast = unicast->Next;
        }
    }
}

int wmain() {
    SetConsoleOutputCP(CP_UTF8);
    std::wcout.imbue(std::locale(""));

    std::wcout << L"Сбор системной информации (WinAPI + WMI)\n";

    PrintComputerAndUser();

    PrintSystemInfoWinAPI();

    WmiContext wmi;
    if (wmi.Initialize()) {
        PrintOSViaWMI(wmi.pServices);
        PrintCPUviaWMI(wmi.pServices);
        PrintGPUviaWMI(wmi.pServices);
        PrintDisksViaWMI(wmi.pServices);
        wmi.Cleanup();
    }
    else {
        std::wcout << L"\n[Предупреждение] WMI недоступен, пропускаем блоки ОС/CPU/GPU/Диски.\n";
    }

    WSADATA wsa{};
    if (WSAStartup(MAKEWORD(2, 2), &wsa) == 0) {
        PrintNetworkAdapters();
        WSACleanup();
    }
    else {
        std::wcout << L"\n[Предупреждение] Не удалось инициализировать Winsock, пропускаем сетевые адреса.\n";
    }

    std::wcout << L"\nГотово.\n";
    return 0;
}
