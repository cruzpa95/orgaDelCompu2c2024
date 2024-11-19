global	main
extern 	printf
extern  gets
extern	sscanf

section .data
    matriz db '  1234567', 0
           db '1   XXX  ', 0
           db '2   XXX  ', 0
           db '3 XXXXXXX', 0
           db '4 XXXXXXX', 0
           db '5 XX   XX', 0
           db '6     O  ', 0
           db '7   O    ', 0
    saltoLinea  db 10, 0       ; Salto de línea al final de cada fila
;    CANT_FIL    equ	3
;    CANT_COL    equ	3
    posicion    dq       0
    msjIngFila		db	'Ingrese un fila: ',0
;    msjIngCol		db	'Ingrese un columna: ',0
    msjImpNum		db	'Usted ingreso %i !!',10,0
    numFormat		db	'%li',0	;%i 32 bits / %li 64 bits


section .bss    
    buffer		resb	10
    numero		resq	1

section .text
main:
    sub rsp, 8                ; Reserva espacio en la pila
    call mostrar_tablero
;    call mostrar_turno_jugador
    call pedir_casillero_inicial
 ;   call pedir_casillero_destino
  ;  call actualizar_tablero
   ; call mostrar_tablero

    fin:
    add rsp, 8             ; Restaura el espacio de la pila
    ret

mostrar_tablero:
    mov rcx, 10
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
        add rax, 10                 ; Suma 10 a rax
        mov [posicion], rax         ; Guarda el nuevo valor en "posicion"
        
        loop fila_loop
        ret
pedir_casillero_inicial:

	mov	rdi,msjIngFila
	call	printf

	mov	rdi,buffer
	call	gets

	mov	rdi,buffer		;Parametro 1: campo donde están los datos a leer
	mov	rsi,numFormat	;Parametro 2: dir del string q contiene los formatos
	mov	rdx,numero		;Parametro 3: dir del campo que recibirá el dato formateado
	call	sscanf

	cmp	rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl	pedir_casillero_inicial
; Ud ingreso <numero>
	mov		rdi,msjImpNum
	mov		rsi,[numero]
	call	printf
        ret




