.section __TEXT,__text,regular,pure_instructions

.global _main

_main:
    ; Perform multiplication
    mov x24, #6          ; First number
    mov x25, #7          ; Second number
    mul x26, x24, x25    ; x26 = x24 * x25
    
    ; Setup for conversion loop
    adrp x1, result@GOTPAGE    
    ldr x1, [x1, result@GOTPAGEOFF]
    
    ; Convert x24 and x25 to ASCII
    add x24, x24, #'0'
    add x25, x25, #'0'

    ; Convert x26 to ASCII
    mov x10, #10
    udiv x22, x26, x10        ; Get tens digit
    msub x23, x22, x10, x26   ; Get ones digit
    add x22, x22, #'0'        ; Convert tens to ASCII
    add x23, x23, #'0'        ; Convert ones to ASCII

    ; Store x24, x25, and x22, x23
    strb w24, [x1]       ; Store at position 0
    strb w25, [x1, #4]   ; Store at position 4
    strb w22, [x1, #8]   ; Store at position 8,9
    strb w23, [x1, #9]

    ; Write result to stdout
    mov x0, #1           ; File descriptor: stdout
    mov x2, #11          ; Message length (11 chars total)
    movz x16, #0x2000, lsl #16
    movk x16, #0x0004
    svc #0

    ; Exit program
    mov x0, #0
    ret

.section __DATA,__data
result:
    .ascii "? * ? = ??\n"    ; 11 chars total