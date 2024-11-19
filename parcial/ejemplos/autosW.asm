; Dado un archivo en formato BINARIO que contiene informacion sobre autos llamado listado.dat
; donde cada REGISTRO del archivo representa informacion de un auto con los campos: 
;   marca:							10 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;	precio							4 bytes en bpf s/s
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat las patentes y el precio (en bpfc/s) de aquellos autos
; cuyo año de fabricación esté entre 2020 y 2022 (inclusive) y cuyo precio sea inferior a 5.000.000$
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna.
; Se deberá validar:
;   Marca (que sea Fiat, Ford, Chevrolet o Peugeot)
;   Año (que sea un valor numérico y que cumpla la condicion indicada del rango) 
;   Precio que cumpla la condicion pedida.
global	main
extern  puts
extern  printf
extern  fopen
extern  fclose
extern  fread 
extern  sscanf
extern  fwrite

section	.data
	fileList		db	"listado.dat",0
	modeList		db	"rb",0		;read | binario | abrir o error
	handleList		dq	0

	fileSel			db	"seleccion.dat",0
	modeSel			db	"wb",0	
	handleSel		dq	0

	regList			times	0 	db ''	;Longitud total del registro: 25
	  brand			times	10	db ' '
	  year			times	4	db ' '
	  patente		times	7	db ' '
	  price			times	4	db ' '

	arrayBrands		db	"Fiat      Ford      Chevrolet Peugeot   "	
	yearAux			db "****",0
	yearFormat	    db "%hi",0	;16 bits (word)
	yearNum			dw	0		;16 bits (word)  

	regSel			times	0	db	'' ;11 bytes en total
	 patenteSel		times	7	db ' ' ;7 bytes
	 priceSel					dd 0   ;4 bytes


	;*** Para debug
	msgOpenFileOk db "Apertura Listado ok",0
	msgReading	db	"leyendo...",0
	msgRegisterIsValid	db "Reg valido",0

section .bss
	registerIsValid	resb 	1
	fieldIsValid	resb	1
section  .text
main:

	call	openList

	cmp		rax,0
	jle		errorOpenList
	mov		[handleList],rax
			mov 	rcx,msgOpenFileOk
			call	printMsg

	
	call	openSel
	
	cmp		rax,0
	jle		errorOpenSel
	mov		[handleSel],rax
	;------------------------

readNextRegister:

	call	readRegister

	cmp		rax,0
	jle		closeFiles
			mov 	rcx,msgReading
			call	printMsg	

	
	call	validateRegister
	
	cmp		byte[registerIsValid],'N'
	je		readNextRegister
			mov 	rcx,msgRegisterIsValid
			call	printMsg	

	
	call	buildRegSel
	
	
	call	writeRegSel


	jmp		readNextRegister

errorOpenList:
;lo que considere si fallo la apertura
	jmp		endProg
errorOpenSel:

	call	closeList

	jmp		endProg	
closeFiles:

	call	closeList


	call	closeSel

endProg:
ret
;------------------------------------------------------
;------------------------------------------------------
;   RUTINAS INTERNAS
;------------------------------------------------------
openList:	;Abro archivo listado
    mov		rcx,fileList
    mov     rdx,modeList
	sub		rsp,32
	call	fopen
	add		rsp,32
ret
openSel:	;Abro archivo seleccion
	mov		rcx,fileSel
	mov		rdx,modeSel
	sub		rsp,32
	call	fopen
	add		rsp,32
ret
closeList:	;Cierro archivo listado
    mov     rcx,[handleList]
	sub		rsp,32
    call    fclose
	add		rsp,32
ret
closeSel:	;Cierro archivo seleccion
	mov		rcx,[handleSel]
	sub		rsp,32
	call	fclose
	add		rsp,32
ret
;-------------------------------------
readRegister:
    mov     rcx,regList
    mov     rdx,25           
    mov     r8,1
	mov		r9,[handleList] 
	sub		rsp,32  
	call    fread
	add		rsp,32
ret
;------------------------------------------------------
;VALIDAR REG
validateRegister:
	mov     byte[registerIsValid],'N'

	
	call	validateBrand
	
	cmp		byte[fieldIsValid],'N'
	je		endValidateRegister

	
	call	validateYear
	
	cmp		byte[fieldIsValid],'N'
	je		endValidateRegister	

	
	call	validatePrice
	
	cmp		byte[fieldIsValid],'N'
	je		endValidateRegister	

	mov     byte[registerIsValid],'S'
endValidateRegister:
ret
;------------------------------------------------------
;VALIDAR MARCA
validateBrand:
	mov     byte[fieldIsValid],'S'

	mov		rbx,0
	mov		rcx,4
nextBrand:
	push	rcx
	mov		rcx,10
	lea		rsi,[brand] ; mov   rsi,brand
	lea		rdi,[arrayBrands + rbx]
	repe cmpsb
	pop		rcx

	je		brandOk
	add		rbx,10
	loop	nextBrand

	mov     byte[fieldIsValid],'N'
brandOk:	
ret
;------------------------------------------------------
;VALIDAR AÑO
validateYear:
;Copia a un campo finalizado con 0 binario (para poder ser usado por sscanf)
	mov     byte[fieldIsValid],'N'
	mov		rcx,4
	mov		rsi,year
	mov		rdi,yearAux
	rep	movsb
;Conversion para validacion fisica
	mov		rcx,yearAux    
	mov		rdx,yearFormat   
	mov		r8,yearNum  
	sub		rsp,32
	call	sscanf
	add		rsp,32
	cmp		rax,1
	jl		yearError

; Verifico si el año esta comprendido en el rango 2020 - 2022
	cmp		word[yearNum],2020
	jl		yearError
	cmp		word[yearNum],2022
	jg		yearError 	

	mov     byte[fieldIsValid],'S'
yearError:
ret
;------------------------------------------------------
;VALIDAR PRECIO
validatePrice:
	mov     byte[fieldIsValid],'S'
	cmp		dword[price],5000000
	jle		precioOk
	mov     byte[fieldIsValid],'N'
precioOk:
ret
;------------------------------------------------------

buildRegSel:
	;Copiar los datos requeridos al archivo de seleccion
	;Copio Patente
	mov		rcx,7
	mov		rsi,patente
	mov		rdi,patenteSel
	rep	movsb	
	;Copio precio
	mov		eax,[price]
	mov		[priceSel],eax	
ret

;------------------------------------------------------
writeRegSel:
	;Guardo registro en archivo Seleccion
	mov		rcx,regSel			;Parametro 1: dir area de memoria con los datos a copiar
	mov		rdx,11						;Parametro 2: longitud del registro
	mov		r8,1						;Parametro 3: cantidad de registros
	mov		r9,[handleSel]		;Parametro 4: handle del archivo
	sub		rsp,32
	call	fwrite
	add		rsp,32
ret

;------------------------
printMsg:
	sub		rsp,32
	call	puts  
	add		rsp,32
ret