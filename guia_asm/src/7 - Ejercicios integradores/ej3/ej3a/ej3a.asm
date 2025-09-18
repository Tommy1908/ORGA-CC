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

;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)

global segmentar_casos
segmentar_casos:
push RBP
mov RBP, RSP
push RBX
push R12
push R13
push R14
push R15
sub RSP, 40  ;rbp - 48; rbp - 56; rbp -64; rbp - 72; rbp -80
;Prologo
mov RBX, RDI ; ARREGLO CASOS
xor R12,R12
mov R12D, ESI; largo

;reservar contadores
mov QWORD RDI, 96
call malloc
mov R13, RAX ;contadores
;los limpiamos
mov DWORD[R13], 0 ;(recordar los hicimos de 32 bits)
mov DWORD[R13 + 4], 0
mov DWORD[R13 + 8], 0
mov RDI, RBX
mov ESI, R12D
mov RDX, R13 ;preparo para llamar la funcion
call contar_casos_por_nivel
;;

;ahora hay que crear los c0,c1,c2
mov dword[rbp - 48], R12D ;LARGO
mov R12, R13; ahora aca esta contadores
;creo los c" en null
mov R13, 0
mov R14, 0
mov R15, 0

    cmp DWORD[R12], 0
    je .skip1
    xor RDI, RDI
    mov EDI, DWORD[R12]
    imul RDI, CASO_SIZE
    call malloc
    mov R13, RAX

.skip1:
    cmp DWORD[R12 + 4], 0
    je .skip2
    xor RDI, RDI
    mov EDI, DWORD[R12+ 4]
    imul RDI, CASO_SIZE
    call malloc
    mov R14, RAX

.skip2:
    cmp DWORD[R12 + 8], 0
    je .skip3
    xor RDI, RDI
    mov EDI, DWORD[R12 + 8]
    imul RDI, CASO_SIZE
    call malloc
    mov R15, RAX
.skip3:
;;;;;;;;;;;;;;;;;;;;;;
;ahora crear los iteradores de cada c y el del ciclo
mov QWORD[rbp - 56], 0  ; era para i, igual creo que no hace falta
mov QWORD[rbp - 64], 0  ;i0
mov QWORD[rbp - 72], 0  ;i1
mov QWORD[rbp - 80], 0  ;i2


;;;;;Iterador en base a nivel (el que usea antes asi que lo adapto)
xor R8,R8
mov R8, [rbp - 56]
mov RDI, RBX
mov ESI, dword[rbp - 48]
.ciclo_meter_casos:
    
    cmp R8D, ESI ;Largo en ESI
    je .fin_ciclo
    imul RCX, R8, CASO_SIZE
    lea R9, [RDI + RCX] ;puntero a case 
    mov R10, [R9 + CASO_USUARIO_OFFSET] ;(puntero usuario)
    mov R10D, DWORD [R10 + USUARIO_NIVEL_OFFSET]
    cmp R10, 0
    je .nivel0
    cmp R10, 1
    je .nivel1
    cmp R10, 2
    je .nivel2

;----------------- NIVEL 0 -----------------
.nivel0:
    mov R11, [rbp - 64]        ; i0
    imul R11, R11, CASO_SIZE   ; offset en bytes dentro de c0
    ; categoria
    mov R10D, [R9 + CASO_CATEGORIA_OFFSET]
    mov [R13 + R11 + CASO_CATEGORIA_OFFSET], R10D
    ; estado
    mov R10D, [R9 + CASO_ESTADO_OFFSET]
    mov [R13 + R11 + CASO_ESTADO_OFFSET], R10D
    ; puntero a usuario
    mov R10, [R9 + CASO_USUARIO_OFFSET]
    mov [R13 + R11 + CASO_USUARIO_OFFSET], R10
    ; incrementar i0
    inc DWORD [rbp - 64]
    jmp .sig_contar

;----------------- NIVEL 1 -----------------
.nivel1:
    mov R11, [rbp - 72]        ; i1
    imul R11, R11, CASO_SIZE   ; offset en bytes dentro de c1
    ; categoria
    mov R10D, [R9 + CASO_CATEGORIA_OFFSET]
    mov [R14 + R11 + CASO_CATEGORIA_OFFSET], R10D
    ; estado
    mov R10D, [R9 + CASO_ESTADO_OFFSET]
    mov [R14 + R11 + CASO_ESTADO_OFFSET], R10D
    ; puntero a usuario
    mov R10, [R9 + CASO_USUARIO_OFFSET]
    mov [R14 + R11 + CASO_USUARIO_OFFSET], R10
    ; incrementar i1
    inc DWORD [rbp - 72]
    jmp .sig_contar

;----------------- NIVEL 2 -----------------
.nivel2:
    mov R11, [rbp - 80]        ; i2
    imul R11, R11, CASO_SIZE   ; offset en bytes dentro de c2
    ; categoria
    mov R10D, [R9 + CASO_CATEGORIA_OFFSET]
    mov [R15 + R11 + CASO_CATEGORIA_OFFSET], R10D
    ; estado
    mov R10D, [R9 + CASO_ESTADO_OFFSET]
    mov [R15 + R11 + CASO_ESTADO_OFFSET], R10D
    ; puntero a usuario
    mov R10, [R9 + CASO_USUARIO_OFFSET]
    mov [R15 + R11 + CASO_USUARIO_OFFSET], R10
    ; incrementar i2
    inc DWORD [rbp - 80]
    jmp .sig_contar


    .sig_contar:
    inc R8W
    jmp .ciclo_meter_casos

.fin_ciclo:

    ;libero contadores
    mov RDI, R12
    call free

    ;crear la segmentacion y ponerle los arrays
    mov QWORD RDI, SEGMENTACION_SIZE
    call malloc
    mov [RAX + SEGMENTACION_CASOS0_OFFSET], R13
    mov [RAX + SEGMENTACION_CASOS1_OFFSET], R14
    mov [RAX + SEGMENTACION_CASOS2_OFFSET], R15
;En rax ya esta lo que queremos devolver

add RSP, 40
pop R15
pop R14
pop R13
pop R12
pop RBX
pop RBP
ret


contar_casos_por_nivel:
;RDI -> caso_t* ARREGLO CASOS 
;ESI -> int LARGO
;RDX -> int * Contadores

push RBP
mov RBP, RSP
;Prologo

;;;;;Iterador en base a nivel
xor R8,R8
xor R10,R10
.ciclo_contar_casos:
    cmp R8D, ESI ;Largo en ESI
    je .Epilogo_contar_casos
    imul RCX, R8, CASO_SIZE
    lea R9, [RDI + RCX] ;puntero a case 
    mov R10, [R9 + CASO_USUARIO_OFFSET] ;(puntero usuario)
    mov R10D, DWORD [R10 + USUARIO_NIVEL_OFFSET]
    cmp R10D, 0
    je .nivel0_contar
    cmp R10D, 1
    je .nivel1_contar
    cmp R10D, 2
    je .nivel2_contar
    jmp .sig_contar ;SI, PUEDE HABER NIVEL 3

    .nivel0_contar:
    inc DWORD [RDX + 0]
    jmp .sig_contar
    .nivel1_contar:
    inc DWORD [RDX + 4]
    jmp .sig_contar
    .nivel2_contar:
    inc DWORD [RDX + 8]

    .sig_contar:
    inc R8D
    jmp .ciclo_contar_casos


.Epilogo_contar_casos:
pop RBP
ret