extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 8
UINT32_SIZE EQU 4

; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global ejercicio1
ejercicio1:
	push RBP ;pila alineada
  	mov RBP, RSP

	add RDI, RSI
	add RDI, RDX
    add RDI, RCX
    add RDI, R8
	mov RAX, RDI

	pop RBP
	ret

global ejercicio2
ejercicio2:
	push RBP ;pila alineada
  	mov RBP, RSP
	push RDI
	sub RSP, 8

	;Copio valores
	mov DWORD[rdi+ITEM_OFFSET_ID], ESI
	mov DWORD[rdi+ITEM_OFFSET_CANTIDAD], EDX


	lea RDI, [RDI+ITEM_OFFSET_NOMBRE] ; el string a copiar
	mov RSI, RCX ; la posicion reservada para el string

	call strcpy 

	;Restauro el padding y el RDI
	add RSP, 8
	pop RDI

	mov RDI, RAX	

	pop RBP
	ret

;uint32_t ejercicio3(uint32_t* array, uint32_t size, uint32_t (*fun_ej_3)(uint32_t a, uint32_t b));
;array -> RDI
;size  -> ESI
;fun_ej_3 -> RDX

global ejercicio3
ejercicio3:
	push RBP ;pila alineada
  	mov RBP, RSP
	push r12
	push r13
	push r14
	push r15

	cmp rsi, 0
	je .vacio

	mov r14D, ESI ;size
	mov rcx, rdi ; array
	mov r12, 0 ; sumatoria
	mov r13d, 0 ; i

	.loop:
	mov rdi, r12 ; primer parametro el valor de la sumatoria
	mov rsi, [rcx + r13*4] ;segundo parametro iesimo elemento

	call rdx

	add r12, rax
	mov rax, r12

	inc r13
	cmp r13d, r14D
	je .end

	jmp .loop

	.vacio:
	mov rax, 64

	.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop RBP
	ret

;uint32_t* ejercicio4(uint32_t** array, uint32_t size, uint32_t constante);
;array -> rdi
;size -> esi
;constante -> edx
global ejercicio4
ejercicio4:
	push RBP ;pila alineada
  	mov RBP, RSP
	push r12
	push r13
	push r14
	push r15 ;alineada
	push RBX
	sub rsp, 8

	mov r12, rdi ;array
	mov r13d, esi ;size
	mov r14d, edx ;constante

	xor rdi, rdi
	mov eax, UINT32_SIZE ;4
	mul esi ;esi * 4 -> queda en RAX porque
	mov edi, eax

	call malloc
	mov r15, rax
	
	xor rbx, rbx
	
	.loop:
	
	cmp rbx, r13 ;aparentemente no hay problema aunque sean 32 bits
	je .end

	mov r8, [r12+rbx*POINTER_SIZE] ;ok porque es un array de punteros a punteros
	mov r9, [r8]
	mov rax, r14
	mul r9
	mov [r15+rbx*UINT32_SIZE], eax
	
	mov rdi, r8 
	call free ;libera la memoria a la que apunta el puntero de r8
	mov qword [r12 + rbx*8], 0   ; poner null en array[i] (el inicial), aparentemente lo necesita el test
	;osea liberas r8 y haces que el r8 que esta en el array sea 0/null

	inc rbx
	jmp .loop

	.end:
	mov rax, r15

	add rsp, 8
	pop RBX
	pop r15
	pop r14
	pop r13
	pop r12
	pop RBP
	ret
