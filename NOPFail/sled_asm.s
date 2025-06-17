; sled_asm.s
; A simple assembly program with a buffer overflow vulnerability.

section .data
    prompt db "Enter your data. The 'read' syscall will accept up to 500 bytes:", 10, 0
    prompt_len equ $ - prompt

section .text
    global _start

_start:
    ; This is the main entry point. It just calls our vulnerable function.
    call vulnerable_function

    ; When vulnerable_function returns (or if we don't crash), exit cleanly.
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code 0
    syscall

vulnerable_function:
    ; Set up a new stack frame
    push rbp
    mov rbp, rsp

    ; Allocate 100 bytes on the stack for our buffer
    sub rsp, 100

    ; Print the prompt
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; fd: stdout
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read user input into the buffer
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; fd: stdin
    mov rsi, rsp        ; The buffer is at the top of the stack (RSP)
    mov rdx, 500        ; VULNERABILITY! Read up to 500 bytes into a 100-byte buffer.
    syscall

    ; Clean up the stack frame and return
    leave               ; Equivalent to: mov rsp, rbp; pop rbp
    ret                 ; Pop the return address and jump to it