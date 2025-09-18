extern strncmp
extern malloc

;########### SECCION DE DATOS
section .data
str_clt db "CLT", 0
str_rbo db "RBO", 0
str_ksc db "KSC", 0
str_kdt db "KDT", 0

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

global calcular_estadisticas

;void calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id)
calcular_estadisticas:
    push RBP
    mov RBP, RSP
    push RBX ;ARREGLO
    push R12 ;USER ID
    push R13 ;ITERADOR
    push R14 ;ESTADISTICAS
    push R15 ;puntero al caso
    sub RSP, 8 ;[RBP - 48] ;LARGO
    ;prologo
    mov RBX, RDI ;ARREGLO DE CASOS
    mov [RBP - 48], ESI ;LARGO
    mov R12D, EDX; User id

    ;puntero a estadisticas y limpio el espacio
    mov RDI, ESTADISTICAS_SIZE
    call malloc
    mov R14, RAX 
    mov DWORD[R14], 0
    mov WORD[R14+4],0
    mov BYTE[R14+6],0 
    ;;;

    xor R13,R13 ; iterador

    .ciclo:
        cmp R13D, DWORD[RBP - 48]
        je .fin

        ;Obtener caso en registro no volatil
        imul R15, R13, CASO_SIZE
        lea R15, [RBX + R15] ; puntero al caso

        ;Verificar si user id es 0, si lo es registramos, sino filtramos antes
        cmp R12D, 0
        je .registrarValores

        ;Si no es 0, verificamos usuario_id == arreglo_casos[i].usuario->id
        mov R8, [R15 + CASO_USUARIO_OFFSET] ;puntero a usuario
        mov R8D, [R8 + USUARIO_ID_OFFSET]
        cmp R8D, R12D
        je .registrarValores
        ;Sino siguiente iteracion
        jmp .siguiente

            .registrarValores:
                ;Registrar caterogia
                mov RDI, R15 + CASO_CATEGORIA_OFFSET  ;puntero a categoria
                mov RSI, str_clt  ;si, es un puntero
                mov RDX, 4
                call strncmp
                cmp RAX, 0
                jne .RBO; si no son iguales salta
                inc byte [R14 + ESTADISTICAS_CLT_OFFSET]

                .RBO:
                mov RDI, R15 + CASO_CATEGORIA_OFFSET  ;puntero a categoria
                mov RSI, str_rbo  ;si, es un puntero
                mov RDX, 4
                call strncmp
                cmp RAX, 0
                jne .KSC; si no son iguales salta
                inc byte [R14 + ESTADISTICAS_RBO_OFFSET]

                .KSC:
                mov RDI, R15 + CASO_CATEGORIA_OFFSET  ;puntero a categoria
                mov RSI, str_ksc  ;si, es un puntero
                mov RDX, 4
                call strncmp
                cmp RAX, 0
                jne .KDT; si no son iguales salta
                inc byte [R14 + ESTADISTICAS_KSC_OFFSET]

                .KDT:
                mov RDI, R15 + CASO_CATEGORIA_OFFSET  ;puntero a categoria
                mov RSI, str_kdt  ;si, es un puntero
                mov RDX, 4
                call strncmp
                cmp RAX, 0
                jne .estados; si no son iguales salta
                inc byte [R14 + ESTADISTICAS_KDT_OFFSET]

            .estados:
                mov R8W, [R15 + CASO_ESTADO_OFFSET]
                .e0:
                cmp R8W, 0
                jne .e1
                inc byte [R14 + ESTADISTICAS_ESTADO0_OFFSET]

                .e1:
                cmp R8W, 1
                jne .e2
                inc byte [R14 + ESTADISTICAS_ESTADO1_OFFSET]

                .e2:
                cmp R8W, 2
                jne .siguiente
                inc byte [R14 + ESTADISTICAS_ESTADO2_OFFSET]

            .siguiente:
                inc R13
                jmp .ciclo

    .fin:
        mov RAX, R14

    ;epilogo
    add RSP,8
    pop R15
    pop R14
    pop R13
    pop R12
    pop RBX
    pop RBP
    ret
