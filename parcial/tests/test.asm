section .data
exit_code dq 0 ; Codigo de finalización, 0 para indicar fin correcto
sys_call dq 60 ; Código de syscall para finalizar el programa

section .text
global main

main:
mov rax, [sys_call] ; Se mueve a RAX el código de syscall para Exit()
mov rdi, [exit_code] ; Se mueve a RDI el código de finalización (0)
syscall ; Se realiza la llamada al sistema operativo