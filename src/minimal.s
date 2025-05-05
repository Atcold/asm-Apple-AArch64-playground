.section    __TEXT,__text,regular,pure_instructions
.globl  _main
.p2align 2

_main:
    mov     w1, #5          // First number
    mov     w2, #7          // Second number
    mul     w0, w1, w2      // Multiply and put result in w0 (return register)
    ret                     // Return

// gcc -o minimal minimal.s
// ./minimal
// echo $?