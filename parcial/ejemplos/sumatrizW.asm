;*****************************************************************************
; sumatriz.asm
; Dada una matriz de 5x5 cuyos elementos son números enteros de 2 bytes (word)
; se pide solicitar por teclado un nro de fila y columna y realizar
; la sumatoria de los elementos de la fila elegida a partir de la
; columan elegida y mostrar el resultado por pantalla.
; Se deberá validar mediante una rutina interna que los datos ingresados por
; teclado sean validos.
;
;*****************************************************************************

global	main
extern	printf
extern	gets
extern	sscanf
extern	puts

section	.data

    ;matriz  dw  1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5
    matriz  dw  1,1,1,1,1
			dw  2,2,2,2,2
			dw	3,3,3,3,3
			dw	4,4,4,4,4
			dw	5,5,5,5,5
    msjIngFilCol	db	"Ingrese fila (1 a 5) y columna (1 a 5) separados por un espacio: ",0
    formatInputFilCol	db	"%hi %hi",0
    msjErrorInput       db  "Los datos ingresados son inválidos.  Intente nuevamente."
	sumatoria		dd 0
	msjSumatoria	db	"La sumatoria es: %i",10,0    

section	.bss
	inputFilCol		resb	50
   	fila			resw	1
	columna			resw	1 	
    inputValido     resb    1   ;S valido N invalido
    desplaz			resw	1

section	.text
main:
	mov		rcx,msjIngFilCol
	sub		rsp,32
	call	printf
	add		rsp,32

    mov		rcx,inputFilCol	
	sub		rsp,32	
    call    gets    
	add		rsp,32	    

    sub     rsp,32
    call    validarFyC
    add     rsp,32

    cmp     byte[inputValido],'S'
    je      continuar

    mov     rcx,msjErrorInput
    sub     rsp,32
    call    puts
    add     rsp,32	

    jmp     main
continuar:
; sumatoria

    call	calcSumatoria


;mostar por pantalla
    mov		rcx,msjSumatoria
	sub		rdx,rdx
	mov		edx,[sumatoria]
	sub		rsp,32
	call	printf
	add		rsp,32  


ret ;FIN DE PROGRAMA
;*********************************
; RUTINAS INTERNAS
;*********************************
validarFyC:
    mov     byte[inputValido],'N'

    mov     rcx,inputFilCol
    mov     rdx,formatInputFilCol
    mov     r8,fila
    mov     r9,columna
	sub		rsp,32
	call	sscanf
	add		rsp,32    

    cmp     rax,2
    jl      invalido

    cmp     word[fila],1
    jl      invalido
    cmp     word[fila],5
    jg      invalido

    cmp     word[columna],1
    jl      invalido
    cmp     word[columna],5
    jg      invalido

    mov     byte[inputValido],'S'
invalido:
ret
;*********************************
calcDesplaz:
;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
;  longFila = longElemento * cantidad columnas
    mov     bx,[fila]
    sub     bx,1
    imul    bx,bx,10    ;en bx tengo el desplazamiento a la fila

    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    imul    bx,bx,2

    add     [desplaz],bx    ;en desplaz tengo el desplazamiento total
ret

;*********************************
calcSumatoria:

    call	calcDesplaz

;jmp FIN_NO_OLVIDAR_REMOVER
    mov     rcx,6
    sub     cx,[columna]
    mov     ebx,[desplaz]
sumarSiguiente:
    sub     eax,eax ;limpio el registro eax
    mov     ax,[matriz + ebx]   ; cargo el elemento de la matriz q es de 2 bytes
    add     [sumatoria],eax     ;actualizo la sumatoria con un campo de 4 bytes
    add     ebx,2
    loop    sumarSiguiente
FIN_NO_OLVIDAR_REMOVER:    
ret






