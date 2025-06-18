#include <stdio.h>
#include <string.h>
#include <unistd.h>

/*
 * This function contains a format string vulnerability that we
 * will use to leak an address from the C library (libc).
 */
void vulnerable_leak() {
    char buffer[128];
    puts("I will echo back a secret. What is it?");
    fflush(stdout); // Make sure the prompt appears before reading

    read(0, buffer, sizeof(buffer)); // Read input for the format string bug

    printf("I heard: ");
    printf(buffer); // THE FORMAT STRING VULNERABILITY
    fflush(stdout); // Ensure the leaked address is printed
}

/*
 * This function contains a standard buffer overflow. We will
 * use this to hijack the return address with our ROP chain.
 */
void vulnerable_overflow() {
    char buffer[64];
    puts("\nNow, what is your name?");
    fflush(stdout);

    gets(buffer); // THE BUFFER OVERFLOW VULNERABILITY
}

int main() {
    // Disable buffering to make our interactive exploit script work reliably
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);

    vulnerable_leak();
    vulnerable_overflow();

    puts("\nGoodbye!");
    return 0;
}