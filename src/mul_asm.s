.section __TEXT,__text,regular,pure_instructions

.global _main

_main:
    ; Perform multiplication
    mov x24, #6          ; First number
    mov x25, #7          ; Second number
    mul x19, x24, x25    ; x19 = x24 * x25
    
    ; Setup for conversion loop
    mov x21, #10         ; Divisor for decimal conversion
    adrp x8, result@GOTPAGE    
    ldr x8, [x8, result@GOTPAGEOFF]
    
    ; Convert three numbers (x24, x25, x19) to ASCII
    mov x9, #0          ; Counter for which number we're converting
convert_loop:
    ; Select number to convert based on counter
    cmp x9, #0
    beq select_first
    cmp x9, #1
    beq select_second
    mov x10, x19        ; Third number (result)
    b convert_digits

select_first:
    mov x10, x24        ; First number
    b convert_digits

select_second:
    mov x10, x25        ; Second number

convert_digits:
    ; Convert to ASCII
    udiv x22, x10, x21        ; Get tens digit
    msub x23, x22, x21, x10   ; Get ones digit
    add x22, x22, #'0'        ; Convert tens to ASCII
    add x23, x23, #'0'        ; Convert ones to ASCII
    
    ; Store at correct position
    mov x10, #0               ; Base offset
    cmp x9, #0
    beq store_first
    cmp x9, #1
    beq store_second
    b store_result
    
store_first:
    strb w22, [x8]           ; Store at position 0,1
    strb w23, [x8, #1]
    b continue
store_second:
    strb w22, [x8, #5]       ; Store at position 5,6
    strb w23, [x8, #6]
    b continue
store_result:
    strb w22, [x8, #10]      ; Store at position 10,11
    strb w23, [x8, #11]
    
continue:
    add x9, x9, #1           ; Increment counter
    cmp x9, #3               ; Check if we've done all three numbers
    b.lt convert_loop

    ; Write result to stdout
    mov x0, #1          ; File descriptor: stdout
    adrp x1, result@GOTPAGE
    ldr x1, [x1, result@GOTPAGEOFF]
    mov x2, #13         ; Message length (13 chars total)
    movz x16, #0x2000, lsl #16
    movk x16, #0x0004
    svc #0

    ; Exit program
    mov x0, #0
    ret

.section __DATA,__data
result:
    .ascii "?? * ?? = ??\n"    ; 13 chars total