global	main
extern 	printf
extern  gets
extern	sscanf

section .data
    matriz db ' 1234567', 0
           db '1  XXX  ', 0
           db '2  XXX  ', 0
           db '3XXXXXXX', 0
           db '4XXXXXXX', 0
           db '5XX   XX', 0
           db '6    O  ', 0
           db '7  O    ', 0
    saltoLinea  db 10, 0       ; Salto de línea al final de cada fila
;    CANT_FIL    equ	3
;    CANT_COL    equ	3
    posicion    db       0
;    msjIngFila		db	'Ingrese un fila: ',0
;    msjIngCol		db	'Ingrese un columna: ',0
;    msjImpNum		db	'Usted ingreso %i !!',10,0
    msjIndice		db	'indice: %li !!',10,0

;    numFormat		db	'%li',0	;%i 32 bits / %li 64 bits
    longitudFila dq	9
    longitudElemento dq	1
    cantidadColumnas dq  8
    posx dq 3
    posy dq 1


section .bss    
    buffer		resb	10
    numero		resb	1

section .text
main:
    mov rbp, rsp; for correct debugging
    sub rsp, 8                ; Reserva espacio en la pila
    call mostrar_tablero
    call actualizar_matriz
    call mostrar_tablero

    fin:
    add rsp, 8             ; Restaura el espacio de la pila
    ret

mostrar_tablero:
    mov rax, 0
    mov [posicion], rax 
    mov rcx, [cantidadColumnas]
    fila_loop:
        push rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        ; Carga la dirección de la fila actual en la matriz

        ; Imprime la fila actual

        mov rdi, matriz         ; Pasa la dirección de la fila a printf
        add rdi, [posicion]
        sub rax, rax           ; Limpia rax para printf
        call printf

        ; Imprime salto de línea después de cada fila
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf
        call printf
        pop rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        
        ; Sumar 10 a "posicion"
        mov rax, [posicion]         ; Carga el valor de "posicion" en rax
        add rax, [longitudFila]                 ; Suma 10 a rax
        mov [posicion], rax         ; Guarda el nuevo valor en "posicion"
        
        loop fila_loop
        
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf
        call printf
        
        ret

actualizar_matriz: ;8x8
    ;Posicionamiento en el elemento i,j de una matriz
    ;(i-1)*longitudFila + (j-1)*longitudElemento
    ;longitdFila= longitudElemento*cantidadColumnas

    mov rax,[posx] ;guardo el valor de la fila
;    sub rax,1
    imul word[longitudFila] ;me desplazo en la fila
    add rcx,rax

    
    mov rax,[posy] ;guardo el valor de la fila
;    sub rax,1
    imul word[longitudElemento] ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz
    
    mov word[rbx],"Y" ;muevo el valor
    ret

