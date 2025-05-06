.section __TEXT,__text,regular,pure_instructions

.global _main

_main:
    ; Write "hello\n" to stdout
    mov x0, #1                  ; File descriptor: stdout
    adrp x1, message@GOTPAGE    ; Load GOT page address
    ldr x1, [x1, message@GOTPAGEOFF] ; Load actual address from GOT
    mov x2, #6                  ; Message length
    movz x16, #0x2000, lsl #16  ; Load upper 16 bits of syscall number: write
    movk x16, #0x0004           ; Load lower 16 bits of syscall number: write
    svc #0                      ; Make syscall

    ; Exit program
    mov x0, #0                  ; Exit code
	ret

.section __TEXT,__cstring
message:
    .asciz "hello\n"