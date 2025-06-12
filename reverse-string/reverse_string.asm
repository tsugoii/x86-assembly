section .text
global reverse

reverse:
    ; --- Prologue ---
    push rbp
    mov  rbp, rsp

    ; --- Find the end of the string ---
    ; rdi holds the start address, which is our "left" pointer.
    ; We'll use rsi as our "right" pointer and move it to the end.
    mov  rsi, rdi

.find_end_loop:
    cmp  byte [rsi], 0  ; Is the character at rsi the null terminator?
    je   .found_end     ; If yes, we've found the end.
    inc  rsi            ; Otherwise, move to the next character.
    jmp  .find_end_loop

.found_end:
    dec  rsi            ; rsi points to the null terminator; move it back one
                        ; to point to the last actual character.

    ; --- Main reversal loop ---
.reverse_loop:
    ; Check if the left pointer has met or crossed the right pointer.
    cmp  rdi, rsi
    jnb  .reverse_done   ; Jump if Not Below (if rdi >= rsi), the string is reversed.

    ; Swap the bytes at the left (rdi) and right (rsi) pointers.
    mov  al, [rdi]       ; 1. Copy left char into a temporary register.
    mov  bl, [rsi]       ; 2. Copy right char into another temporary register.
    mov  [rdi], bl       ; 3. Move the saved right char to the left's memory location.
    mov  [rsi], al       ; 4. Move the saved left char to the right's memory location.

    ; Move the pointers toward the middle.
    inc  rdi
    dec  rsi
    jmp  .reverse_loop   ; Go back to the top of the loop to check again.

.reverse_done:
    ; The loop is finished. Now we clean up and return.

    ; --- Epilogue ---
    mov  rsp, rbp
    pop  rbp
    ret

; This section is often included for security compliance in modern toolchains.
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif