#include <stdio.h>
#include <conio.h>
#include <string.h>

extern "C" void lock_screen();
extern "C" void unlock_screen();
extern "C" char get_password();
extern "C" void log_failed_attempt();

const char* password = "mypassword"; // Predefined password

void log(FILE* file, const char* message) {
    fprintf(file, "%s\n", message);
}

int main() {
    FILE* file = fopen("C:\\TURBOC3\\BIN\\PROJECT\\logs.txt", "a+");
    if (file == NULL) {
        printf("File not found\n");
        getch();
        return 0;
    }

    // Main loop for checking user activity
    while (1) {
        // Lock the screen
        lock_screen();

        // Wait for password input
        char input[20];
        printf("Enter password to unlock: ");
        gets(input); // Use gets for simplicity, but consider using safer alternatives

        // Check the password
        if (strcmp(input, password) == 0) {
            unlock_screen(); // Unlock the screen
            break; // Exit the loop
        } else {
            // Log failed attempt
            log_failed_attempt();
            log(file, "Failed login attempt");
        }
    }

    fclose(file);
    return 0;
}