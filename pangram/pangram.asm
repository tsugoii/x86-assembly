; Uninitialized, Writable Data
section .bss
global pangram_table
pangram_table:
    ; reserve 26 bytes for our checklist, initialized to zero by the OS
    resb 26

; For executable code
section .text
global is_pangram
is_pangram:
    ; --- Prologue ---
    push rbp
    mov  rbp, rsp
    push rbx        ; Save rbx to use for our table address

    ; load the location of our checklist into rbx
    lea  rbx, [rel pangram_table]
    ; set check_loop to run 26x
    mov rcx, 26
    ; zero al
    xor al, al

    ; Reset our checking table
.clear_check:
    ; start zeroing everything out
    mov byte [rbx + rcx - 1], al
    ; decrement counter
    dec rcx
    ; repeat if not zero
    jnz .clear_check

    ; --- Phase 1: Populate the checklist ---
.loop:
    movzx eax, byte [rdi]      ; read a character from the input string and pad with 0's
    test al, al         ; check if it's the null terminator
    jz   .final_check   ; if yes, move to phase 2

    or   al, 0x20       ; convert character to lowercase

    ; check if it is within the 'a'-'z' range
    cmp  al, 'a'
    jl   .next_character
    cmp  al, 'z'
    jg   .next_character

    ; if it is a letter, calculate its index (0-25)
    sub  al, 'a'
    ; and mark that position in our checklist as '1'
    mov  byte [rbx + rax], 1

.next_character:
    ; move to the next character in the input string
    inc  rdi
    jmp  .loop

    ; --- Phase 2: Verify the checklist ---
.final_check:
    ; Use rcx as a counter, from 0 to 25
    xor  rcx, rcx

.check_loop:
    ; Check the byte in our table at the current index (rcx)
    cmp  byte [rbx + rcx], 0
    ; If the byte is 0, a letter was missing. It's not a pangram.
    je   .not_a_pangram

    inc  rcx            ; move to the next index
    cmp  rcx, 26        ; have we checked all 26?
    jne  .check_loop    ; if not, loop again

    ; If the loop finishes, all letters were found. It's a pangram.
.is_a_pangram:
    mov  rax, 1         ; set return value to 1 (true)
    jmp  .end

.not_a_pangram:
    mov  rax, 0         ; set return value to 0 (false)
    jmp  .end

    ; --- Epilogue ---
.end:
    pop  rbx            ; Restore rbx
    pop  rbp            ; Restore the stack frame
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif