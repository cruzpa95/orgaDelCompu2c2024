global	main
extern	printf

section .data
    matriz db ' 01234567', 0
           db 'a   XXX  ', 0
           db 'b   XXX  ', 0
           db 'c XXXXXXX', 0
           db 'd XXXXXXX', 0
           db 'e XX   XX', 0
           db 'f     O  ', 0
           db 'g   O    ', 0
    saltoLinea db 10, 0       ; Salto de línea al final de cada fila

section .bss
    i resb 1                  ; Contador para las filas

section .text
main:
    sub rsp, 8                ; Reserva espacio en la pila

    ; Inicializa i (fila) en 0
    mov byte [i], 0

    fila_loop:
        cmp byte [i], 10
        je fin                 ; Si i >= 10, termina el bucle

        ; Carga la dirección de la fila actual en la matriz
        mov rsi, matriz        ; Carga la dirección base de la matriz en rsi
        movzx rax, byte [i]    ; Carga el valor de i en rax y extiende a 64 bits
        imul rax, 10            ; Cada fila tiene 8 bytes, incl. el terminador nulo
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
