section .text

; Function 1
global square_of_sum
square_of_sum:
    ; Prologue for square_of_sum
    push rbp
    mov rbp, rsp
    
    ; ... implementation for square_of_sum ...
    mov rcx, rdi ; we're looping over given n
    xor rax, rax ; clear rax
    
.sum_loop:
    add rax, rcx
    dec rcx
    jnz .sum_loop
    imul rax, rax

    ; Epilogue for square_of_sum
    mov  rsp, rbp
    pop  rbp
    ret

; Function 2
global sum_of_squares
sum_of_squares:
    ; Prologue for sum_of_squares
    push rbp
    mov  rbp, rsp

    ; ... implementation for sum_of_squares ...
    mov rcx, rdi ; looping over n
    xor rax, rax ; clear rax

.square_loop:
    mov r9, rcx ; move n to a register
    imul r9, r9 ; square
    add rax, r9 ; add to sum
    dec rcx ; decrement
    jnz .square_loop

    ; Epilogue for sum_of_squares
    mov  rsp, rbp
    pop  rbp
    ret

; Function 3
global difference_of_squares
difference_of_squares:
    ; Prologue for difference_of_squares
    push rbp
    mov  rbp, rsp

    ; ... implementation for difference_of_squares ...
    ; This part will include 'call square_of_sum' and 'call sum_of_squares'
    mov r12, rdi ; move n to temp register
    call square_of_sum
    mov r10, rax ; move result to temp register?
    mov rdi, r12 ; reset n from temp register
    call sum_of_squares
    sub r10, rax ; subtract?
    mov rax, r10 ; move result to rax

    ; Epilogue for difference_of_squares
    mov  rsp, rbp
    pop  rbp
    ret
    
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif