#include <winsock2.h>
#include <ws2tcpip.h>   
#include <iostream>
#include <thread>
#pragma comment(lib, "ws2_32.lib")

void receiveMessages(SOCKET sock) {
    char buffer[1024];
    while (true) {
        int bytes = recv(sock, buffer, sizeof(buffer) - 1, 0);
        if (bytes <= 0) break;
        buffer[bytes] = '\0';
        std::cout << "Server: " << buffer << std::endl;
    }
}

int main() {
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        std::cerr << "WSAStartup failed\n";
        return 1;
    }

    SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == INVALID_SOCKET) {
        std::cerr << "Socket creation failed\n";
        WSACleanup();
        return 1;
    }

    sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8080);

    if (InetPton(AF_INET, L"127.0.0.1", &addr.sin_addr) <= 0) {
        std::cerr << "Invalid address\n";
        closesocket(sock);
        WSACleanup();
        return 1;
    }

    if (connect(sock, (sockaddr*)&addr, sizeof(addr)) == SOCKET_ERROR) {
        std::cerr << "Connection failed\n";
        closesocket(sock);
        WSACleanup();
        return 1;
    }

    std::cout << "Connected to server!\n";

    std::thread t(receiveMessages, sock);

    while (true) {
        std::string msg;
        std::getline(std::cin, msg);
        if (msg.empty()) continue;
        send(sock, msg.c_str(), msg.size(), 0);
    }

    t.join();
    closesocket(sock);
    WSACleanup();
    return 0;
}
