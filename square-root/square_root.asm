section .text
global square_root
square_root:

    ; --- Prologue ---
    push rbp
    mov rbp, rsp

    ; --- Implementation ---
    ; loop for all 32 bit values
    ; check n >= result + bit
    ; if true n = n - (result + bit)
    ; result = (result >> 1) + bit
    ; if false result = result >> 1
    ; bit = (bit >> 2)

    ; Let's assign our variables to registers
    ; rax is n
    mov  rax, rdi
    ; rdx is result
    xor  rdx, rdx
    ; rcx is test bit
    mov  rcx, 1
    ; set test bit to highest bit
    shl  rcx, 62 

.loop:
    ; if our test bit is the rightmost, end the loop
    cmp rcx, 0
    je .end
    ; result + bit
    mov r8, rdx
    add r8, rcx
    ; compare n to result+bit
    cmp rax, r8
    ; if n < result + bit, go to false
    jl .false
    ; else true
    ; n = n - (result + bit)
    sub rax, r8
    shr rdx, 1
    ; result = result + bit
    add rdx, rcx
    ; go to shift
    jmp .shift

.false:
    ; shift result right
    shr rdx, 1
    jmp .shift

.shift:
    ; shift bit right
    shr rcx, 2
    ; loop
    jmp .loop

.end:
    ; return result in rdx
    mov rax, rdx
    ; --- Epilogue ---
    mov rsp, rbp
    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
