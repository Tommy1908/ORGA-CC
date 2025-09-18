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

global resolver_automaticamente

;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
resolver_automaticamente:
    push RBP ;alineado
    mov RBP, RSP
    push R12 ;funcion
    push R13 ;arreglo casos
    push R14 ;casos a revisar
    push R15 ;largo
    push RBX ;Iiterador
    sub RSP, 8 ;[RBP-48] iterador de casos a revisar
    ;prologo

    mov R12, RDI ;funcion
    mov R13, RSI ;arreglo casos
    mov R14, RDX ;casos a revisar
    mov R15D, ECX ;largo
    mov QWORD[RBP-48], 0



    ;for(int i = 0; i < largo; i++)
    xor RBX, RBX; iterador
    .ciclo:
        cmp EBX, R15D
        je .fin_ciclo
        ;;;;;;;;;;;;;;
        ; Tomar el caso
        imul R10, RBX, CASO_SIZE
        lea R9, [R13 + R10] ;puntero al caso
        mov R10, [R9 + CASO_USUARIO_OFFSET];puntero a usuario
        mov R10D, [R10 + USUARIO_NIVEL_OFFSET];nivel
        
        ;Comparar nivel ;if(user.nivel == 0){}else{niveles1y2}
        cmp R10, 0
        jne .niveles1y2
        jmp .agregar_a_revisar ;los casos 0 se agregan directamente

        .niveles1y2:
        mov RDI, R9 ;poenmos el puntero al caso y llamamos a la funcion
        call R12
        ;recuperamos el puntero x las dudas
        imul R10, RBX, CASO_SIZE
        lea R9, [R13 + R10] ;puntero al caso
        ;Comparamos el resultado con los casos
        ;if(res == 1){}else{}
        cmp rax, 1
        je .resultado1

        .resultado0:
        ;Comparar los strings categoria
        .check_CLT:
        ;Como el test estaba mal basta compara la word, pero sino bit a bit
        ;por alguna razon no pude hacerlo anda con strncmp porque no era un puntero, habia que usar rel..no lo vimos
        ; es medio nefasto pero nos evitamos calcualr la palabra en hexa (se puede)
        lea RDI, dword[R9+ CASO_CATEGORIA_OFFSET]
        mov SIL, byte[RDI + 0]
        mov AL, 'C'
        cmp AL, SIL
        jne .check_RBO
        mov SIL, byte[RDI + 1]
        mov AL, 'L'
        cmp AL, SIL
        jne .check_RBO
        mov SIL, byte[RDI + 2]
        mov AL, 'T'
        cmp AL, SIL
        jne .check_RBO
        mov SIL, byte[RDI + 3]
        mov AL, 0
        cmp AL, SIL
        je .puede_cerrarse

        ;comparamos con el otro
        .check_RBO:
        lea RDI, dword[R9+ CASO_CATEGORIA_OFFSET]
        mov SIL, byte[RDI + 0]
        mov AL, 'R'
        cmp AL, SIL
        jne .agregar_a_revisar
        mov SIL, byte[RDI + 1]
        mov AL, 'B'
        cmp AL, SIL
        jne .agregar_a_revisar
        mov SIL, byte[RDI + 2]
        mov AL, 'O'
        cmp AL, SIL
        jne .check_RBO
        mov SIL, byte[RDI + 3]
        mov AL, 0
        cmp AL, SIL
        je .puede_cerrarse
        ;si no se puede cerrar, hay que seguir
        jmp .agregar_a_revisar

            .puede_cerrarse:
            mov word[R9 + CASO_ESTADO_OFFSET], 2
            jmp .siguiente


        .resultado1:
        ;arreglo_casos[i].estado = 1
        mov word[R9 + CASO_ESTADO_OFFSET], 1
        jmp .siguiente

        

    .siguiente:
    inc EBX
    jmp .ciclo

    .agregar_a_revisar:
    ;Neceistamos la pos
    mov RDI, [RBP-48] ;iterador de casos a agregar
    imul R10, RDI, CASO_SIZE; ;base de donde tenemos que copiar

    ;copiar el char[3] + padding
    mov EDI, [R9 + CASO_CATEGORIA_OFFSET]
    mov R11, R10 ;copio la base
    add R11, CASO_CATEGORIA_OFFSET
    mov [R14 + R11], EDI
    
    ;copiar el estado uint_16 + 2 padding
    mov EDI, [R9 + CASO_ESTADO_OFFSET]
    mov R11, R10 ;reset de la base 
    add R11, CASO_ESTADO_OFFSET
    mov [R14 + R11], EDI

    ;copio el puntero a jugador
    mov RDI, [R9 + CASO_USUARIO_OFFSET]
    mov R11, R10 ;reset de la base 
    add R11, CASO_USUARIO_OFFSET
    mov [R14 + R11], RDI

    ;incrementamos el iterado de casos a revisar
    inc RBX

    jmp .ciclo

    .fin_ciclo:

    .epilogo:


    add RSP, 8
    pop RBX
    pop R15
    pop R14
    pop R13
    pop R12
    pop RBP
    ret
