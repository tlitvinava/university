#include <winsock2.h>
#include <iostream>
#include <thread>
#pragma comment(lib, "ws2_32.lib")

void handleClient(SOCKET client) {
    char buffer[1024];
    while (true) {
        int bytes = recv(client, buffer, sizeof(buffer) - 1, 0);
        if (bytes <= 0) break;
        buffer[bytes] = '\0';
        std::cout << "Client: " << buffer << std::endl;

        std::string reply;
        std::getline(std::cin, reply);
        send(client, reply.c_str(), reply.size(), 0);
    }
    closesocket(client);
}

int main() {
    WSADATA wsa;
    WSAStartup(MAKEWORD(2, 2), &wsa);

    SOCKET server = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(8080);

    bind(server, (sockaddr*)&addr, sizeof(addr));
    listen(server, 5);

    std::cout << "Server started on port 8080...\n";

    SOCKET client = accept(server, NULL, NULL);
    std::cout << "Client connected!\n";

    std::thread t(handleClient, client);
    t.join();

    closesocket(server);
    WSACleanup();
    return 0;
}
