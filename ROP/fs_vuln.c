#include <stdio.h>
#include <string.h>
#include <unistd.h>

void vulnerable_loop() {
    char buffer[128];

    // This loop gives us multiple chances to send payloads
    while (1) {
        puts("\nSend me a format string:");
        fflush(stdout);

        // Read up to 127 bytes from stdin
        int bytes_read = read(0, buffer, sizeof(buffer) - 1);

        // If read fails or gets no data (like Ctrl+D), exit the loop
        if (bytes_read <= 0) {
            break;
        }
        buffer[bytes_read] = '\0'; // Null terminate the input

        // This is the only vulnerability. We will use it for both leaking and writing.
        printf(buffer);
    }
}

int main() {
    // Disable buffering to make interaction easier
    setvbuf(stdout, NULL, _IONBF, 0);
    vulnerable_loop();
    return 0;
}