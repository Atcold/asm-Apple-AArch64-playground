.section    __TEXT,__text,regular,pure_instructions          ; Define text section for code
    .build_version macos, 15, 0    sdk_version 15, 4         ; Specifies macOS build and SDK version
    .globl    _main                                          ; Declare main as a global symbol
    .p2align    2                                            ; Align to 2^2 bytes (4-byte alignment)
_main:                                                       ; Main function entry point
;    .cfi_startproc                                           ; Start of procedure for call frame info
// ; %bb.0:                                                     ; Basic block 0
    sub    sp, sp, #64                                       ; Allocate 64 bytes on stack
; x registers are 64-bit wide (full width of the architecture)
; w registers are 32-bit wide (lower half of the corresponding x register)
    stp    x29, x30, [sp, #48]                               ; Store frame pointer (x29) and link register (x30) on stack
    add    x29, sp, #48                                      ; Set up new frame pointer
;    .cfi_def_cfa w29, 16                                     ; Define Call Frame Address
;    .cfi_offset w30, -8                                      ; Specify offset for saved registers
;    .cfi_offset w29, -16
    // mov    w8, #0                                            ; Set w8 to 0 (return value for main)
    // stur    w8, [x29, #-20]                                  ; Store w8 at frame pointer -20 (for later retrieval)
    // stur    wzr, [x29, #-4]                                  ; Store zero register at frame pointer -4 (unused variable)
    mov    w8, #3                                            ; Set w8 to 3 (first number for multiplication)
    // stur    w8, [x29, #-8]                                   ; Store first number (3) at frame pointer -8
    mov    w9, #8                                            ; Set w8 to 5 (second number for multiplication)
    // stur    w9, [x29, #-12]                                  ; Store second number (5) at frame pointer -12
    // ldur    w8, [x29, #-8]                                   ; Load first number into w8
    // ldur    w9, [x29, #-12]                                  ; Load second number into w9
    mul    w7, w8, w9                                        ; Multiply w8 and w9, store result in w7
    // stur    w7, [x29, #-16]                                  ; Store result at frame pointer -16
    // ldur    w8, [x29, #-8]                                   ; Load first number into w8 again
    // mov    x11, x8                                           ; Move to x11 (for printf argument)
    // ldur    w8, [x29, #-12]                                  ; Load second number into w8 again
    // mov    x10, x9                                           ; Move to x10 (for printf argument)
    // ldur    w8, [x29, #-16]                                  ; Load result into w8 again
    // mov    x9, sp                                            ; Set x9 to current stack pointer
    str    w8, [sp]                                         ; Store first argument for printf (first number)
    str    w9, [sp, #8]                                     ; Store second argument for printf (second number)
    // str    x8, [x9, #16]                                     ; Store third argument for printf (result)
    str    w7, [sp, #16]                                    ; Store third argument for printf (result)
    adrp   x0, l_.str@PAGE                                   ; Get page address of string format
    add    x0, x0, l_.str@PAGEOFF                            ; Calculate exact address of string format
    bl    _printf                                            ; Call printf function
    // ldur    w0, [x29, #-20]                                  ; Load return value (0) into w0
    mov w0, #0                                               ; Load return value (0) into w0
    ldp    x29, x30, [sp, #48]                               ; Restore frame pointer and link register
    add    sp, sp, #64                                       ; Deallocate stack space
    ret                                                      ; Return from main function
;    .cfi_endproc                                             ; End of procedure

    .section    __TEXT,__cstring,cstring_literals            ; Define section for string literals
l_.str:                                                      ; String format label
    .asciz    "Multiplying %d * %d = %d\n"                ; Null-terminated format string

.subsections_via_symbols                                     ; Directive for linker
