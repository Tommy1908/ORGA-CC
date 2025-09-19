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

; tuit_t **trendingTopic(usuario_t *usuario, uint8_t (*esTuitSobresaliente)(tuit_t *));
global trendingTopic 
trendingTopic:
    push RBP
    mov rbp, rsp
    push rbx ;user
    push r12 ;func
    push r13 ;array
    push r14 ;count, 
    push r15 ;publicacion
    sub rsp, 8
    ;;;prologo
    mov rbx, rdi ;*user
    mov r12, rsi ;fun
    xor r14,r14;count, luego iterador
    ;xor r13,r13; array

    ;tomo la primer publi
    mov r15, [rbx + USUARIO_FEED_OFFSET] ;puntero a feed
    mov r15, [r15 + FEED_FIRST_OFFSET] ;puntero primer publi

    .ciclocount:
        cmp r15,0 ;publi != 0
        je .finciclocount
        mov rdi, [r15 + PUBLICACION_VALUE_OFFSET] ;puntero a tuit
        ;;ver que sea mismo id
        mov esi, dword[rdi + TUIT_ID_AUTOR_OFFSET] ;id tuit
        mov edx, dword[rbx + USUARIO_ID_OFFSET] ;id user
        cmp esi, edx
        jne .sigcontar
        ;llamo la f
        call r12
        cmp rax, 0
        je .sigcontar
        inc r14 ;inc count

        .sigcontar:
        mov r15, [r15 + PUBLICACION_NEXT_OFFSET] ;siguiente pub
        jmp .ciclocount

    .finciclocount:

    cmp r14, 0
    je .retunrnull

    ;si no es 0 count crear array
    inc r14 ;(tiene que termina en null)
    imul rdi, r14, 8 ;COUNT*punteros
    call malloc
    mov r13, rax ;array
    xor r14,r14 ;iterador

    ;tomo la primer publi
    mov r15, [rbx + USUARIO_FEED_OFFSET] ;puntero a feed
    mov r15, [r15 + FEED_FIRST_OFFSET] ;puntero primer publi

    .cicloarr:
        cmp r15,0 ;publi != 0
        je .fincicloarr
        mov rdi, [r15 + PUBLICACION_VALUE_OFFSET] ;puntero a tuit
        mov esi, dword[rdi + TUIT_ID_AUTOR_OFFSET] ;id tuit
        mov edx, dword[rbx + USUARIO_ID_OFFSET] ;id user
        cmp esi, edx
        jne .sigarr ;si los id no son iguales skip
        

        ;sino en rdi esta el tuit
        call r12
        cmp rax, 0
        je .sigarr
        ;si es sobresaliete
        mov rdi, [r15 + PUBLICACION_VALUE_OFFSET] ;puntero a tuit x si se borro
        imul r8, r14, 8
        mov [r13 + r8], rdi  ;escribir tuit en array
        inc r14 ;inc count

        .sigarr:
        mov r15, [r15 + PUBLICACION_NEXT_OFFSET] ;siguiente pub
        jmp .cicloarr

    .fincicloarr:
    imul r8, r14, 8
    mov QWORD[r13 + r8], 0;null terminator
    mov rax, r13 ;poner array en respuesta
    jmp .epilogo



    .retunrnull:
    mov rax, 0
    

    .epilogo:
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop R12
    pop rbx
    pop rbp
    ret
