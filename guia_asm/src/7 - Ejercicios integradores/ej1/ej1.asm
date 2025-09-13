extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

SIZE_UINT16 EQU 2
SIZE_UINT32 EQU 4
SIZE_UINT64 EQU 8
SIZE_PUNTERO EQU 8

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = item_t**     inventario
	; RSI = uint16_t*    indice
	; DX = uint16_t     tamanio
	; RCX = comparador_t comparador

	;prologo
	push RBP ;pila alineada
  	mov RBP, RSP ;strack frame armado
	push R12
	push R13
	push R14
	push R15
	push RBX
	sub RSP, 8

	; Si el tamaño es <=1 es trivialmente true
	cmp DX, 1
	jb .fin_es_indice_ordenado

	mov R12, RDI ;inventario
	mov R13, RSI ;indice
	xor R14, R14 ;limpio posible basura
	mov R14W, DX; tamaño
	mov R15, RCX; comparador

	;Preparar pirmer elemento
	xor RBX, RBX ;iterador
	movzx r10, word [R13 + RBX * SIZE_UINT16] ; R12+0
	mov RDI, [R12 + r10 * SIZE_PUNTERO] ; nos da el puntero en inventario con el indice iesimo de "indice"
	
	.loop:
	inc RBX
	cmp EBX, R14D ;tuve que poner estos xq sino los flags no andaban
	je .finTrue

	movzx r10, word [R13 + RBX * SIZE_UINT16]
	mov RSI, [R12 + r10 * SIZE_PUNTERO]
	call R15 ;f de comparacion

	cmp rax, 0
	je .finFalse
	;cargamos b en a y repetimos
	movzx r10, word [R13 + RBX * SIZE_UINT16]
	mov RDI, [R12 + r10 * SIZE_PUNTERO] 
	jmp .loop

	.finFalse:
	mov RAX, FALSE
	jmp .fin_es_indice_ordenado

	.finTrue:
	mov RAX, TRUE

	.fin_es_indice_ordenado:

	;epilogo
	add RSP, 8
	POP RBX
	POP R15
	POP R14
	POP R13
	POP R12
	pop RBP
	ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario
indice_a_inventario:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = item_t**     inventario
	; RSI = uint16_t*    indice
	; DX = uint16_t     tamanio

	push RBP ;pila alineada
  	mov RBP, RSP ;strack frame armado
	push RDI
	push RSI
	push RDX
	sub RSP, 8
	;;;;;;;;;;;;;;;;
	
	mov RDI, ITEM_SIZE ;uso el registro completo para no tener basura
	movzx RSI, word DX ;lo mismo
	imul RDI, RSI ;uso 64 bits para que si al multiplicar 16 excede, que no lo trunque
	
	call malloc

	;Restauro la pila hasta el rbp
	add RSP,8
	pop RDX
	pop RSI
	pop RDI
	;;;

	xor R8, R8 ;iterador
	.cicloIndiceInventario:
	cmp R8W, DX
	je .finIndice_a_inventario

	movzx R9, word[RSI + R8 * SIZE_UINT16] ;indice[i]
	mov R10, Qword[RDI + R9 * SIZE_PUNTERO]; valor de inventario[indice[i]]
	mov [RAX + R8 * SIZE_PUNTERO], R10
	
	inc R8
	jmp .cicloIndiceInventario

	.finIndice_a_inventario:
	;;;;;;;;;;;;;;;;
	pop RBP
	ret
