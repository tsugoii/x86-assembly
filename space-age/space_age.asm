section .rodata
global orbital_periods
    ; immutable table holding our planet's orbital periods
orbital_periods:
    dd 0.2408467
    dd 0.61519726
    dd 1.0
    dd 1.8808158
    dd 11.862615
    dd 29.447498
    dd 84.016846
    dd 164.79132

global seconds_per_year
    ; immutable table holding the number of seconds in a year
seconds_per_year:
    dd 31557600.0

section .text
global age
age:
    ; --- Prologue ---
    push rbp
    mov  rbp, rsp
    push rbx

    ; --- implementation ---
    ; step 1, convert seconds to earth years
    ; move seconds per year value to register for floating point division
    movss xmm1, [rel seconds_per_year]
    ; convert integer input to floating point and move to fp register
    cvtsi2ss xmm0, rsi
    ; divide input by seconds per year, giving us an age in earth years
    divss xmm0, xmm1

    ; step 2, convert earth years to queried years
    ; load table location
    lea rbx, [rel orbital_periods]
    ; each table entry if 4 bytes, so applying a 4 byte offset
    imul rdi, 4
    ; calculates base address + offest and moves to fp register
    movss xmm1, [rbx + rdi]
    ; divide earth years by space years
    divss xmm0, xmm1

    ; --- Epilogue ---
    pop rbx
    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
