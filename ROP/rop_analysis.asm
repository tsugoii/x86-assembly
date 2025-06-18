    ; --- standard prologue ---
   0x00000000004011da <+4>:     push   %rbp
   0x00000000004011db <+5>:     mov    %rsp,%rbp
    ; --- allocate 128 bytes of 0x80 on stack for buffer ---
   0x00000000004011de <+8>:     add    $0xffffffffffffff80,%rsp
    ; --- prep and call puts ("I will echo")
   0x00000000004011e2 <+12>:    lea    0xe1f(%rip),%rax        # 0x402008
   0x00000000004011e9 <+19>:    mov    %rax,%rdi
   0x00000000004011ec <+22>:    call   0x401090 <puts@plt>
    ; --- prep and call flush(stdout) ---
   0x00000000004011f1 <+27>:    mov    0x2e48(%rip),%rax        # 0x404040 <stdout@GLIBC_2.2.5>
   0x00000000004011f8 <+34>:    mov    %rax,%rdi
   0x00000000004011fb <+37>:    call   0x4010d0 <fflush@plt>
    ; --- prep and call read ---
   0x0000000000401200 <+42>:    lea    -0x80(%rbp),%rax # address RBP - buffer
   0x0000000000401204 <+46>:    mov    $0x80,%edx # max read (128 / buffer size)
   0x0000000000401209 <+51>:    mov    %rax,%rsi # buffer address
   0x000000000040120c <+54>:    mov    $0x0,%edi # 0 / stdin
   0x0000000000401211 <+59>:    call   0x4010b0 <read@plt>
    ; --- prep and call safe print ("I heard: ")
   0x0000000000401216 <+64>:    lea    0xe12(%rip),%rax        # 0x40202f
   0x000000000040121d <+71>:    mov    %rax,%rdi # buffer address
   0x0000000000401220 <+74>:    mov    $0x0,%eax # 0 needed for printf
   0x0000000000401225 <+79>:    call   0x4010a0 <printf@plt>
    ; --- prep and call unsafe print (buffer)
   0x000000000040122a <+84>:    lea    -0x80(%rbp),%rax # address of our buffer
   0x000000000040122e <+88>:    mov    %rax,%rdi # rbp is loaded into rdi
   0x0000000000401231 <+91>:    mov    $0x0,%eax
   0x0000000000401236 <+96>:    call   0x4010a0 <printf@plt> # rdi(rbp) passed to printf. vulnerability here
    ; --- stdout again ---
   0x000000000040123b <+101>:   mov    0x2dfe(%rip),%rax        # 0x404040 <stdout@GLIBC_2.2.5>
   0x0000000000401242 <+108>:   mov    %rax,%rdi
   0x0000000000401245 <+111>:   call   0x4010d0 <fflush@plt>
    ; --- standard epilogue ---
   0x000000000040124a <+116>:   nop
   0x000000000040124b <+117>:   leave
   0x000000000040124c <+118>:   ret