global main
extern fopen
extern fread
extern fclose
extern puts
extern printf 

section .data ; Elementos Inicializados
; Mensajes para mostrar en pantalla
    mensajeErrorArchivo     	db "El archivo no se abrio correctamente", 0
    mensajeSumatoriaMaxima  	db "La maxima sumatoria de las diagonales principales de las submatrices es %i", 0
    fileName    				db "/home/pablo/orga/parcial/ejemploParcial/submat.dat", 0
; Modo para abrir el archivo binario
    modo    					db "rb", 0
; Matriz de 20x20 inicializada
    matriz      				times 20 	db 1,2,3,4,5,6,7,8,9,10,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10
; Inicializo la mayor sumatoria al menor valor posible (-128x20)
    mayorSumatoria      		dd 		-2560    

section .bss ; Elementos sin inicializar
    regFila     				resw 1
    regColumna    				resw 1
    regDimension     			resw 1
    idArchivo   				resq 1
    registro                    resb 6
    fila    					resw 1
    columna     				resw 1
    desplazamiento  			resq 1
    registroValido  			resb 1
    datoValido  				resb 1
    subMatrizValida     		resb 1
    cantidadDeElementosSumados  resw 1
    sumatoriaDiagonal   		resd 1    
    
section .text
main:
    mov rbp, rsp; for correct debugging
;    mov rbp, rsp; for correct debugging
;    mov rbp, rsp; for correct debugging
; Abro el archivo
    mov     rdi, fileName
    mov     rsi, modo
    sub     rsp, 8
    call    fopen
    add     rsp, 8
    cmp     rax, 0
    jle     errorOpenFile
    mov     qword[idArchivo], rax    

; Leo un registro
leerRegistro:
; rdi, rsi, rdx, rcx r8 r9
    mov     rdi, registro
    mov     rsi, 6
    mov     rdx, 1
    mov     rcx, [idArchivo]
	sub     rsp, 8
    call    fread
    add     rsp, 8
    cmp     rax, 0	; Verifico que el FileHandler sea un numero positivo (apertura OK)
    jle     finArchivo

; Validacion del registro leido
    sub     rsp, 8
    call    VALSM
    add     rsp, 8

; Si el registro no es valido, leo el siguiente registro
	cmp     byte[registroValido], 'N'
    je      leerRegistro

; Si el registro es valido, calculo la sumatoria de la diagonal
; en [SumatoriaDiagonal] queda el resultado de la sumatoria
    sub     rsp, 8
    call    calcularSumatoria
    add     rsp, 8

; Verifico si la sumatoria calculada es mayor que la actual 
	sub     rsp, 8
    call    determinarMayorSumatoria
    add     rsp, 8
	
; leo el siguiente registro	
    jmp     leerRegistro

; Cierro el archivo
finArchivo:
    mov     rcx, [idArchivo]
    sub     rsp, 8
    call    fclose
    add     rsp, 8
 
; Muestro en pantalla la sumatoria mayor de las submatrices 
    sub     rsp, 8
    call    mostrarMayorSumatoria
    add     rsp, 8

finDePrograma:
    ret


; RUTINAS INTERNAS
; Mensaje si falla la apertura de archivo
errorOpenFile:
    mov     rdx, mensajeErrorArchivo
    sub     rsp, 8
    call    puts
    add     rsp, 8
    jmp     finDePrograma

; Valido el registro leido
VALSM:  
    mov     byte[registroValido], 'N'
	mov 	r8w,[registro] ; leo la fila a R8w (16 bits)
	mov		r9w,[registro+2]; leo la columna a R9w (16 bits)
	mov		r10w, [registro+4]; leo la dimension a R10w (16 bits)

; paso los valores empaquetados a binarios puros
; cargo en regFila, regColumna y regDimension los valores leidos
	mov		[regFila], r8w; ; paso la fila a regFila
	mov		[regColumna], r9w; paso la columna a regColumna
	mov		[regDimension], r10w; paso la dimension a regDimension

; conversion de fila
; ejemplo el nro 14 esta guardado como "0x04 0x01" en regFila
	mov     r8,0x00
    mov     r9,0x00
    mov     r8b,[regFila] ;en R8b guardo las unidades
    mov     r9b,[registro+1] ;en r9b guardo las decenas
    imul    r9,0x0A ; multiplico por 10 las decenas
    add     r8b,r9b   ; sumo las unidades
    mov     [regFila],r8b ; guardo regFila como binario puro
; conversion de columna
    mov     r8,0x00
    mov     r9,0x00
    mov     r8b,[registro+2] ;en R8b guardo las unidades
    mov     r9b,[registro+3] ;en r9b guardo las decenas
    imul    r9,0x0A ; multiplico por 10 las decenas
    add     r8b,r9b   ; sumo las unidades
    mov     [regColumna],r8b ; guardo regColumna como binario puro
; conversion de dimension
    mov     r8,0x00
    mov     r9,0x00
    mov     r8b,[registro+4] ;en R8b guardo las unidades
    mov     r9b,[registro+5] ;en r9b guardo las decenas
    imul    r9,0x0A ; multiplico por 10 las decenas
    add     r8b,r9b   ; sumo las unidades
    mov     [regDimension],r8b ; guardo regDimension como binario puro

; Validacion del rango de los datos leidos
    sub     rsp, 8
    call    validarFila
	add		rsp, 8
    cmp     byte[datoValido], 'N'
    je      registroInvalido
    sub     rsp, 8
    call    validarColumna
	add		rsp, 8
    cmp     byte[datoValido], 'N'
    je      registroInvalido
    sub     rsp, 8
    call    validarDimension
	add		rsp, 8
    cmp     byte[datoValido], 'N'
    je      registroInvalido
; Validacion que la submatriz este contenida en la matriz
    sub     rsp, 8
    call    validarSubMatriz
	add		rsp, 8
    cmp     byte[subMatrizValida], 'N'
    je      registroInvalido
    mov     byte[registroValido], 'S'
registroInvalido:
    ret

; Validacion de la fila en el rango 1-20
validarFila:
    mov     byte[datoValido], 'N' 
    cmp     word[regFila], 1
    jl      filaInvalida
    cmp     word[regFila], 20
    jg      filaInvalida
    mov     byte[datoValido], 'S'
filaInvalida:
    ret
; Validacion de la columna en el rango 1-20
validarColumna:
    mov     byte[datoValido], 'N'
    cmp     word[regColumna], 1
    jl      columnaInvalida
    cmp     word[regColumna], 20
    jg      columnaInvalida
    mov     byte[datoValido], 'S'
columnaInvalida:
    ret
; Validacion de la dimension en el rango 1-20
validarDimension:
    mov     byte[datoValido], 'N'
    cmp     word[regDimension], 1
    jl      dimensionInvalida
    cmp     word[regDimension], 20
    jg      dimensionInvalida
    mov     byte[datoValido], 'S'
dimensionInvalida:
    ret

; Validacion que la submatriz este contenida en la matriz    
validarSubMatriz:
; tengo las coordenadas de la esquina superior derecha de la matriz, 
; si la fila de la coordenada mas la dimension de la submatriz menos 1 esta en el rango 1-20 y 
; si la columna de la coordenada menos la dimension de la submatriz menos 1 esta en el rango 1-20
; entonces la submatriz esta dentro de la matriz y es valida
    mov     byte[subMatrizValida], 'N'
    mov     ax, [regFila]
    mov     bx, [regColumna]
    mov     cx, [regDimension]
    dec     cx  ; dimension - 1
    add     ax, cx ; realizo filasSubmatriz = fila + (dimension - 1)
    cmp     ax, 20 ;
    jg      matrizInvalida
    sub     bx, cx ; realizo columna = columna - (dimension - 1)
    cmp     bx, 1
    jl      matrizInvalida
; SUBMATRIZ VALIDA, cargo en fila y columna el primer elemento de la diagonal principal
    mov     [columna], bx ; asigno bx a columna, ya que en bx esta la columna del primer elemento de la diagonal principal de la submatriz
    mov     ax, [regFila]
    mov     [fila], ax ; asigno regFil
    mov     byte[subMatrizValida], 'S'
matrizInvalida:
    ret

calcularDesplazamiento:
; La posicion del elemento a sumar es un desplazamiento respecto del primer elemento de la matriz (vista como un vector)
; y se calcula como Posicion (i,j) = (i-1)*CantidadDeFilas + (j-1)*LongitudElemento
    mov     rbx,0x00 
    mov     bx, word[fila] ; (i)
    dec     bx ; (i-1)
    imul    bx, bx, 20 ; (i-1)*CantidadDeFilas
    mov     [desplazamiento], rbx ; Guardo el parcial en desplazamiento
    mov     rbx,0x00
    mov     bx, word[columna] ; (j)
    dec     bx ; (j-1)
    add     [desplazamiento], rbx ; No hace falta hacer la multiplicacion de (j-1)*LongitudElemento porque LongitudElemento vale 1
    ret
calcularSumatoria:
    mov     word[cantidadDeElementosSumados], 0
    mov     dword[sumatoriaDiagonal], 0
    mov     cx, word[regDimension]
inicioSumatoria:
    cmp     word[cantidadDeElementosSumados], cx ; la cantidad de elementos de la diagonal es igual a la dimension
    je      finSumatoria 
    call    calcularDesplazamiento
    mov     r9,matriz
    mov     r10,[desplazamiento]
    add     r9,r10 ; obtengo en R9 la posicion absoluta del elemento como matriz+desplazamiento
    mov     al, byte[r9] ; cargo en aL el byte apuntado por R9 para sumarlo
    cbw     ; extendindo aL a 16 bits en ax para sumarlo con su signo en 16bits
    add     [sumatoriaDiagonal], ax
    inc     word[fila]
    inc     word[columna] ; le sumo uno a la fila y columna para pasar al siguiente miembro de la diagonal principal
    inc     word[cantidadDeElementosSumados]
    jmp     inicioSumatoria
finSumatoria:
    ret

; Se verifica si la sumatoria recien calculada es mayor a la ya registrada como mayor sumatoria
determinarMayorSumatoria:
    mov     eax, [sumatoriaDiagonal]
    cmp     eax, [mayorSumatoria]
    jl      sumatoriaDiagonalMenor
    mov     [mayorSumatoria], eax
sumatoriaDiagonalMenor:
    ret

; Se muestra por pantalla la mayor sumatoria
mostrarMayorSumatoria:
    mov     rcx, mensajeSumatoriaMaxima
    mov     rdx, [mayorSumatoria]
    sub     rsp, 8
    call    printf
    add     rsp, 8
    ret
