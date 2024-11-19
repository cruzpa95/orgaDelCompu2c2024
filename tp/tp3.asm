section .data
dimension db 7                  ; Dimensión de la matriz cuadrada 7x7
matriz times 49 db ' '          ; Matriz 7x7 con espacios en blanco
fmt db "%c", 0                  ; Formato para printf en C
newline db 10, 0                ; Nueva línea para printf

extern printf                       ; Declarar printf como función externa

section .text
global main                     ; Punto de entrada para GCC

main:
; Llenar la cruz con 'X'
mov al, 'X'

; Llenar la fila superior de la cruz con 'X'
mov rbx, 0                     ; Índice inicial para la fila superior
llenar_fila_superior:
mov [matriz + rbx], al
add rbx, 1
cmp rbx, 21
jl llenar_fila_superior

; Llenar el borde derecho de la cruz con 'X'
mov rbx, 4                     ; Índice inicial del borde derecho
llenar_borde_derecho:
mov [matriz + rbx], al
add rbx, 7
cmp rbx, 46
jl llenar_borde_derecho

; Llenar el borde izquierdo de la cruz con 'X'
mov rbx, 2                     ; Índice inicial del borde izquierdo
llenar_borde_izquierdo:
mov [matriz + rbx], al
add rbx, 7
cmp rbx, 44
jl llenar_borde_izquierdo

; Llenar la fila inferior de la cruz con 'X'
mov rbx, 28                    ; Índice inicial para la fila inferior
llenar_fila_inferior:
mov [matriz + rbx], al
add rbx, 1
cmp rbx, 49
jl llenar_fila_inferior

; Llenar las esquinas rojas con 'X'
mov rbx, 28
mov [matriz + rbx], al
mov rbx, 34
mov [matriz + rbx], al
mov rbx, 30
mov [matriz + rbx], al
mov rbx, 32
mov [matriz + rbx], al

; Llenar la parte inferior gris con 'O'
mov al, 'O'
mov rbx, 38
mov [matriz + rbx], al
mov rbx, 45
mov [matriz + rbx], al

; Mostrar la matriz en pantalla en formato 7x7
mov rcx, 0                     ; Índice para recorrer la matriz
mostrar_matriz:
; Mostrar cada carácter en la matriz usando printf
mov rdi, fmt                   ; Formato "%c" para imprimir un carácter
mov rsi, matriz                ; Dirección base de la matriz
add rsi, rcx                   ; Ajustar al índice actual
mov rax, 0                     ; Llamada a printf no usa rax en x64
call printf                    ; Llamar a printf para mostrar un solo carácter

; Imprimir nueva línea al final de cada fila (cada 7 caracteres)
inc rcx                        ; Incrementar índice
mov rbx, rcx
mov rdx, 7
div rdx                        ; Dividir rcx entre 7
cmp rdx, 0                     ; ¿Es el residuo 0? (es el final de una fila)
jne continuar                  ; Si no es el final de una fila, continuar

; Nueva línea
mov rdi, newline               ; Dirección de la nueva línea
mov rax, 0                     ; Llamada a printf no usa rax en x64
call printf                    ; Llamar a printf para nueva línea

continuar:
cmp rcx, 49                    ; Verificar si hemos mostrado toda la matriz (49 elementos)
jl mostrar_matriz              ; Si no, repetir el bucle

; Salir de la función main
mov rax, 0                     ; Valor de retorno de main (0)
ret                            ; Retornar de main
