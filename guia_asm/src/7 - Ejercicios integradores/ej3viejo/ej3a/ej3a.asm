extern malloc
extern free

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

SIZE_OF_INT EQU 4

;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
global segmentar_casos
segmentar_casos:
push RBP
mov RBP, RSP
push R12 ;array casos
push R13 ;largo
push R14 ;contadores
push R15 ;segment
sub RSP, 32;    [RSP - 40] a [RSP -56] va a ser para los arrays
;;Guardar parametros de entrada
mov R12, RDI ;ARREGLO CASOS
mov R13D, ESI ;LARGO

;Conseguir contadores
mov QWORD RDI, 3
imul QWORD RDI, SIZE_OF_INT

call malloc
mov R14, RAX ; Contadores
mov QWORD[R14 + 0 * SIZE_OF_INT], 0
mov QWORD[R14 + 1 * SIZE_OF_INT], 0
mov QWORD[R14 + 2 * SIZE_OF_INT], 0
;
;Paparar datos para contar casos
mov RDI, R12
mov ESI, R13D
mov RDX, RAX 

call contar_casos_por_nivel ; como yo la hice se que solo toque de R8-R11 (igual guarde todo)
;;;;;;;;;;;;;

;Crear las segmentaciones
mov QWORD RDI,SEGMENTACION_SIZE
call malloc
mov R15, RAX ; segmentacion


;ahora ver si quedan null o reservar memoria
mov R11, [R14 + 0 *SIZE_OF_INT]
cmp R11, 0
je .c0is0
mov RDI, R11
imul QWORD RDI, CASO_SIZE
call malloc
mov [RSP - 40], RAX

.c0is0:
mov R11, [R14 + 1 *SIZE_OF_INT]
cmp R11, 0
jne .c1is0
mov RDI, R11
imul QWORD RDI, CASO_SIZE
call malloc
mov [RSP - 48], RAX

.c1is0:
mov R11, [R14 + 2 *SIZE_OF_INT]
cmp R11, 0
jne .c2is0
mov RDI, R11
imul QWORD RDI, CASO_SIZE
call malloc
mov [RSP - 56], RAX

.c2is0:
;;Guardar en el struct los arrays (punteros)
mov R8, [RSP - 40]
mov [R15 + SEGMENTACION_CASOS0_OFFSET], R8
mov R8, [RSP - 48]
mov [R15 + SEGMENTACION_CASOS1_OFFSET], R8
mov R8, [RSP - 56]
mov [R15 + SEGMENTACION_CASOS2_OFFSET], R8

;vamos a reutilizar esa memoria
mov QWORD[RSP - 40], 0 ;contador para casos 0
mov QWORD[RSP - 48], 0 ;contador para casos 1
mov QWORD[RSP - 56], 0 ;contador para casos 2


;;;Ahora poner los casos
xor R8,R8 ; iterador
.cicloArreglo:
    cmp R8D, R13D
    je .finSegmentar

    ;Acceder a nivel
    imul R9, R8, CASO_SIZE ; NO PUEDE SER ESCALAR DE 16 EN DIRECCIONAMIENTO
    lea R9, [R12+ R9] ;array de casos + i * Caso size   ES EL CASO
    mov R10, [R9 + CASO_USUARIO_OFFSET]
    mov R11D, DWORD[R10 + USUARIO_NIVEL_OFFSET]; Nivel


    cmp R11, 0
    je .nivel0copy
    cmp R11, 1
    je .nivel1copy
    cmp R11, 2
    je .nivel2copy


    .nivel0copy:
    ; Verificar si el array de nivel 0 existe
    mov RAX, [R15 + SEGMENTACION_CASOS0_OFFSET]
    test RAX, RAX
    jz .cicloArregloPrep    ; Saltar si es NULL

    ; Calcular dirección destino
    mov RDI, [RSP - 40]            ; Contador caso 0
    imul RDI, CASO_SIZE
    add RAX, RDI            ; RAX = dirección destino

    ; Copiar la categoría (3 bytes) - método seguro
    mov ESI, DWORD[R9] ;esto seria el array de char
    mov [RAX], ESI

    ; Copiar el estado (2 bytes)
    mov dx, WORD [R9 + CASO_ESTADO_OFFSET]
    mov [RAX + CASO_ESTADO_OFFSET], dx

    ; Copiar el puntero al usuario (8 bytes)
    mov RCX, [R9 + CASO_USUARIO_OFFSET]
    mov [RAX + CASO_USUARIO_OFFSET], RCX

    ; Incrementar contador de casos nivel 0
    inc QWORD[RSP - 40] 
    jmp .cicloArregloPrep

    .nivel1copy:
    ; Verificar si el array de nivel 0 existe
    mov RAX, [R15 + SEGMENTACION_CASOS0_OFFSET]
    test RAX, RAX
    jz .cicloArregloPrep    ; Saltar si es NULL

    ; Calcular dirección destino
    mov RDI, [RSP - 48]            ; Contador caso 0
    imul RDI, CASO_SIZE
    add RAX, RDI            ; RAX = dirección destino

    ; Copiar la categoría (3 bytes) - método seguro
    mov ESI, DWORD[R9] ;esto seria el array de char
    mov [RAX], ESI

    ; Copiar el estado (2 bytes)
    mov dx, WORD [R9 + CASO_ESTADO_OFFSET]
    mov [RAX + CASO_ESTADO_OFFSET], dx

    ; Copiar el puntero al usuario (8 bytes)
    mov RCX, [R9 + CASO_USUARIO_OFFSET]
    mov [RAX + CASO_USUARIO_OFFSET], RCX

    ; Incrementar contador de casos nivel 0
    inc QWORD[RSP - 48] 
    jmp .cicloArregloPrep

    .nivel2copy:
    ; Verificar si el array de nivel 0 existe
    mov RAX, [R15 + SEGMENTACION_CASOS0_OFFSET]
    test RAX, RAX
    jz .cicloArregloPrep    ; Saltar si es NULL

    ; Calcular dirección destino
    mov RDI, [RSP - 56]            ; Contador caso 0
    imul RDI, CASO_SIZE
    add RAX, RDI            ; RAX = dirección destino

    ; Copiar la categoría (3 bytes) - método seguro
    mov ESI, DWORD[R9] ;esto seria el array de char
    mov [RAX], ESI

    ; Copiar el estado (2 bytes)
    mov dx, WORD [R9 + CASO_ESTADO_OFFSET]
    mov [RAX + CASO_ESTADO_OFFSET], dx

    ; Copiar el puntero al usuario (8 bytes)
    mov RCX, [R9 + CASO_USUARIO_OFFSET]
    mov [RAX + CASO_USUARIO_OFFSET], RCX

    ; Incrementar contador de casos nivel 0
    inc QWORD[RSP - 56] 
    jmp .cicloArregloPrep

    .cicloArregloPrep:
    inc R8D
    jmp .cicloArreglo

.finSegmentar: 

;;Por ultimo free contadores
mov RDI, R14
call free

mov RAX, R15

;Epilogo
add RSP, 32
pop R15
pop R14
pop R13
pop R12
pop RBP
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global contar_casos_por_nivel
contar_casos_por_nivel:
;RDI arreglo casos
;ESI largo
;RDX contador

push RBP
mov RBP, RSP

xor R8,R8 ;iterador
.cicloCasos:
    cmp R8D, ESI
    je .fin_contar_casos_por_nivel

    imul R9, R8, CASO_SIZE ; NO PUEDE SER ESCALAR DE 16 EN DIRECCIONAMIENTO
    lea R9, [RDI+ R9] ;RDI + i * Caso size
    mov R10, [R9 + CASO_USUARIO_OFFSET]
    mov R11D, DWORD[R10 + USUARIO_NIVEL_OFFSET]

    cmp R11D, 0
    je .cc0
    cmp R11D, 1
    je .cc1
    cmp R11D, 2
    je .cc2


    .cc0:
    inc DWORD [RDX]
    jmp .cicloCasosPrep

    .cc1:
    inc DWORD [RDX + 4]
    jmp .cicloCasosPrep

    .cc2:
    inc DWORD [RDX + 8]
    jmp .cicloCasosPrep

    .cicloCasosPrep:
    inc R8D
    jmp .cicloCasos

    .fin_contar_casos_por_nivel:

pop RBP
ret