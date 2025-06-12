section .text
global leap_year
leap_year:
    ; prologue
    push rbp ; Save the old base pointer onto the stack
    mov rbp, rsp ; Set the current stack pointer as the new base pointer

    mov rax, rdi ; move input for division
    xor rdx, rdx ; zero to prepare for division
    mov rcx, 400 ; set our divisor to 400
    div rcx ; divide, remainder will go into rdx
    cmp rdx, 0 ; if no remainder
    je .is_leap_year ; it is a leap year
    mov rax, rdi ; move input for division
    xor rdx, rdx ; zero to prepare
    mov rcx, 100 ; set divisor to 100
    div rcx ; divide
    cmp rdx, 0 ; if no remainder
    je .is_not_leap_year ; it is not a leap year
    mov rax, rdi ; move input for division
    xor rdx, rdx ; zero to prepare
    mov rcx, 4 ; set divisor to 4
    div rcx ; divide
    cmp rdx, 0 ; if no remainder
    je .is_leap_year ; it is a leap year
    jmp .is_not_leap_year ; catch all

.is_leap_year:
    mov rax, 1 ; return true
    jmp .exit
    
.is_not_leap_year:
    mov rax, 0 ; return false
    jmp .exit

.exit:
    ; epilogue
    mov rsp, rbp ; restore stack pointer
    pop rbp ; restore base point
    ret ; return

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
