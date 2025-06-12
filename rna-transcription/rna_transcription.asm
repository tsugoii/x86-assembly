section .rodata
global lookup_table
lookup_table:
    ; Bytes before 'A' (ASCII 65) are set to 0.
    times 'A' db 0
    ; A -> U
    db 'U'
    ; Bytes between 'A' and 'C'
    times 'C' - 'A' - 1 db 0
    ; C -> G
    db 'G'
    ; Bytes between 'C' and 'G'
    times 'G' - 'C' - 1 db 0
    ; G -> C
    db 'C'
    ; Bytes between 'G' and 'T'
    times 'T' - 'G' - 1 db 0
    ; T -> A
    db 'A'
    ; All bytes after 'T' to fill the rest of the 256-byte table.
    times 256 - 'T' - 1 db 0

section .text
global to_rna
to_rna:
    ; --- Prologue ---
    ; Standard stack frame setup.
    push rbp
    mov  rbp, rsp
    ; Save rbx, as it is a "callee-saved" register and we will use it.
    push rbx
    
    ; --- Implementation ---
    ; Load the effective address of our lookup table into rbx.
    ; rbx is the required base register for the XLATB instruction.
    lea  rbx, [rel lookup_table]

.loop:
    ; Read one byte from the source DNA string (pointed to by rdi) into al.
    mov  al, [rdi]
    ; Check if the character is a null terminator (end of the string).
    test al, al
    jz   .finished      ; If it's zero, the loop is done.

    ; Translate the byte using the lookup table.
    ; This uses al as an index into the table pointed to by rbx
    ; and stores the result back into al.
    xlatb

    ; Write the translated character to the destination RNA buffer (pointed to by rsi).
    mov  [rsi], al
    ; Move both pointers to the next position for the next character.
    inc  rdi
    inc  rsi
    ; Repeat the loop.
    jmp  .loop

.finished:
    ; Add a null terminator to the end of the new RNA string.
    mov  byte [rsi], 0
    
    ; --- Epilogue ---
    ; Restore the callee-saved rbx register.
    pop  rbx
    ; Standard stack frame teardown.
    pop  rbp
    ret
    
; This section is often included for security compliance in modern toolchains.
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif