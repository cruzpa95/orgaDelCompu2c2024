global main
extern gets
extern printf
extern sscanf

section .data
    format	db	'%li', 0

section .bss
    cadena resb 100
    numero  resq 1

section .text
main:
        
        mov rbp, rsp           ; Configuración para una depuración adecuada

    ; Llamar a gets para leer la cadena
    lea rdi, [cadena]      ; Dirección de 'cadena'
    sub rsp, 8             ; Alinear el stack a 16 bytes
    call gets
    add rsp, 8             ; Restaurar el stack

    ; Llamar a sscanf para convertir la cadena en un número
    lea rdi, [cadena]      ; Primer argumento: dirección de 'cadena'
    lea rsi, [format]      ; Segundo argumento: dirección del formato
    lea rdx, [numero]      ; Tercer argumento: dirección de 'numero'
    sub rsp, 8             ; Alinear el stack a 16 bytes
    call sscanf
    add rsp, 8             ; Restaurar el stack


    lea rdi, [numero]
    lea rdx, [numero]
    ; Finalizar el programa
    ret


### esto tambien funciona
global main
extern gets
extern printf
extern sscanf

section .data
    format	db	'%li', 0

section .bss
    cadena resb 100
    numero  resq 1

section .text
main:
        
    mov rbp, rsp           ; Configuración para una depuración adecuada

    ; Llamar a gets para leer la cadena
    mov rdi, cadena      ; Dirección de 'cadena'
    sub rsp, 8             ; Alinear el stack a 16 bytes
    call gets
    add rsp, 8             ; Restaurar el stack

    ; Llamar a sscanf para convertir la cadena en un número
    mov rdi, cadena      ; Primer argumento: dirección de 'cadena'
    mov rsi, format      ; Segundo argumento: dirección del formato
    mov rdx, numero      ; Tercer argumento: dirección de 'numero'
    sub rsp, 8             ; Alinear el stack a 16 bytes
    call sscanf
    add rsp, 8             ; Restaurar el stack


    mov rdi, numero
    mov rdx, numero
    ; Finalizar el programa
    ret
