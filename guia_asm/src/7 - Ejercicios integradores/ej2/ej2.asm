extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

FILA  EQU 255
COLUMNA EQU 255
SIZE_OF_PUNTERO EQU 8

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

global optimizar
optimizar:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = mapa_t           mapa[255][255]
	; RSI = attackunit_t*    compartida
	; RDX = uint32_t*        fun_hash(attackunit_t*)
	push RBP
	mov RBP, RSP
	push R12 ;rbp-8		MAPA
	push R13 ;rbp-16	COMPARTIDA
	push R14 ;rbp-24	FUNCION	
	sub RSP, 24;

	;prologo
	mov QWORD [rbp - 32], 0 ;indice i
	mov QWORD [rbp - 40], 0 ;indice j

	mov R12, RDI ;mapa
	mov R13, RSI ;comparida
	mov R14, RDX ;funcion

	mov RDI, RSI
	call RDX
	mov [rbp - 48], RAX ; la funcion de hash nos queda aca

	.cicloI:
	cmp QWORD [rbp - 32], FILA
	JE .finOptimizar

	.cicloJ:
	cmp QWORD [rbp - 40], COLUMNA
	JE .cambiarJ

		;Calcular offset de acceso
	
		mov R10, [rbp - 32]  ;indice i 
		imul R10, R10, COLUMNA ;R10 := i*columnas 
		add R10, [rbp - 40] ; i*columnas + j 
	
		mov RDI, [R12 + R10 * SIZE_OF_PUNTERO] ;mapa R12
	
		;Verificar Iguales o NULL
		cmp RDI, R13 ;comparar con compartida
		JE .siguenteJ
		cmp RDI, 0
		JE .siguenteJ
	
		push RDI ; guardo el UNIT IJ
		push R10
		
		call R14 ; FUNCION HASH
	
		pop R10 ;recupero offset 
		pop RDI ;recupero UNIT
	
		cmp RAX, [rbp - 48] ; Ver si el hash es igual
		jne .siguenteJ
		;OPTIMIZAR!!
		mov [R12 + R10 * SIZE_OF_PUNTERO], R13 ;mapa[i][j] = compartida;
		inc BYTE [R13 + ATTACKUNIT_REFERENCES] ;compartida->references ++;

		;ahora ver si liberamos o no
		mov AL, [RDI + ATTACKUNIT_REFERENCES] ;attackreferences de unitIJ
		cmp AL,1 
		je .borrarIJ
		;sino restamos una referencia
		dec byte[RDI + ATTACKUNIT_REFERENCES]
		jmp .siguenteJ

		.borrarIJ:
		;en rdi esta unit ij
		call free



	.siguenteJ:
	inc QWORD [rbp - 40]
	jmp .cicloJ

	.cambiarJ:
	mov QWORD [rbp - 40], 0 ;indice j = 0
	inc QWORD [rbp - 32] ;indice i ++
	jmp .cicloI

	.finOptimizar:

	add rsp, 24
	pop R14
	pop R13
	pop R12
	;epilogo
	pop RBP
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; RDI = mapa_t           mapa
	; RSI = uint16_t*        fun_combustible(char*)
	push RBP
	mov RBP, RSP
	push R12 ;MAPA
	push R13 ;fun_combustible
	push R14 ;i
	push R15 ;j
	sub RSP, 16
	;EN [RBP - 40] voy a ir acumulando el total

	mov QWORD[RBP-40], 0
	xor R14, R14 ;Preparacion indices
	xor R15, R15 ;Preparacion indices
	mov R12, RDI ;Mapa
	mov R13, RSI ;Func

	.cicloI:
	cmp R14, FILA
	JE .finContar

	.cicloJ:
	cmp R15, COLUMNA
	JE .cambiarJ
	;;;;;;;;;;;;;;

	mov R10, R14
	imul R10, R10, COLUMNA
	add R10, R15
	; R10 = I * COMUNAS + J
	mov R11 , [R12 + R10 * SIZE_OF_PUNTERO] ; AttackUnit
	;Ver que no sea null
	cmp QWORD R11, 0
	je .siguenteJ

	lea RDI, [R11 + ATTACKUNIT_CLASE]
	xor R9D, R9D ;limpio 32 bits porque vamos a devolver 32
	mov R9W, [R11 + ATTACKUNIT_COMBUSTIBLE] ; Combustible
	
	push R9 ;lo guardo
	sub RSP, 8
	

	call R13

	add RSP, 8
	pop R9

	sub R9W, AX ;la diferencia
	add WORD[RBP - 40], R9W

	jmp .siguenteJ

	;;;;;;;;;;;;;;
	.siguenteJ:
	inc QWORD R15
	jmp .cicloJ

	.cambiarJ:
	mov QWORD R15, 0 ;indice j = 0
	inc QWORD R14 ;indice i ++
	jmp .cicloI

	.finContar:
	mov EAX, DWORD[RBP-40]

	add rsp, 16
	pop R15
	pop R14
	pop R13
	pop R12
	pop RBP
	ret

global modificarUnidad
modificarUnidad:
	; RDI = mapa_t           mapa
	; SIL  = uint8_t          x
	; DL  = uint8_t          y
	; RCX = void*            fun_modificar(attackunit_t*)
	;;;;;;;;;;;;;;;;;;
	push RBP
	mov RBP, RSP
	push R12 ;AU
	push R13 ; Info para acceder al mapa
	push R14 ; Mapa
	push R15 ; FUN
	;;;;;;;;;;;;;;;;;; Fin prologo
	mov R15, RCX
	;Conseguir au
	movzx R10, SIL ;que extienda a 64
	movzx R11, DL
	imul R10, COLUMNA
	add R10, R11 ;i * columnas + j
	;Guardar este shifteo y el mapa
	mov R13, R10 ; Lo guardo parar acceder luego al mapa
	mov R14, RDI ; Mapa
	mov R12, [RDI + R10 * SIZE_OF_PUNTERO] ; R12 = AU origina
	;

	;Ver si es null, fin
	cmp R12,0
	JE .finModif
	;

	;Ver la cantidad de referencias, si es 1 MODIFICAR y fin
	mov AL, [R12 + ATTACKUNIT_REFERENCES]
	cmp AL, 1

	JE .finModif1unit
	;

	dec BYTE[R12 + ATTACKUNIT_REFERENCES] ;Restar 1 a las referencias

	;Reservar memoria para el nuevo au
	mov RDI, ATTACKUNIT_SIZE
	call malloc
	;Establecer los valores
	mov BYTE [RAX + ATTACKUNIT_REFERENCES], 1
	mov R8W, [R12 + ATTACKUNIT_COMBUSTIBLE]
	mov [RAX + ATTACKUNIT_COMBUSTIBLE], R8W
	;el array de 11 bytes, tiene 1 de padding ademas, que deberia estar reservado tmb
	mov R10, [R12 + ATTACKUNIT_CLASE] ;8 bytes
	mov R11D, [R12 + ATTACKUNIT_CLASE + 8]; los 4 bytes que faltan

	mov [RAX + ATTACKUNIT_CLASE], R10
	mov [RAX + ATTACKUNIT_CLASE + 8], R11D

	mov [R14 + R13 * SIZE_OF_PUNTERO], RAX

	mov RDI, RAX
	call R15
	jmp .finModif

	.finModif1unit:
	mov RDI, R12
	call R15
	.finModif:

	;;;;;;;;;;;;;;;;;; Epilogo
	pop R15
	pop R14
	pop R13
	pop R12
	pop RBP
	ret
