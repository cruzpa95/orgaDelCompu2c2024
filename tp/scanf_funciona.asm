global main
extern gets
extern printf
extern sscanf

section .data
    msj		db	'Usted ingreso %s !!',10,0
    msj2		db	'Usted ingreso %li !!',10,0
    format	db	'%li',0
    input       db          "14",0
    
section .bss
    numero resq 1

section .text
main:
    sub rsp, 8            ; Align stack for calling conventions
    
    
    mov rdi, msj
    mov rsi, input
    call printf
       
    ;scanf
    mov rdi, input
    mov rsi, format
    mov rdx, numero    
    call sscanf

    mov rdi, msj2
    mov rsi, [numero]
    call printf
    
    add rsp, 8            ; Restore stack alignment
    ret

