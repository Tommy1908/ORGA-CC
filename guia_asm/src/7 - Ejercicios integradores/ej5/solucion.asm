; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5

; Marca un OFFSET o SIZE como no completado
; Esto no lo chequea el ABI enforcer, sirve para saber a simple vista qué cosas
; quedaron sin completar :)
NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU 416

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

; Variables globales de sólo lectura
section .rodata

; Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - hay_accion_que_toque
global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

; Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - invocar_acciones
global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE

; Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contar_cartas
global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text

; Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
; nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
; parámetro.
;
; El resultado es un valor booleano, la representación de los booleanos de C es
; la siguiente:
;   - El valor `0` es `false`
;   - Cualquier otro valor es `true`
;
; ```c
; bool hay_accion_que_toque(accion_t* accion, char* nombre);
; ```
global hay_accion_que_toque
hay_accion_que_toque:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = accion_t*  accion
	; RSI = char*      nombre
	push RBP
	mov RBP, RSP
	push R12
	push R13
	;Prologo
	mov R12, RDI ;ACCION
	mov R13, RSI ;NOMBRE

	;if NULL return false
	cmp R12, 0
	je .hay_accion_que_toque_return_false
	;
	;Comparar nombre
	mov R8, [R12 + accion.destino] ;accedo a la carta destino
	lea RDI, [R8 + carta.nombre] ;puntero al nombre
	mov RSI, R13 ;nombre con el que comparo
	;mov QWORD RDX, 12 ; no uso strncmp  xq pusieron strcmp pero podria usarlo xra asegurar
	call strcmp
	cmp RAX, 0
	je .hay_accion_que_toque_return_true ;si son iguales stru
	;

	;Ver si la siguiente tiene el mismo nombre la carta
	mov RDI, [R12 + accion.siguiente] ;accedo a la siguiente accion
	;ver que no sea null
	cmp RDI, 0
	je .hay_accion_que_toque_return_false
	;Si no era null
	mov RSI, R13 ;el nombre
	call hay_accion_que_toque
	jmp .Epilogo_hay_accion_que

	.hay_accion_que_toque_return_false:
	mov RAX, 0
	jmp .Epilogo_hay_accion_que
	.hay_accion_que_toque_return_true:
	mov RAX, 1

	.Epilogo_hay_accion_que:
	pop R13
	pop R12
	pop RBP
	ret

; Invoca las acciones que fueron encoladas en la secuencia proporcionada en el
; primer parámetro.
;
; A la hora de procesar una acción esta sólo se invoca si la carta destino
; sigue en juego.
;
; Luego de invocar una acción, si la carta destino tiene cero puntos de vida,
; se debe marcar ésta como fuera de juego.
;
; Las funciones que implementan acciones de juego tienen la siguiente firma:
; ```c
; void mi_accion(tablero_t* tablero, carta_t* carta);
; ```
; - El tablero a utilizar es el pasado como parámetro
; - La carta a utilizar es la carta destino de la acción (`accion->destino`)
;
; Las acciones se deben invocar en el orden natural de la secuencia (primero la
; primera acción, segundo la segunda acción, etc). Las acciones asumen este
; orden de ejecución.
;
; ```c
; void invocar_acciones(accion_t* accion, tablero_t* tablero);
; ```
global invocar_acciones
invocar_acciones:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = accion_t*  accion
	; RSI = tablero_t* tablero
	push RBP
	mov RBP, RSP
	push R12
	push R13
	;prologo
	mov R12, RDI; ACCION
	mov R13, RSI; TABLERO

	;ver que no sea accion null
	cmp R12, 0
	je .epilogo_invocar_acciones
	;Agrego ver que la carta no sea null, si es, seguir
	;mov R8, [R12 + accion.destino]
	;cmp R8, 0
	;je .invocar_siguiente
	
	;tenemos que ver que la accion destino este en juego
	mov R8, [R12 + accion.destino]
	mov AL, [R8 + carta.en_juego]  ;aparentemente R8 no se puede usar la parte baja, en R8-R15. Podria limpiarlo y usar R8 pero fue
	cmp AL, 0
	je .invocar_siguiente
	;si estaba activa
	mov R8, [R12 + accion.invocar] ; tomamos la accion
	mov RSI, [R12 + accion.destino] ;puntero a la carta
	mov RDI, R13
	call R8
	;hecha la accion tenemos que volver a ver la carta para ver su vida, si 0 (o menos para asegurar) la sacamos de juego
	mov R8, [R12 + accion.destino]
	mov R9W, [R8 + carta.vida]
	cmp R9W, 0
	jg .invocar_siguiente   ;Si es mayor estricto a 0, que siga
	;sino aca la sacamos de juego
	mov BYTE[R8 + carta.en_juego], 0


	.invocar_siguiente:
	mov RDI, [R12 + accion.siguiente]
	mov RSI, R13
	call invocar_acciones

	.epilogo_invocar_acciones:
	pop R13
	pop R12
	pop RBP	
	ret

; Cuenta la cantidad de cartas rojas y azules en el tablero.
;
; Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
; correspondientes al jugador rojo y al jugador azul. Este conteo incluye tanto
; a las cartas en juego cómo a las fuera de juego (siempre que estén visibles
; en el campo).
;	.finClo:
; Se debe considerar el caso de que el campo contenga cartas que no pertenecen
; a ninguno de los dos jugadores.
;
; Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
; una carta.
;
; El resultado debe ser escrito en las posiciones de memoria proporcionadas
; como parámetro.
;
; ```c
; void contar_cartas(tablero_t* tablero, uint32_t* cant_rojas, uint32_t* cant_azules);
; ```
global contar_cartas
contar_cartas:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = tablero_t* tablero
	; RSI = uint32_t*  cant_rojas
	; RDX = uint32_t*  cant_azules
	push RBP
	mov RBP, RSP
	push RBX ; tablero
	push R12 ;puntero a cant_rojo
	push R13 ;puntero a cant_azul
	push R14 ; i
	push R15 ; j
	;prologo
	mov RBX, RDI ;tablero
	mov R12, RSI ;rojo
	mov R13, RDX ;azul
	;Vi que empezaba poniendolos en 0 capaz para que pasen los test pero parece una buena idea
	mov DWORD [R12], 0
	mov DWORD [R13], 0
	;ahora el ciclo
	
	xor R14,R14; iterador i
	.cicloI:
		cmp R14, tablero.ALTO
		je .epilogo_contar 			;al terminal el ciclo return
		xor R15,R15; iterador j
		.cicloJ:
		cmp R15, tablero.ANCHO
		je .nextI

		;ver que haya carta y no sea null
		lea R8, [RBX + tablero.campo] ;me da el inicio del campo (podria calcularlo solo 1 vez)
		;offset con los iterador
		mov R9, R14
		imul R9, tablero.ANCHO
		add R9, R15 ; R9 = i * ancho + j
		mov R9, [R8 + R9 * 8] ;*8 porque son punteros a cartas

		cmp R9, 0 ;si es null, siguiente iteracion
		je .nextJ
		;ahora hay que ver a que jugador pertencen
		;EL JUGADOR ERA 1 BYTE!!!
		mov AL, [R9 + carta.jugador]

		cmp AL, JUGADOR_ROJO
		je .sumarRojo

		cmp AL, JUGADOR_AZUL
		je .sumarAzul

		.nextJ:
		inc R15
		jmp .cicloJ
	
	.nextI:
	inc R14
	jmp .cicloI

	.sumarRojo:
	inc DWORD [R12]
	jmp .nextJ

	.sumarAzul:
	inc DWORD [R13]
	jmp .nextJ


	.epilogo_contar:
	pop R15
	pop R14
	pop R13
	pop R12
	pop RBX
	pop RBP
	ret
