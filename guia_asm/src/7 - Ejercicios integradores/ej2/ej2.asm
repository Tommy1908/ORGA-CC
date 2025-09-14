extern malloc

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
EJERCICIO_2B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

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
	inc QWORD [R13 + ATTACKUNIT_REFERENCES] ;compartida->references ++;

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
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret
