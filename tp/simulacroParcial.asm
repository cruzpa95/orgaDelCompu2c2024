global main
extern puts
section .data
    fff db "<" ;60
    des db 22
    val2 db "Z9"
    val3 db 0
    mat times 660 dw 1

    
section .text
main:
    mov rbp, rsp; for correct debugging
    mov rax,0
    mov rcx,0
    mov rdi, 20 ;dato que yo agregue despues de sacar cuantas columnas hay, ya que tengo que ir a la ultima columna en la primera iteracion!

    lea rbx, [mat]
    mov cl, [fff] ;en "rcx"(guarda en cl (1byte) ya que fff es db (1byte). Guardo 60, la cantidad de veces a loopear
                    ;en otras palabras la cantidad de filas!
ssi:
    add ax,[rbx+rdi] ;dato de tamaño del elemento -> ax = 16bits = 2bytes -> suma la matriz en la posicion *ultima columna*
    add dil,[des]   ;dato de cuantos bits muevo sobre cuantas posiciones me muevo en la fila actual
                    ;(es decir cuantas columnas me muevo) hay que tener en cuenta el tamaño del elemento
                    ; si me muevo 22posiciones pero el tamaño del elemento es 2bytes, me movi 11 posiciones.
                    ;dil += 22 -> como ax es de 2bytes, esto avanza 11 columnas
                    ;dato del enunciado, suma la ULTIMA columna, es decir tiene 11 columnas la matriz -> puedo deducir rdi inicial.
    loop ssi ;60 veces -> 60filas

    ;resumen:
    ;los datos son: 60 filas (por el loop), 2bytes por elemento (por registro que guarda la suma de elementos)la suma tiene el mismo tama;o que el elemento. 
    ;des=22 la cantidad de columnas que avanza para ir a la "proxima ultima columna" dentro del loop
    ;como el tamaño del elemento es 2bytes, y avanza 22 posiciones para ir entre columnas -> hay 11 columnas.
    ;rdi tiene que ser inicialmente 20 para que en la primer instruccion al entrar al loop se inicie en la ultima columna
    
    mov ah, al ; suma de 60filas de 1 => 60 en decimal, 3c en hexa. al=3C -> ah=3C
    add ah, 1   ;suma 1 a 3C -> 3D
    mov [des], ax ; guarda 2bytes en las posiciones primeras posiciones de des [pero invertidas por little endian] des = AX -> des = 3C3D
    mov rdi, des  ; con gdb puedo ver la memoria de DES en 8bytes con: x/wx &des 
                    ;x/wx &des -> des en palabra de 2bytes
                    ;x/1bx &des -> des en 1byte
                    ;x/4bx &des -> des en 4bytes
                    ; rdi es de 8bytes!! por lo tanto guarda en rdi, des + lo que siga en memoria hasta 8bytes!!
                  
                    ; en memoria, luego de des, que vale 4bytes, 
                        ;en "des db 22" -> 22 decimal son "16" en hexa -> hay 2 bytes
                    ; sigue: val2: "Z9" ascii hay otros 4bytes (ya van 6bytes),
                        ;"Z" ascii = 5A en hexa, "9" en ascii = 39hexa
                    ;y "val3 db 0" en decimal, 00 en hexa  (en total 8bytes)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ; rdi 8bytes
                    ; des en 8bytes antes del mov (osea des inicial): 22 Z 9 0 -> 16 5A 39 0, donde 22=16, Z=5A,9=39, 0=00
                   
                   
                    ;entonces siendo que des va a quedar en rdi -> des toma desde su inicio hasta 8bytes

                    ;antes del MOV [DES], AX
                    ; DES = 16 5A 39 00 -> 
                    
                    ;luego del MOV [DES], AX -> guarda en des en su primera posicion pero al reves por little endian
                    ; DES = 3C 3D 39 00 -> guarda 
                    
                    ; en rdi se guardan 8bytes
                    ; luego del MOV RDI, DES
                    ; RDI = 3C 3D 39 00 -> imprime codigos hexa en codigos ascii
                    
                    ;puts imprime hasta un 0binario!
                  
                    ;3C: <, 3D: =, 39: 9 ;se imprime como se lee en memoria; <=9
    sub rsp,8    
    call puts   ;muestra <=9
    add rsp,8    
    

    ret