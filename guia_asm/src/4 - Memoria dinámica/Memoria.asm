extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
;  *a = RDI, *b = RSI

strCmp:
;Asumo q las mayusculas valen menos que las minusculas como en ascii
	
	push RBP ;pila alineada
  	mov RBP, RSP

	xor R8,R8 ;indice

	.ciclo:
	mov AL, [RDI + R8] ; En este caso cada char es 1 byte x lo tanto alcanza con esto
	mov CL, [RSI + R8]

	;Vemos que ninguno sea cero
	CMP AL, 0
	JZ .MenorA ;Aca tambien revisamos la posibilidad de ser iguales
	CMP CL, 0
	JZ .MenorB

	CMP AL, CL ;Las comparamos
	JB .MenorA ; a<b
	JA .MenorB ; b<a
	;Otro caso son el mismo char
	INC R8
	jmp .ciclo
	

	.MenorA:
	CMP CL, 0 ;Esto es para ver si son iguales
	JZ .Iguales
	;Si no lo son..
	mov EAX, 1
	jmp .fin

	.MenorB:
	mov EAX, -1
	jmp .fin
	
	.Iguales:
	mov EAX, 0
	.fin:

	pop RBP


	; int32_t strCmp(char* a, char* b)
; *a -> rdi, *b -> rsi
;strCmp:
;    push rbp
;    mov rbp, rsp
;    push rbx ;preservo el registro no volátil
;
;    xor rdx, rdx ; rdx = i, i = 0
;    xor eax, eax ; en un principio asumimos que son iguales, sino modifico
;
;.while:
;    mov cl, BYTE [rdi + rdx]
;    cmp cl, 0
;    je .chequearB ; si a es 0, chequeo si b tmb lo es
;    mov bl, BYTE [rsi + rdx]
;    cmp bl, 0
;    je .AesMayor ;si llegue aca es q a no era vacio => AesMayor
;    cmp cl, bl
;    js .BesMayor
;    cmp bl, cl
;    js .AesMayor
;    inc rdx
;    jmp .while
;
;.chequearB:
;    mov bl, BYTE [rsi + rdx]
;    cmp bl, 0
;    je .epilogo ;si b tmb es 0, son iguales
;    jmp .BesMayor
;
;.AesMayor:
;    mov eax, -1
;    jmp .epilogo
;
;.BesMayor:
;    mov eax, 1
;    jmp .epilogo
;
;.epilogo:
;    pop rbx
;    pop rbp



	ret

; char* strClone(char* a)
strClone:
	push RBP ;pila alineada
  	mov RBP, RSP
	push RDI
	sub RSP, 8 ;alineada

	call strLen
	;Size of char es 1 asi que alcanza con poner cuantos bytes (RAX +1)
	mov R12, RAX ; Copia a un no volatil para mantener el len

	;reservar para string
	mov RDI, RAX
	inc RDI
	call malloc 

	add RSP, 8
	pop RDI ; volvemos a tener el valor al string

	;copiar
	xor R9,R9; iterador nuevo para ir hasta r12
	.cicloCopiar:
	mov BL, [RDI + R9]
	mov [RAX + R9], BL
	cmp BL, 0
	jz .endCopy
	inc R9
	jmp .cicloCopiar

	.endCopy:

	pop RBP
	ret
	;Podria haber usado strLen, pero no lo habia hecho je

; void strDelete(char* a)
strDelete:
	push RBP ;pila alineada
  	mov RBP, RSP

	call free

	pop RBP
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:

	xor R8,R8; va a ser el acumulador para saber len
	.cicloContar:
	mov AL, [RDI + R8]
	cmp AL,0
	jz .endContar
	inc R8
	jmp .cicloContar

	.endContar:
	mov RAX, R8


	ret


