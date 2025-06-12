section .text
global steps 

steps:
    ; prologue
    push rbx

    ; steps counter initialized to 0
    xor rcx, rcx
    ; rbx = input number (sign-extended int from C)
    mov rbx, rdi

    ; --- Error Handling / Special Cases ---
    ; Check if rbx is 0.
    cmp rbx, 0
    ; If it is 0, jump to error
    je .handle_invalid_input

    ; Check if rbx is greater than the maximum positive 32-bit signed integer
    ; This would catch any value that was originally negative or too large
    ; Load the 32-bit max positive int into r8
    mov r8, 0x7FFFFFFF

    ; Compare rbx with max integer
    cmp rbx, r8
    ; If it's above the max, it's an error
    ja .handle_invalid_input

    ; Handle Base Case: If the starting number is 1, it takes 0 steps.
    cmp rbx, 1
    je .done_normal_path

.loop:
    ; Loop termination condition: If current number is 1, we're done.
    cmp rbx, 1
    je .done_normal_path

    ; Check if rbx is even or odd
    test rbx, 1
    jz .even_case

.odd_case:
    ; Rule for Odd Numbers: n = (3 * n) + 1
    lea rbx, [rbx*2 + rbx]
    inc rbx
    jmp .increment_step
    
.even_case:
    ; Rule for Even Numbers: n = n / 2
    shr rbx, 1

.increment_step:
    ; Increment step counter
    inc rcx
    ; loop
    jmp .loop

; --- Error Return Paths ---
.handle_invalid_input:
    mov rax, -1
    jmp .exit_func

.handle_timeout:
    mov rax, -1
    jmp .exit_func

; --- Normal Function Completion ---
.done_normal_path:
    ; epilogue
    mov rax, rcx
    
; Common exit point for all returns (error or normal)
.exit_func:
    pop rbx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif