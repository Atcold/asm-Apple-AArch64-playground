.section __TEXT,__text,regular,pure_instructions

.global _main

_main:
    ; Perform multiplication
    mov x24, #6          ; First number
    mov x25, #7          ; Second number
    mul x26, x24, x25    ; x26 = x24 * x25
    
    ; Setup for conversion loop
    mov x21, #10         ; Divisor for decimal conversion
    adrp x1, result@GOTPAGE    
    ldr x1, [x1, result@GOTPAGEOFF]
    
    ; Convert three numbers (x24, x25, x26) to ASCII
    mov x9, #0           ; Counter for which number we're converting
convert_loop:
    ; Select number to convert based on counter
    cmp x9, #0
    beq select_first
    cmp x9, #1
    beq select_second
    mov x10, x26         ; Third number (result)
    b convert_digits

select_first:
    mov x10, x24         ; First number
    b convert_digits

select_second:
    mov x10, x25         ; Second number

convert_digits:
    ; Convert to ASCII
    udiv x22, x10, x21        ; Get tens digit
    msub x23, x22, x21, x10   ; Get ones digit
    add x22, x22, #'0'        ; Convert tens to ASCII
    add x23, x23, #'0'        ; Convert ones to ASCII
    
    ; Store at correct position
    cmp x9, #0
    beq store_first
    cmp x9, #1
    beq store_second
    b store_result
    
store_first:
    strb w23, [x1]       ; Store at position 0
    b continue
store_second:
    strb w23, [x1, #4]   ; Store at position 4
    b continue
store_result:
    strb w22, [x1, #8]   ; Store at position 8,9
    strb w23, [x1, #9]
    
continue:
    add x9, x9, #1       ; Increment counter
    cmp x9, #3           ; Check if we've done all three numbers
    b.lt convert_loop

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