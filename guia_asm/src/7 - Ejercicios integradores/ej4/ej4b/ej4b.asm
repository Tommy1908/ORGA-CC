extern strcmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32


section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

; void invocar_habilidad(void* carta, char* habilidad);
invocar_habilidad:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = void*    card ; Vale asumir que card siempre es al menos un card_t*
	; RSI = char*    habilidad
	push RBP
	mov RBP, RSP
	push R12 ; card
	push R13 ; habilidad
	push R14 ; iterador
	push R15 ; entries
	;;;;;;;;;;;;;;;;;;;;;prologo
	mov R12, RDI
	mov R13, RSI
	;;;;;;;;;;;;
	;Conseguir la cantidad de entries
	xor R14, R14 ;iterador                     (Usar R14W para compararr)
	xor R15, R15
	mov R15W, [R12 + FANTASTRUCO_ENTRIES_OFFSET] ;entries (16bits)

	.cicloInterno:
		cmp R14W, R15W
		je .finCicloInterno

		;Ahora tenemos que comparar el string
		mov R8, [R12 + FANTASTRUCO_DIR_OFFSET]
		mov R8, [R8 + R14 * 8 + DIRENTRY_NAME_OFFSET] ; i * (size of puntero) + 0 (en teoria el nombre)
		mov RDI, R8
		mov RSI, R13 ;habilidad
		call strcmp

		cmp RAX, 0
		je .habilidadInterna
		inc word R14W
		jmp .cicloInterno

		.habilidadInterna:
		mov RDI, R12 ;preparar para call a la funcion
		mov R8, [R12 + FANTASTRUCO_DIR_OFFSET]
		mov R8, [R8 + R14 * 8]
		mov R8, [R8 + DIRENTRY_PTR_OFFSET]
		call R8
		jmp .epilogo
	
	.finCicloInterno:
	;Etonces si no se encontro aca adentro hay que ver si hay archetype
	mov R8, [R12 + FANTASTRUCO_ARCHETYPE_OFFSET]
	cmp R8, 0
	je .epilogo ;si era null terminamos
	;creo q con llamar de una ya a la recursion deberi andar

	mov R12, [R12 + FANTASTRUCO_ARCHETYPE_OFFSET] ;ahora tratamos a esta como nuestra carta
	mov RDI, R12
	mov RSI, R13
	call invocar_habilidad

	;xor R14, R14 ;iterador                     (Usar R14W para compararr)
	;xor R15, R15
	;mov R12, [R12 + FANTASTRUCO_ARCHETYPE_OFFSET] ;ahora tratamos a esta como nuestra carta
	;mov R15W, [R12 + FANTASTRUCO_ENTRIES_OFFSET] ;entries (16bits)
	;.cicloArchetype:

	.epilogo:

	pop R15
	pop R14
	pop R13
	pop R12
	pop RBP
	ret ;No te olvides el ret!
