extern malloc
extern sleep
extern wakeup
extern create_dir_entry

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio
sleep_name: DB "sleep", 0
wakeup_name: DB "wakeup", 0

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - init_fantastruco_dir
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - summon_fantastruco
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

; void init_fantastruco_dir(fantastruco_t* card);
global init_fantastruco_dir
init_fantastruco_dir:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; RDI = fantastruco_t*     card
	push RBP
	mov RBP, RSP
	push R12
	push R13
	push R14
	push R15
	;Fin prologo
	mov R12, RDI
	;Preprarar para create_dir_entry de sleep
	mov RDI, sleep_name
	mov RSI, sleep
	call create_dir_entry
	mov R13, RAX                                  ;sleep_dir_entry
		;Preprarar para create_dir_entry de wakeup
	mov RDI, wakeup_name
	mov RSI, wakeup
	call create_dir_entry
	mov R14, RAX                                  ;wakeup_dir_entry

	
	mov RDI, DIRENTRY_SIZE
	shl RDI, 1            ;dir entry size * 2
	call malloc
	mov R15, RAX								 ;directory

	mov [R15 + 0 * 8] , R13
	mov [R15 + 1 * 8] , R14

	mov [R12 + FANTASTRUCO_DIR_OFFSET], R15 ;poner el directorio
	mov WORD[R12 + FANTASTRUCO_ENTRIES_OFFSET], 2 ;poner la cantidad de entrys

	;Prologo
	pop R15
	pop R14
	pop R13
	pop R12
	pop RBP
	ret ;No te olvides el ret!

; fantastruco_t* summon_fantastruco();
global summon_fantastruco
summon_fantastruco:
	; Esta función no recibe parámetros
	push RBP
	mov RBP, RSP
	push R12
	sub RSP, 8
	;;;;;;;;;;;;; fin prolog

	mov RDI, FANTASTRUCO_SIZE
	call malloc
	mov R12, RAX
	; Iniciar faceup y archetype
	mov BYTE[R12 + FANTASTRUCO_FACEUP_OFFSET], 1
	mov QWORD[R12 + FANTASTRUCO_ARCHETYPE_OFFSET], 0 ;puntero NULL
	
	mov RDI, R12
	call init_fantastruco_dir

	mov RAX, R12 ;podria haber cambiado el rax, y no devuelve el init_fantastruco_dir

	;;;;;;;;;;;;; epilogo
	add RSP, 8
	pop R12
	pop RBP
	ret ;No te olvides el ret!
