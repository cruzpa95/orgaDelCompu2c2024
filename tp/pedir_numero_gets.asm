global main
extern gets
extern printf

section .data
    msj		db	'Usted ingreso %s !!',10,0
section .bss
    input resb 100       ; Reserve 100 bytes for input

section .text
main:
    mov rbp, rsp; for correct debugging
    sub rsp, 8            ; Align stack for calling conventions
    mov rdi, input
    call gets    
    
    mov rdi, msj
    mov rsi, input
    call printf
    
    add rsp, 8            ; Restore stack alignment
    ret
