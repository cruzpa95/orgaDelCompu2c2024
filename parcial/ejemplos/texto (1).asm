;*******************************************************************************
; texto.asm
; Ingresar por teclado un texto y luego un caracter e imprimir por pantalla:
;   - El texto de forma invertida
;   - La cantidad de apariciones del caracter en el texto
;   - El porcentaje de esas apariciones respecto de la longitud total del texto
; 
;*******************************************************************************
%macro mPuts 0
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro
%macro mGets 0
    sub     rsp,8
    call    gets  
    add     rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

global  main
extern  puts
extern  gets
extern  printf

section     .data
    msgInText		db	"Ingrese un texto por teclado (max 99 caracteres)",0
    msgInChar       db  "ingrese un caracter: ",0
    textLength      dq  0
    counterChar     dq  0
    msgReversedText db  "Texto invertido: %s",10,0
    msgNumberOfChar db  "El caracter %c aparece %li veces.",10,0
    msgPercentage   db  "El porcentaje de aparicion es %li %%",10,0

section     .bss
    text            resb 500
    char            resb 50
    reversedText    resb 500

section     .text
main:
    mov     rdi,msgInText
    mPuts
;   Ingreso texto    
    mov     rdi,text
    mGets
    
    mov     rdi,msgInChar
    mPuts    
;   Ingreso caracter    
    mov     rdi,char
    mGets

    mov     rsi,0
nextCharFindLast:
    cmp     byte[text + rsi],0 ;Fin de string?
    je      endString
    inc     rsi
    jmp     nextCharFindLast
endString:
    
    mov     rdi,0           ;para q apunte al primer caracter de reversedText
    mov     [textLength],rsi
charCopy:
    cmp     rsi,0       ;ver si termino el recorrido de atras para adelante
    je      endCopy
    mov     al,[text + rsi -1]  ;copia el char corriente al registro pivote "al"
    mov     [reversedText + rdi],al ; copia del char corriente en la siguiente posicion de reversedText
    
    cmp     al,[char] ;veo si el caracter corriente es igual al ingresado por teclado
    jne     movePointers
    add     qword[counterChar],1 ; Sumo un al contador del caracter - idem inc
movePointers:
    inc     rdi
    dec     rsi
    jmp     charCopy 
endCopy:
    mov     byte[reversedText + rdi],0

;   Imprimo texto invertido
    mov     rdi,msgReversedText
    mov     rsi,reversedText
    mPrintf

;   Imprimo cantidad de apariciones del caracter
    mov     rdi,msgNumberOfChar
    mov     rsi,[char]
    mov     rdx,[counterChar]
    mPrintf  

    ;Calculo Porcentaje
    imul    rax,[counterChar],100
    sub     rdx,rdx
    idiv    qword[textLength] ;(rdx:rax) <-- (rax) * (textLength)

    ;Imprimo Porcentaje
    mov     rdi,msgPercentage
    mov     rsi,rax
    mPrintf  

    ret


