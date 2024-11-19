global	main
extern	printf

section .data
    matriz db '  XXX  ', 0
           db '  XXX  ', 0
           db 'XXXXXXX', 0
           db 'XXXXXXX', 0
           db 'XX   XX', 0
           db '    O  ', 0
           db '  O    ', 0
    saltoLinea db 10, 0       ; Salto de línea al final de cada fila

section .bss
    i resb 1                  ; Contador para las filas

section .text
main:
    sub rsp, 8                ; Reserva espacio en la pila

    ; Inicializa i (fila) en 0
    mov byte [i], 0

    fila_loop:
        ; Comprueba si i < 7
        cmp byte [i], 7
        je fin                 ; Si i >= 7, termina el bucle

        ; Carga la dirección de la fila actual en la matriz
        mov rsi, matriz        ; Carga la dirección base de la matriz en rsi
        movzx rax, byte [i]    ; Carga el valor de i en rax y extiende a 64 bits
        imul rax, 8            ; Cada fila tiene 8 bytes, incl. el terminador nulo
        add rsi, rax           ; Calcula la dirección de la fila actual

        ; Imprime la fila actual
        mov rdi, rsi           ; Pasa la dirección de la fila a printf
        xor rax, rax           ; Limpia rax para printf
        call printf

        ; Imprime salto de línea después de cada fila
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf
        call printf

        ; Incrementa i (fila)
        inc byte [i]
        jmp fila_loop          ; Repite el bucle de filas

    fin:
        add rsp, 8             ; Restaura el espacio de la pila
        ret
