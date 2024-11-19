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
    numero resq 1          ; Reservar espacio para un número

section .text
main:
    sub rsp, 8            ; Alinear el stack para las convenciones de llamada

    ; Imprimir el mensaje inicial
    mov rdi, msj
    mov rsi, input
    call printf
    
    ; Llamar a sscanf para convertir el input en octal
    mov rdi, input        ; Primer parámetro: cadena de entrada
    mov rsi, format       ; Segundo parámetro: formato
    lea rdx, [numero]     ; Tercer parámetro: dirección de 'numero'
    call sscanf

    ; Imprimir el resultado en formato octal
    mov rdi, msj2
    mov rsi, [numero]     ; Cargar el valor de 'numero' para printf
    call printf
    
    add rsp, 8            ; Restaurar alineación del stack
    ret
