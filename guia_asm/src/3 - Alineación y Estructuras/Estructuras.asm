

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos:
	MOV R10, [RDI] ;Acceder al elemento del struct (puntero a head)

	XOR RAX, RAX ; Aca voy a ir acumulando la suma
	.cicloNodos:
	MOV RDI, [R10 + NODO_OFFSET_LONGITUD] ;RDI tiene la lon del array
	ADD RAX, RDI ; Sumo al contador
	mov R10, [R10]; Apunta al next

	;Si next no es 0 salta
	CMP R10, 0
	JNE .cicloNodos

	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	MOV R10, [RDI] ;Acceder al elemento del struct (puntero a head)

	XOR RAX, RAX ; Aca voy a ir acumulando la suma
	.cicloNodos:
	MOV RDI, [R10 + PACKED_NODO_OFFSET_LONGITUD] ;RDI tiene la lon del array
	ADD RAX, RDI ; Sumo al contador
	mov R10, [R10]; Apunta al next

	;Si next no es 0 salta
	CMP R10, 0
	JNE .cicloNodos

	ret

