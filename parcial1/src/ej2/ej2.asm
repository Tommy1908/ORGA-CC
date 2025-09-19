extern free

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

; void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear);
global bloquearUsuario 
bloquearUsuario:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rbx, rdi ;usuario
    mov r12, rsi ;usuario a bloquear
    
    ;agregar a bloqueados al usuario
    xor r8,r8
    mov R8D, dword[rbx + USUARIO_CANT_BLOQUEADOS_OFFSET]
    imul R8D, 8 ;lugar a agregar los bloqueados 
    lea rax, [rbx + USUARIO_BLOQUEADOS_OFFSET];en rax lista blqoueados
    mov [rax + R8], r12 ;copiar el usuario a bloquear
    inc dword[rbx + USUARIO_CANT_BLOQUEADOS_OFFSET];incrementar bloqueados

    ;ahora limpiar las publis
    mov esi, [r12 + USUARIO_ID_OFFSET]
    mov rdi, [rbx + USUARIO_FEED_OFFSET]
    call borrar_publis
    mov esi, [rbx + USUARIO_ID_OFFSET]
    mov rdi, [r12 + USUARIO_FEED_OFFSET]
    call borrar_publis

    pop r12
    pop rbx
    pop rbp
ret





borrar_publis:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rbx, rdi ;feed
    mov R12D, ESI ;id

    .c1:
    cmp rbx, 0
    je .epilogo
    mov r8, [rbx + FEED_FIRST_OFFSET] ;primer publi
    mov r9, [r8 + PUBLICACION_VALUE_OFFSET] ;tuit
    mov r9d, dword[r8 + TUIT_ID_AUTOR_OFFSET] ;id
    cmp r9d, r12d;
    jne .primeroBien
    mov r9, [r8 + PUBLICACION_NEXT_OFFSET] ;sig
    mov rdi,r8
    call free
    mov [rbx + FEED_FIRST_OFFSET], r9 ;primera es sig
    
    jmp .c1
    
    .primeroBien:
    mov rbx, [rbx + FEED_FIRST_OFFSET] ;primer publi en rbx ahora
    .c2:
    cmp rbx, 0
    je .epilogo
    mov r8, [rbx + PUBLICACION_NEXT_OFFSET]
    cmp r8, 0
    je .sig0
    mov r8, [r8 + PUBLICACION_VALUE_OFFSET];tuit
    mov r9d, dword[r8 + TUIT_ID_AUTOR_OFFSET] ;id tuit
    cmp r9d, r12d
    je .igualID
    mov rax, [rbx + PUBLICACION_NEXT_OFFSET]
    cmp rax, 0
    je .sig0
    mov [rbx + PUBLICACION_NEXT_OFFSET], rax;copiar la sig
    mov rbx, [rbx + PUBLICACION_NEXT_OFFSET] ;voy al sig
    jmp .c2

    .igualID:
    mov rdi, [rbx + PUBLICACION_NEXT_OFFSET] ;la que tenog que borrar
    cmp rdi, 0
    je .sig0
    mov rax, [rdi + PUBLICACION_NEXT_OFFSET] ;la que tengo que seguir
    call free
    cmp rax, 0
    je .sig0
    mov [rbx + PUBLICACION_NEXT_OFFSET], rax ;copio la sig
    mov rbx, [rbx + PUBLICACION_NEXT_OFFSET]

    jmp .c2

    .sig0:
    mov qword[rbx + PUBLICACION_NEXT_OFFSET], 0

    .epilogo:
    pop r12
    pop rbx
    pop rbp

