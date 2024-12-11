global main
extern puts

section .data
    mensaje db  "hola mundo!", 0

section .text
main:
    mov     rdi, mensaje
    call    puts
    ret
