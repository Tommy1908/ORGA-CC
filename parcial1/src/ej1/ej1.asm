extern malloc

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text


; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140 
TUIT_RETUITS_OFFSET EQU 142
TUIT_ID_AUTOR_OFFSET EQU 144
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0;
USUARIO_SEGUIDORES_OFFSET EQU 8; 
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16; 
USUARIO_SEGUIDOS_OFFSET EQU 24; 
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32; 
USUARIO_BLOQUEADOS_OFFSET EQU 40; 
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48; 
USUARIO_ID_OFFSET EQU 52; 
USUARIO_SIZE EQU 56

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
;rdi -> *MENSAJE
;rsi -> *user
global publicar
publicar:
    push RBP
    mov RBP, RSP
    push rbx ;user
    push r12 ;mensaje
    push r13 ;tuit
    push r14 ;iterador
    push r15 ;seguidor
    sub rsp, 8 ;para alinear
    ;Prologo
    mov rbx, rsi
    mov r12, rdi
    
    ;Creo el tuit
    mov rdi, TUIT_SIZE
    call malloc
    mov r13, rax ;puntero al tuit

    ;Copiar el mensaje
    xor r8,r8 ;iterador
    .ciclo_mensaje:
        cmp r8, 139
        je .fin_ciclo_mensaje

        mov al, byte[r12 + r8] ;*1 (size of char) (leer mensaje)
        cmp al,0
        jne .copy
        ;Si es 0, agregarlo y fin
        mov byte[r13+r8],0 ;el offset de mensaje es 0, y el size of char es 1
        jmp .fin_ciclo_mensaje
        
        .copy:
        ;si no era 0 copio el que lei y sigo
        mov byte[r13+r8], al  ;escribir en tuit
        inc r8
        jmp .ciclo_mensaje
    .fin_ciclo_mensaje:

    ;Terminar de configurar tuit
    mov word[r13 + TUIT_RETUITS_OFFSET], 0
    mov word[r13 + TUIT_FAVORITOS_OFFSET], 0
    mov R8D, [rbx + USUARIO_ID_OFFSET] ;busco el id del user
    mov dword[r13 + TUIT_ID_AUTOR_OFFSET], R8D
    ;;;

    ;Crear publicacion y copiar
    mov rdi, r13 ;copio el tuit
    mov rsi, [rbx + USUARIO_FEED_OFFSET] ;puntero a user feed
    call crear_publicaciones ;en rax devuelve una nueva publi y ya ordeno el feed anterior
    mov rdi, [rbx + USUARIO_FEED_OFFSET] ;puntero a user feed
    mov [rdi + FEED_FIRST_OFFSET], rax ;copia en mi feed la nueva publi

    ;Ahora un loop de esto para los seguidores
    xor r14,r14 ;iterador
    xor r12,r12;cambio r12 a cantidad de seguidores!!
    mov r12d, dword[rbx + USUARIO_CANT_SEGUIDORES_OFFSET]
    .ciclo_seguidores:
        cmp r14d,r12d
        je .fin_ciclo_seguidores

        mov r15, [rbx + USUARIO_SEGUIDORES_OFFSET] ;punterp a array seguidores
        xor r8,r8
        imul r8, r14, 8 ; iterador para seguidores i * puntero (8)
        mov r15, [r15 + r8] ;puntero a seguidor
        mov rdi, [r15 + USUARIO_FEED_OFFSET]
        
        ;preparar para llamada
        mov rdi, r13 ;copio el tuit
        mov rsi, [r15 + USUARIO_FEED_OFFSET] ;puntero a seguidor feed
        call crear_publicaciones
        
        mov rdi, [r15 + USUARIO_FEED_OFFSET] ;puntero a seguidor feed
        mov [rdi + FEED_FIRST_OFFSET], rax ;copio la publi en su feed

        ;siguiente
        inc r14 
        jmp .ciclo_seguidores

        .fin_ciclo_seguidores:
    mov rax, r13; para return *tuit

    ;Epilogo
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop RBP
ret


;;RDI -> PUNTERO TUIT
;;RSI -> PUNTERO FEED
crear_publicaciones:
    push RBP
    mov RBP, RSP
    push R12 ;tuit
    push R13 ;feed
    ;;
    mov R12, RDI
    mov R13, RSI

    ;Crear publicacion nueva
    mov rdi, PUBLICACION_SIZE;
    call malloc
    ;en rax hay un puntero a la nueva publicacion
    mov [rax + PUBLICACION_VALUE_OFFSET], R12 ;muevo el tuit

    ;Busco la publicacion anterior
    mov r8, [r13 + FEED_FIRST_OFFSET] ;puntero a la publicacion anterior
    mov [rax + PUBLICACION_NEXT_OFFSET], r8 ;muevo la publicacion

    pop r13
    pop r12
    pop RBP
    ret