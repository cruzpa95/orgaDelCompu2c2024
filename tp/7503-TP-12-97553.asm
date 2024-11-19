;***************************************************************************
;Manejo de Conjuntos (II)
;
;Desarrollar un programa en assembler Intel 80x86 que permita definir n conjuntos (con n <= 6) cuyos
;elementos tienen una longitud de 1 a 2 caracteres alfanuméricos (A..Z , 0..9).
;
;El programa deberá responder las siguientes consultas:
;1. Pertenencia de un elemento a un conjunto.
;2. Igualdad de dos conjuntos.
;3. Inclusión de un conjunto en otro
;4. Unión entre conjuntos.
;***************************************************************************

global 	main
extern 	printf
extern	scanf
extern	gets

section  .bss
	cantConj		resb	1
	opcion			resb	1

	conjunto0		resb	50
	conjunto1		resb	50	
	conjunto2		resb	50
	conjunto3		resb	50
	conjunto4		resb	50
	conjunto5		resb	50
	conjunto6		resb	50
	elemento		resb	2	
	conjuntoAux0	resb	50

	conjuntoA		resb	1
	conjuntoB		resb	1
	conjuntoAux		resb	50
	conjuntoAux1	resb	50
	conjuntoAux2	resb	50
	conjuntoAuxA	resb	50
	conjuntoAuxB	resb	50
	conjuntoAuxC	resb	200
	conjuntoAuxD	resb	200

section .data
	msgIngConj1  db  "Ingrese el conjunto 1: ",10,13,0
	msgIngConj2  db  "Ingrese el conjunto 2: ",10,13,0
	msgIngConj3  db  "Ingrese el conjunto 3: ",10,13,0
	msgIngConj4  db  "Ingrese el conjunto 4: ",10,13,0
	msgIngConj5  db  "Ingrese el conjunto 5: ",10,13,0
	msgIngConj6  db  "Ingrese el conjunto 6: ",10,13,0

	msgMenu0	 db	"Menu principal.", 10,13,0
	msgMenu1 	 db	"1. Pertenencia de un elemento a un conjunto",10,13,0
	msgMenu2 	 db	"2. Igualdad de dos conjuntos",10,13,0
	msgMenu3	 db	"3. Inclusion de un conjunto en otro (A estaria incluido en B)",10,13,0
	msgMenu4	 db	"4. Union entre conjuntos",10,13,0
	msgMenu5	 db	"5. Salir",10,13,0
	
	msgDescripcionConjuntos0 db "Descripcion de conjutos:",10,13,0
	msgDescripcionConjuntos1 db "Cada conjunto soporta hasta maximo 20 elementos y como minimo 1 elemento. ",10,13,0
	msgDescripcionConjuntos2 db "Elementos de longitud 1 a 2 caracteres alfanumericos (A..Z - 0..9). Separar elementos con una coma. ",10,13,0

	msgIngreseOpcion 	 db	"Ingrese su opcion: ",0
	msgIngresoElem db "Ingrese elemento de longitud de 1 a 2 caracteres alfanumericos (A..Z , 0..9): ",0
	msgIngresoA 	 db	"Ingrese numero del 1er conjunto: ",0
	msgIngresoB 	 db	"Ingrese numero del 2do conjunto: ",0
	msgIngreseCantidad 	db "Ingrese cantidad de conjuntos [1-6]: ",0

	msgInvalidoOpcion  db "Opcion invalida. Reintente.",10,13,0
	msgInvalidoCantidad  db "Cantidad invalida. Reintente.",10,13,0
	msgInvalidoConjunto  db "Conjunto invalido. Reintente.",10,13,0
	msgInvalidoAlgunElem  db "Algun elemento invalido. Reintente.",10,13,0
	msgInvalidoElem db "Elemento invalido. Reintente.",10,13,0
	msgLongitudInvalida db "Longitud invalida. Hasta 20 elementos. Reintente.",10,13,0
	

	msgNoPertenece 	db "No pertenece.",10,13,0
	msgPertenece 	db "Pertenece.",10,13,0

	msgNoEstaIncluido db "No esta incluido.",10,13,0
	msgEstaIncluido db "Esta incluido.",10,13,0

	msgNoSonIguales db "No son iguales.",10,13,0
	msgSonIguales db "Son iguales.",10,13,0

	msgEnter db " ",10,13,0	

	guion	db "-",0
	coma	db ",",0
	
	
section .text
_main:

	call ingreseNumConj
	call llenarConjuntos

menu:
	call mostrarMenu

ingreseOpcion:	
	push	msgIngreseOpcion		
	call	printf
	add 	esp,4		

	mov		byte[opcion],0
	push	opcion			
	call	gets			
	add		esp,4
	
validarOpcion:
	cmp byte[opcion],'5'
	jg opcionInvalida
	cmp byte[opcion],'1'
	jl opcionInvalida	
	
	cmp byte[opcion+1],0
	je	irAOpciones

opcionInvalida:
	push	msgInvalidoCantidad		
	call	printf
	add 	esp,4		
	jmp 	ingreseOpcion

irAOpciones:

	cmp  byte[opcion],'1'
	je	 opcion1

	cmp  byte[opcion],'2'
	je	 opcion2
	
	cmp  byte[opcion],'3'
	je	 opcion3
	
	cmp  byte[opcion],'4'
	je	 opcion4

	cmp  byte[opcion],'5'
	je	 finalPrograma
	
finalPrograma:
	ret
	
ingreseNumConj:
	push	msgIngreseCantidad		
	call	printf
	add 	esp,4		
	
	push	cantConj			
	call	gets			
	add		esp,4

	call	validarCantConj
	;si llega aca es xq la cantidad de conjuntos es valida
	ret	

validarCantConj:
	cmp byte[cantConj],'6'
	jg cantConjInvalida
	cmp byte[cantConj],'1'
	jl cantConjInvalida	

	cmp byte[cantConj+1],0
	jne cantConjInvalida
	ret
	
cantConjInvalida:
	push	msgInvalidoOpcion		
	call	printf
	add 	esp,4		
	jmp 	ingreseNumConj
	
	
llenarConjuntos:
	call llenarConj1
	cmp byte[cantConj],'1'
	je volver

	call llenarConj2
	cmp byte[cantConj],'2'
	je volver

	call llenarConj3
	cmp byte[cantConj],'3'
	je volver

	call llenarConj4
	cmp byte[cantConj],'4'
	je volver

	call llenarConj5
	cmp byte[cantConj],'5'
	je volver
	
	call llenarConj6
	cmp byte[cantConj],'6'
	je volver

volver: 
	ret
	
llenarConj1:
	push	msgEnter
	call	printf
	add 	esp,4
	
	push	msgDescripcionConjuntos0
	call	printf
	add 	esp,4


	push	msgDescripcionConjuntos1
	call	printf
	add 	esp,4

	push	msgDescripcionConjuntos2
	call	printf
	add 	esp,4

	push	msgEnter
	call	printf
	add 	esp,4
	
	push	msgIngConj1		
	call	printf
	add 	esp,4		

ingreseConjunto1:
	mov		byte[conjuntoAux],0
	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado1:
	mov esi,0	;iterar el conjunto ingresado
	
valElem1:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar1:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado1

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento1
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido1

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido1
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido1
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido1
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido1

	jmp caracterInvalido1
	
caracterValido1:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar1

finElemento1:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem1
	cmp edi,2
	je valElem1
	
	jmp caracterInvalido1

caracterInvalido1:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto1	

finConjuntoIngresado1:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido1
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.

copiarConjunto1:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia1

	cmp		al,','
	je		validarLong1

	inc		ecx

copiarChar1:
	mov		[conjunto1+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto1	

validarLong1:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion1

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto1

agregarGuion1:
	mov al,	[guion]
	mov	[conjunto1+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto1

finCopia1:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin1

agregarGuionFinal1:
	mov al,	[guion]
	
	mov	[conjunto1+edi],al
	inc	edi
fin1:
	mov		byte[conjunto1+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima1:	
	cmp		byte[conjunto1+esi],0
	je		finLong1
	inc		esi
	jmp		chequearLongMaxima1
finLong1:
	cmp esi,40
	jbe	finn1
longitudInvalida1:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto1	
finn1:	
	ret
;llenar conj2
llenarConj2:
	push	msgIngConj2		
	call	printf
	add 	esp,4		

ingreseConjunto2:
	mov		byte[conjuntoAux],0

	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado2:
	mov esi,0	;iterar el conjunto ingresado
	
valElem2:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar2:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado2

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento2
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido2

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido2
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido2
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido2
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido2

	jmp caracterInvalido2
	
caracterValido2:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar2
finElemento2:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem2
	cmp edi,2
	je valElem2
	
	jmp caracterInvalido2
caracterInvalido2:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto2	

finConjuntoIngresado2:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido2
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.
copiarConjunto2:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia2

	cmp		al,','
	je		validarLong2

	inc		ecx

copiarChar2:
	mov		[conjunto2+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto2	

validarLong2:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion2

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto2

agregarGuion2:
	mov al,	[guion]
	mov	[conjunto2+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto2

finCopia2:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin2

agregarGuionFinal2:
	mov al,	[guion]
	mov	[conjunto2+edi],al
	inc	edi
fin2:
	mov		byte[conjunto2+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima2:	
	cmp		byte[conjunto2+esi],0
	je		finLong2
	inc		esi
	jmp		chequearLongMaxima2
finLong2:
	cmp esi,40
	jbe	finn2
longitudInvalida2:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto2	
finn2:	
	ret





;llenar conj3
llenarConj3:
	push	msgIngConj3	
	call	printf
	add 	esp,4		

ingreseConjunto3:
	mov		byte[conjuntoAux],0

	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado3:
	mov esi,0	;iterar el conjunto ingresado
	
valElem3:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar3:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado3

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento3
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido3

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido3
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido3
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido3
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido3

	jmp caracterInvalido3
	
caracterValido3:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar3
finElemento3:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem3
	cmp edi,2
	je valElem3
	
	jmp caracterInvalido3
caracterInvalido3:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto3	

finConjuntoIngresado3:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido3
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.
copiarConjunto3:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia3

	cmp		al,','
	je		validarLong3

	inc		ecx

copiarChar3:
	mov		[conjunto3+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto3	

validarLong3:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion3

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto3

agregarGuion3:
	mov al,	[guion]
	mov	[conjunto3+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto3

finCopia3:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin3

agregarGuionFinal3:
	mov al,	[guion]
	mov	[conjunto3+edi],al
	inc	edi
fin3:
	mov		byte[conjunto3+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima3:	
	cmp		byte[conjunto3+esi],0
	je		finLong3
	inc		esi
	jmp		chequearLongMaxima3
finLong3:
	cmp esi,40
	jbe	finn3
longitudInvalida3:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto3	
finn3:	
	ret



;llenar conj4
llenarConj4:
	push	msgIngConj4	
	call	printf
	add 	esp,4		

ingreseConjunto4:
	mov		byte[conjuntoAux],0

	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado4:
	mov esi,0	;iterar el conjunto ingresado
	
valElem4:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar4:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado4

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento4
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido4

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido4
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido4
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido4
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido4

	jmp caracterInvalido4
	
caracterValido4:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar4
finElemento4:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem4
	cmp edi,2
	je valElem4
	
	jmp caracterInvalido4
caracterInvalido4:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto4	

finConjuntoIngresado4:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido4
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.
copiarConjunto4:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia4

	cmp		al,','
	je		validarLong4

	inc		ecx

copiarChar4:
	mov		[conjunto4+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto4	

validarLong4:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion4

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto4

agregarGuion4:
	mov al,	[guion]
	mov	[conjunto4+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto4

finCopia4:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin4

agregarGuionFinal4:
	mov al,	[guion]
	mov	[conjunto4+edi],al
	inc	edi
fin4:
	mov		byte[conjunto4+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima4:	
	cmp		byte[conjunto4+esi],0
	je		finLong4
	inc		esi
	jmp		chequearLongMaxima4
finLong4:
	cmp esi,40
	jbe	finn4
longitudInvalida4:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto4	
finn4:	
	ret



;llenar conj5
llenarConj5:
	push	msgIngConj5
	call	printf
	add 	esp,4		

ingreseConjunto5:
	mov		byte[conjuntoAux],0

	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado5:
	mov esi,0	;iterar el conjunto ingresado
	
valElem5:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar5:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado5

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento5
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido5

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido5
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido5
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido5
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido5

	jmp caracterInvalido5
	
caracterValido5:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar5
finElemento5:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem5
	cmp edi,2
	je valElem5
	
	jmp caracterInvalido5
caracterInvalido5:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto5	

finConjuntoIngresado5:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido5
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.
copiarConjunto5:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia5

	cmp		al,','
	je		validarLong5

	inc		ecx

copiarChar5:
	mov		[conjunto5+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto5

validarLong5:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion5

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto5

agregarGuion5:
	mov al,	[guion]
	mov	[conjunto5+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto5

finCopia5:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin5

agregarGuionFinal5:
	mov al,	[guion]
	mov	[conjunto5+edi],al
	inc	edi
fin5:
	mov		byte[conjunto5+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima5:	
	cmp		byte[conjunto5+esi],0
	je		finLong5
	inc		esi
	jmp		chequearLongMaxima5
finLong5:
	cmp esi,40
	jbe	finn5
longitudInvalida5:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto5	
finn5:	
	ret


;llenar conj6
llenarConj6:
	push	msgIngConj6
	call	printf
	add 	esp,4		

ingreseConjunto6:
	mov		byte[conjuntoAux],0

	push	conjuntoAux			
	call	gets			
	add		esp,4

validarConjuntoIngresado6:
	mov esi,0	;iterar el conjunto ingresado
	
valElem6:
	mov edi,0	;iterar sobre el elemento que estoy validando

valcar6:
	cmp byte[conjuntoAux+esi],0	;es fin de cadena?
	je finConjuntoIngresado6

	cmp byte[conjuntoAux+esi],','	;es fin de conjuntoAux?
	je finElemento6
	
	cmp edi,2			;hasta longitud 2
	je caracterInvalido6

	cmp byte[conjuntoAux+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido6
	
	cmp byte[conjuntoAux+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido6
	
	cmp byte[conjuntoAux+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido6
	
	cmp byte[conjuntoAux+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido6

	jmp caracterInvalido6
	
caracterValido6:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del conjunto ingresado
	inc edi		;incremento la longitud del elemento a validar
	jmp valcar6
finElemento6:
	inc esi			;avanzo caracter para salir de la coma
	cmp edi,1 		;valido q la longitud sea 1 o 2.
	je valElem6
	cmp edi,2
	je valElem6
	
	jmp caracterInvalido6
caracterInvalido6:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgInvalidoAlgunElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto6	

finConjuntoIngresado6:	
	cmp edi,0	;chequeo q no sea un conjunto vacio.
	je 	caracterInvalido6
	;sino inicio la copia del conjuntoAux a un conjunto de longitud fija 2 elementos, para elementos de longitud 1, agrega un guion a la izquierda.
	mov edi,0	;para avanzar sobre el conjunto destino 
	mov esi,0	;para avanzar sobre el conjunto ingresado por el usuario
	mov ecx,0	;para chequear longitud del elemento a copiar.
copiarConjunto6:	
	mov		al,	[conjuntoAux+esi]
	
	cmp		al,0
	je		finCopia6

	cmp		al,','
	je		validarLong6

	inc		ecx

copiarChar6:
	mov		[conjunto6+edi],al
	inc		edi
	inc		esi
	jmp		copiarConjunto6

validarLong6:	;aca hay una coma. 
	inc esi		;avanzo la coma para la prox iteracion

	cmp ecx,1	;verifico la longitud (si es 1, agrego GUION)
	je	agregarGuion6

	mov ecx,0	;si no agrego el guion, reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto6

agregarGuion6:
	mov al,	[guion]
	mov	[conjunto6+edi],al
	
	inc	edi		;avanzo sobre el conjunto destino
	mov ecx,0	;reinicio longitud de elemento ya que pase una coma
	jmp copiarConjunto6

finCopia6:
	cmp ecx,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	fin6

agregarGuionFinal6:
	mov al,	[guion]
	mov	[conjunto6+edi],al
	inc	edi
fin6:
	mov		byte[conjunto6+edi],0	;agrego un 0 binario para marcar el fin del conjunto.

	;	Calculo la longitud	en esi
	mov		esi,0
chequearLongMaxima6:	
	cmp		byte[conjunto6+esi],0
	je		finLong6
	inc		esi
	jmp		chequearLongMaxima6
finLong6:
	cmp esi,40
	jbe	finn6
longitudInvalida6:	;si hay algun caracter invalido pido nuevo conjunto.
	push	msgLongitudInvalida		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjunto6	
finn6:	
	ret

;fin llenado de conjuntos

mostrarMenu:
	;limpio los conjuntos para reutilizar las funciones
	mov		byte[conjuntoAuxA],0
	mov		byte[conjuntoAuxB],0
	mov		byte[conjuntoAuxC],0
	mov		byte[conjuntoAuxD],0
	
	push 	msgEnter
	call	printf
	add 	esp,4

	push 	msgEnter
	call	printf
	add 	esp,4

	push	msgMenu0		
	call	printf
	add 	esp,4			
	push	msgMenu1		
	call	printf
	add 	esp,4		
	push	msgMenu2		
	call	printf
	add 	esp,4		
	push	msgMenu3		
	call	printf
	add 	esp,4		
	push	msgMenu4		
	call	printf
	add 	esp,4		
	push	msgMenu5		
	call	printf
	add 	esp,4		
	ret
	
opcion1:
;1. Pertenencia de un elemento a un conjunto.
	call ingreseConjuntoA
	call ingreseElemento

	call llenarUnConjunto
	;hacer pertenencia
comparo:
	mov esi,0

compararPrimerChar:
	cmp byte[conjuntoAuxA+esi],0
	je noPertenece	
	
	mov al, [conjuntoAuxA+esi]	
	cmp byte[elemento],al
	je compararSegundoChar
	jmp siguienteElemEnConj
	
compararSegundoChar:
	inc esi
	mov al, [conjuntoAuxA+esi]
	cmp byte[elemento+1],al
	je pertenece
	dec esi
	
siguienteElemEnConj:	
	inc esi
	inc esi
	jmp compararPrimerChar

noPertenece:
	push	msgNoPertenece		
	call	printf
	add 	esp,4	
		
	jmp menu

pertenece:	
	push	msgPertenece		
	call	printf
	add 	esp,4		

	jmp menu

opcion2:
;2. Igualdad de dos conjuntos.

	call ingreseConjuntoA
	call ingreseConjuntoB

	call llenarUnConjunto
	call llenarOtroConjunto

	call compararAenB

	jmp menu

compararAenB:
	mov esi,0
	mov edi,0
compararPrimerCharOpcion2:
	cmp byte[conjuntoAuxA+esi],0
	je estaIncluidoOpcion2	

	cmp byte[conjuntoAuxB+edi],0
	je noEstaIncluidoOpcion2	
	
	mov al, [conjuntoAuxA+esi]	
	cmp byte[conjuntoAuxB+edi],al
	je compararSegundoCharOpcion2
	jmp siguienteElemEnConjOpcion2
	
compararSegundoCharOpcion2:
	inc esi
	inc edi
	mov al, [conjuntoAuxA+esi]
	cmp byte[conjuntoAuxB+edi],al
	je perteneceElemOpcion2
	dec esi
	dec edi
	
siguienteElemEnConjOpcion2:	
	inc edi 
	inc edi
	jmp compararPrimerCharOpcion2

noEstaIncluidoOpcion2:
	push	msgNoSonIguales	
	call	printf
	add 	esp,4		

	ret

perteneceElemOpcion2:
;aca deberia avanzar en un conjunto
	mov edi,0
	inc esi ;ahora estoy en el prox elemento de auxA
	jmp compararPrimerCharOpcion2
	
estaIncluidoOpcion2:
	jmp compararBenA

compararBenA:
	mov esi,0
	mov edi,0
compararPrimerCharOpcion22:
	cmp byte[conjuntoAuxB+esi],0
	je estaIncluidoOpcion22	

	cmp byte[conjuntoAuxA+edi],0
	je noEstaIncluidoOpcion22	
	
	mov al, [conjuntoAuxB+esi]	
	cmp byte[conjuntoAuxA+edi],al
	je compararSegundoCharOpcion22
	jmp siguienteElemEnConjOpcion22
	
compararSegundoCharOpcion22:
	inc esi
	inc edi
	mov al, [conjuntoAuxB+esi]
	cmp byte[conjuntoAuxA+edi],al
	je perteneceElemOpcion22
	dec esi
	dec edi
	
siguienteElemEnConjOpcion22:	
	inc edi 
	inc edi
	jmp compararPrimerCharOpcion22

noEstaIncluidoOpcion22:
	push	msgNoSonIguales	
	call	printf
	add 	esp,4		

	ret

perteneceElemOpcion22:
;aca deberia avanzar en un conjunto
	mov edi,0
	inc esi ;ahora estoy en el prox elemento de auxA
	jmp compararPrimerCharOpcion22
	
estaIncluidoOpcion22:
	push	msgSonIguales		
	call	printf
	add 	esp,4		

	ret

opcion3:
;3. Inclusión de un conjunto en otro
;	unConjunto   = obtener conjuntoA
;	otroConjunto = obtener conjuntoB
;
;	recorrer unConjunto y comparar contra todo "otroConjunto" 
;		-si entra a "pertenece" -> avanzo en "unConjunto"
;		-si entra una sola vez a "noPertenece" -> NO INCLUIDO
;		-si termina de recorrer "unConjunto" y no entro nunca a noPertenece -> INCLUIDO
;
	call ingreseConjuntoA
	call ingreseConjuntoB

	call llenarUnConjunto
	call llenarOtroConjunto

	call buscoAenB

	jmp menu

llenarUnConjunto:
	cmp byte[conjuntoA],'1'
	je llenarConjuntoAuxAConConj1

	cmp byte[conjuntoA],'2'
	je llenarConjuntoAuxAConConj2

	cmp byte[conjuntoA],'3'
	je llenarConjuntoAuxAConConj3

	cmp byte[conjuntoA],'4'
	je llenarConjuntoAuxAConConj4
	
	cmp byte[conjuntoA],'5'
	je llenarConjuntoAuxAConConj5

	cmp byte[conjuntoA],'6'
	je llenarConjuntoAuxAConConj6

;esto para copiar a conjuntoAuxA el conjunto que corresponda
llenarConjuntoAuxAConConj1:	
	mov	esi,0
copiarCharConj1aAuxA:
	mov al,[conjunto1+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto1+esi],0
	je finCopiaConj1aAuxA		
	inc esi
	jmp copiarCharConj1aAuxA	
finCopiaConj1aAuxA:	
	ret

llenarConjuntoAuxAConConj2:	
	mov	esi,0
copiarCharConj2aAuxA:
	mov al,[conjunto2+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto2+esi],0
	je finCopiaConj2aAuxA		
	inc esi
	jmp copiarCharConj2aAuxA	
finCopiaConj2aAuxA:	
	ret

llenarConjuntoAuxAConConj3:	
	mov	esi,0
copiarCharConj3aAuxA:
	mov al,[conjunto3+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto3+esi],0
	je finCopiaConj3aAuxA		
	inc esi
	jmp copiarCharConj3aAuxA	
finCopiaConj3aAuxA:	
	ret

llenarConjuntoAuxAConConj4:	
	mov	esi,0
copiarCharConj4aAuxA:
	mov al,[conjunto4+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto4+esi],0
	je finCopiaConj4aAuxA		
	inc esi
	jmp copiarCharConj4aAuxA	
finCopiaConj4aAuxA:	
	ret

llenarConjuntoAuxAConConj5:	
	mov	esi,0
copiarCharConj5aAuxA:
	mov al,[conjunto5+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto5+esi],0
	je finCopiaConj5aAuxA		
	inc esi
	jmp copiarCharConj5aAuxA	
finCopiaConj5aAuxA:	
	ret

llenarConjuntoAuxAConConj6:	
	mov	esi,0
copiarCharConj6aAuxA:
	mov al,[conjunto6+esi]		
	mov [conjuntoAuxA+esi],al		
	cmp byte[conjunto6+esi],0
	je finCopiaConj6aAuxA		
	inc esi
	jmp copiarCharConj6aAuxA	
finCopiaConj6aAuxA:	
	ret

llenarOtroConjunto:
	cmp byte[conjuntoB],'1'
	je llenarConjuntoAuxBConConj1

	cmp byte[conjuntoB],'2'
	je llenarConjuntoAuxBConConj2
	
	cmp byte[conjuntoB],'3'
	je llenarConjuntoAuxBConConj3

	cmp byte[conjuntoB],'4'
	je llenarConjuntoAuxBConConj4

	cmp byte[conjuntoB],'5'
	je llenarConjuntoAuxBConConj5

	cmp byte[conjuntoB],'6'
	je llenarConjuntoAuxBConConj6

;esto para copiar a conjuntoAuxB el conjunto que corresponda
llenarConjuntoAuxBConConj1:	
	mov	esi,0
copiarCharConj1aAuxB:
	mov al,[conjunto1+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto1+esi],0
	je finCopiaConj1aAuxB		
	inc esi
	jmp copiarCharConj1aAuxB	
finCopiaConj1aAuxB:	
	ret

llenarConjuntoAuxBConConj2:	
	mov	esi,0
copiarCharConj2aAuxB:
	mov al,[conjunto2+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto2+esi],0
	je finCopiaConj2aAuxB		
	inc esi
	jmp copiarCharConj2aAuxB	
finCopiaConj2aAuxB:	
	ret

llenarConjuntoAuxBConConj3:	
	mov	esi,0
copiarCharConj3aAuxB:
	mov al,[conjunto3+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto3+esi],0
	je finCopiaConj3aAuxB		
	inc esi
	jmp copiarCharConj3aAuxB	
finCopiaConj3aAuxB:	
	ret

llenarConjuntoAuxBConConj4:	
	mov	esi,0
copiarCharConj4aAuxB:
	mov al,[conjunto4+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto4+esi],0
	je finCopiaConj4aAuxB		
	inc esi
	jmp copiarCharConj4aAuxB	
finCopiaConj4aAuxB:	
	ret

llenarConjuntoAuxBConConj5:	
	mov	esi,0
copiarCharConj5aAuxB:
	mov al,[conjunto5+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto5+esi],0
	je finCopiaConj5aAuxB		
	inc esi
	jmp copiarCharConj5aAuxB	
finCopiaConj5aAuxB:	
	ret

llenarConjuntoAuxBConConj6:	
	mov	esi,0
copiarCharConj6aAuxB:
	mov al,[conjunto6+esi]		
	mov [conjuntoAuxB+esi],al		
	cmp byte[conjunto6+esi],0
	je finCopiaConj6aAuxB		
	inc esi
	jmp copiarCharConj6aAuxB	
finCopiaConj6aAuxB:	
	ret

buscoAenB:
	mov esi,0
	mov edi,0
compararPrimerCharOpcion3:
	cmp byte[conjuntoAuxA+esi],0
	je estaIncluido	

	cmp byte[conjuntoAuxB+edi],0
	je noEstaIncluido	
	
	mov al, [conjuntoAuxA+esi]	
	cmp byte[conjuntoAuxB+edi],al
	je compararSegundoCharOpcion3
	jmp siguienteElemEnConjOpcion3
	
compararSegundoCharOpcion3:
	inc esi
	inc edi
	mov al, [conjuntoAuxA+esi]
	cmp byte[conjuntoAuxB+edi],al
	je perteneceElem
	dec esi
	dec edi
	
siguienteElemEnConjOpcion3:	
	inc edi 
	inc edi
	jmp compararPrimerCharOpcion3

noEstaIncluido:
	push	msgNoEstaIncluido	
	call	printf
	add 	esp,4		

	ret

perteneceElem:
;aca deberia avanzar en un conjunto
	mov edi,0
	inc esi ;ahora estoy en el prox elemento de auxA
	jmp compararPrimerCharOpcion3
	
estaIncluido:
	push	msgEstaIncluido		
	call	printf
	add 	esp,4		

	ret

opcion4:
;4. Unión entre conjuntos.
	push	msgEnter		
	call	printf
	add 	esp,4	

	push	conjuntoAuxA		
	call	printf
	add 	esp,4		
	push	msgEnter		
	call	printf
	add 	esp,4		

	push	conjuntoAuxB		
	call	printf
	add 	esp,4		
	push	msgEnter		
	call	printf
	add 	esp,4	

	push	conjuntoAuxC		
	call	printf
	add 	esp,4		
	push	msgEnter		
	call	printf
	add 	esp,4	

	push	conjuntoAuxD		
	call	printf
	add 	esp,4		
	push	msgEnter		
	call	printf
	add 	esp,4	

	call ingreseConjuntoA
	call ingreseConjuntoB

	call llenarUnConjunto
	call llenarOtroConjunto

	call unirConjuntosYMostrar

	jmp menu

unirConjuntosYMostrar:
	mov esi,0
	mov edi,0

compararPrimerCharOpcion4:
	cmp byte[conjuntoAuxB+edi],0
	je terminarOpcion5

	cmp byte[conjuntoAuxA+esi],0
	je agregarElementoDeBaA
	
	mov al, [conjuntoAuxB+edi]	
	cmp byte[conjuntoAuxA+esi],al
	je compararSegundoCharOpcion4
	jmp siguienteElemEnConjOpcion4
	
	
compararSegundoCharOpcion4:
	inc edi
	inc esi
	mov al, [conjuntoAuxB+edi]
	cmp byte[conjuntoAuxA+esi],al
	je noAgregarElementoDeBaA 
	dec edi
	dec esi
	
siguienteElemEnConjOpcion4:	
	inc esi
	inc esi
	jmp compararPrimerCharOpcion4

agregarElementoDeBaA:
	mov al, [conjuntoAuxB+edi]
	mov	[conjuntoAuxA+esi],al

	inc esi
	inc edi
	mov al, [conjuntoAuxB+edi]
	mov	[conjuntoAuxA+esi],al

	inc esi
	mov	byte[conjuntoAuxA+esi],0

	inc edi
	mov esi,0

	jmp compararPrimerCharOpcion4

noAgregarElementoDeBaA:	
	;no agregar
	inc edi
	mov esi,0

	jmp compararPrimerCharOpcion4

terminarOpcion5:

;agregar comas
	mov		edi,0
verFinAgregarComas:	
	;esto no es necesario ya q no acepto conjuntos vacios.
	;cmp 	byte[conjuntoAuxA+esi],0
	;je 		sacarGuiones

	mov		al,	[conjuntoAuxA+esi]
	mov		[conjuntoAuxC+edi],al
	inc		esi
	inc		edi

	mov		al,	[conjuntoAuxA+esi]
	mov		[conjuntoAuxC+edi],al
	inc		esi
	inc		edi

	cmp 	byte[conjuntoAuxA+esi+1],0
	je 		sacarGuiones
	mov 	al,	[coma]
	mov		[conjuntoAuxC+edi],al
	inc 	edi

	jmp		verFinAgregarComas	

sacarGuiones:
	mov	byte[conjuntoAuxC+edi],0
	
	mov esi,0
	mov edi,0
verFinSacarGuiones:
	cmp 	byte[conjuntoAuxC+esi],0
	je 		mostrarUnion

	cmp 	byte[conjuntoAuxC+esi],'-'
	je 		irAlProximoElemDeC

	mov		al,	[conjuntoAuxC+esi]
	mov		[conjuntoAuxD+edi],al
	inc		esi
	inc		edi
	jmp 	verFinSacarGuiones

irAlProximoElemDeC:	
	inc 	esi
	jmp		verFinSacarGuiones	


mostrarUnion:
	mov	byte[conjuntoAuxD+edi],0
	push	conjuntoAuxD		
	call	printf
	add 	esp,4		

	ret
opcion5:
;Finalizar ejecucion.
	ret
	
ingreseConjuntoA:
	push	msgIngresoA		
	call	printf
	add 	esp,4		

	push	conjuntoA			
	call	gets			
	add		esp,4
	
	call	validarConjuntoA
	ret
	
validarConjuntoA:
	mov al, [cantConj]
	cmp byte[conjuntoA],al
	jg conjuntoInvalidoA
	cmp byte[conjuntoA],'1'
	jl conjuntoInvalidoA

	cmp byte[conjuntoA+1],0
	jne conjuntoInvalidoA
	
finValidConjuntoA:	
	ret
	
conjuntoInvalidoA:
	push	msgInvalidoConjunto		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjuntoA	
	
ingreseConjuntoB:
	push	msgIngresoB		
	call	printf
	add 	esp,4		

	push	conjuntoB			
	call	gets		
	add		esp,4
	
	call	validarConjuntoB
	ret
	
validarConjuntoB:
	mov al, [cantConj]
	cmp byte[conjuntoB],al
	jg conjuntoInvalidoB
	cmp byte[conjuntoB],'1'
	jl conjuntoInvalidoB
	
finValidConjuntoB:	
	ret
	
conjuntoInvalidoB:
	push	msgInvalidoConjunto		
	call	printf
	add 	esp,4		
	jmp 	ingreseConjuntoB	
	
ingreseElemento:
	push	msgIngresoElem		
	call	printf
	add 	esp,4

	mov		byte[elemento],0
	push	elemento			
	call	gets			 
	add		esp,4

valElem:
	mov esi,0	;iterar el elemento ingresado

valcar:
	cmp byte[elemento+esi],0	;es fin de cadena?
	je finElementoIngresado

	cmp esi,2			;hasta longitud 2
	je caracterInvalido

	cmp byte[elemento+esi],'0'	;es menor a cero? -> caracterInvalido
	jb caracterInvalido
	
	cmp byte[elemento+esi],'9'	;es menor o igual a nueve?  -> caracterValido
	jbe caracterValido
	
	cmp byte[elemento+esi],'A'	;es menor a A?  -> caracterInvalido
	jb caracterInvalido
	
	cmp byte[elemento+esi],'Z'	;es menor o igual a Z?  -> caracterValido
	jbe caracterValido

	jmp caracterInvalido
	
caracterValido:	;si es valido, sigo validando el proximo
	inc esi		;incremento para avanzar al prox caracter del elemento ingresado
	jmp valcar

caracterInvalido:	;si hay algun caracter invalido pido nuevo elemento.
	push	msgInvalidoElem		
	call	printf
	add 	esp,4		
	jmp 	ingreseElemento	

finElementoIngresado:	
	cmp esi,0	;chequeo q no sea un elemento vacio.
	je 	caracterInvalido
	cmp esi,1	;si el elemento no es de longitud 1, avanza a finalizar, por ende no agrega guion al final
	jne	finElem

agregarGuionFinal:
	mov al,	[guion]
	mov	[elemento+esi],al
	inc	esi

finElem:
	mov		byte[elemento+esi],0
	ret

