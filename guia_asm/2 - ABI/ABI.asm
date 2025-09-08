extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función
  call restar_c
  
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret

; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[RDI], x2[RSI], x3[RDX], x4[RCX], x5[R8], x6[R9], x7[rbp + 16], x8[rbp + 24]
alternate_sum_8:
	;prologo
  push RBP ; Alineada
  mov RBP, RSP

  push rdx            
  push rcx            
  push r8             
  push r9
  
  call restar_c 

  ;preparar el resultado y recuperar x3
  mov EDI, EAX
  mov ESI, [RBP - 8] ; X3
  call sumar_c

  ;preparar el resultado y recuperar x4
  mov EDI, EAX
  mov ESI, [RBP - 16] ; X4
  call restar_c 
 
 ;idem
  mov EDI, EAX
  mov ESI, [RBP - 24] ; X5
  call sumar_c
  
  ;idem
  mov EDI, EAX
  mov ESI, [RBP - 32] ; X6
  call restar_c 

  ;x7 estaba en la pila tambien, pero antes del rbp
  mov EDI, EAX
  mov ESI, [RBP + 16] ; X7
  call sumar_c
  
  ;idem
  mov EDI, EAX
  mov ESI, [RBP + 24] ; X8
  call restar_c 

	;epilogo
  mov RSP, RBP ;con esto borramos la pila entera que reservamos volviendo el sp al bp
  pop RBP
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;// Hace la multiplicación x1 * f1 y el resultado se almacena en destination. Los dígitos decimales del resultado se eliminan mediante truncado
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[RDI], x1[RSI], f1[XMM0]+
;Calculo q hay q usar cvtsi2ss, opera en los 32 bits bajos
product_2_f: 
  ;prologo
  push rbp
  mov rbp, rsp
;  sub rsp, 16
;  mov [rbp-8], edi
  
  cvtsi2ss xmm1, esi
  mulss xmm0, xmm1
  CVTTSS2SI eax, xmm0
  
  mov [rdi], eax 
  
  pop RBP
	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[RSI], f1[XMM0], x2[RDX], f2[XMM1], x3[RCX], f3[XMM2], x4[R8], f4[XMM3]
;	, x5[R9], f5[XMM4], x6[RBP + 16], f6[XMM5], x7[RBP + 24], f7[XMM6], x8[RBP + 32], f8[XMM7],
;	, x9[RBP + 40], f9[RBP + 48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
  CVTSS2SD XMM0, XMM0
  CVTSS2SD XMM1, XMM1
  CVTSS2SD XMM2, XMM2
  CVTSS2SD XMM3, XMM3
  CVTSS2SD XMM4, XMM4
  CVTSS2SD XMM5, XMM5
  CVTSS2SD XMM6, XMM6
  CVTSS2SD XMM7, XMM7
  CVTSS2SD XMM8, [RBP + 48]

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	MULSD XMM0, XMM1
	MULSD XMM0, XMM2
	MULSD XMM0, XMM3
	MULSD XMM0, XMM4
	MULSD XMM0, XMM5
	MULSD XMM0, XMM6
	MULSD XMM0, XMM7
	MULSD XMM0, XMM8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	CVTSI2SD XMM1, ESI
	CVTSI2SD XMM2, EDX
	CVTSI2SD XMM3, ECX
	CVTSI2SD XMM4, R8D
	CVTSI2SD XMM5, R9D
	CVTSI2SD XMM6, [RBP + 16]
	CVTSI2SD XMM7, [RBP + 24]
	CVTSI2SD XMM8, [RBP + 32]
	CVTSI2SD XMM9, [RBP + 40]

  MULSD XMM0, XMM1
	MULSD XMM0, XMM2
	MULSD XMM0, XMM3
	MULSD XMM0, XMM4
	MULSD XMM0, XMM5
	MULSD XMM0, XMM6
	MULSD XMM0, XMM7
	MULSD XMM0, XMM8
	MULSD XMM0, XMM9

  movsd [RDI], XMM0

	; epilogo
	pop rbp
	ret
