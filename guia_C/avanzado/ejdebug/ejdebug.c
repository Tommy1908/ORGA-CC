#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef enum{
    MENTA,
    DDL,
    OREO,
    LIMON
} gustoDeHelado_t;

typedef enum{
    ABIERTO,
    CERRADO
} estadoDelLocal;

char* gustosDeHelado[4]= {"MENTA", "DDL", "OREO", "LIMON"};

typedef struct{
    uint32_t precio;
    gustoDeHelado_t gusto;
} helado_t;

helado_t heladoDDL = {.precio = 5, .gusto = DDL};

typedef struct{
    char nombre[5];
    uint8_t habilitado; // bool
    int saldo;
    int gustoDeHeladoFavorito;
} usuario_t;

void habilitarUsuario(usuario_t *usuario){
    usuario->habilitado = 1;
    for(int i = 0; i < 5; i++){
        usuario->nombre[i] = '\0';
    }
    usuario->saldo = 0;
}

void aumentarSaldo(usuario_t *usuario, int cantidad){
    usuario->saldo += cantidad;
}

void comprarHelado(usuario_t *usuario, helado_t* *helado){
    if(usuario->saldo >= 5){
        usuario->saldo -= 5;
        *helado = &heladoDDL;
        printf("Helado comprado con exito\n");
    }else{
        printf("El usuario no tiene saldo suficiente\n");
    }
}

int main(void){
    usuario_t *nuevoUsuario = malloc(sizeof(usuario_t));
    habilitarUsuario(nuevoUsuario);
    estadoDelLocal local_abierto = ABIERTO;
    if(local_abierto == ABIERTO){
        if(nuevoUsuario->habilitado){
            printf("Usuario habilitado con éxito!\n");
            aumentarSaldo(nuevoUsuario, 10);

            helado_t* helado = NULL;
            comprarHelado(nuevoUsuario, &helado);
            nuevoUsuario->gustoDeHeladoFavorito = helado->gusto;

            printf("Usuario creado con éxito. \n");
            printf("Su saldo es de %d pesos y su gusto favorito es %s.\n",
            nuevoUsuario->saldo,
            gustosDeHelado[nuevoUsuario->gustoDeHeladoFavorito]
            );
        } else{
            printf("Error al habilitar usuario %d\n", nuevoUsuario->habilitado);
        }
    }
    free(nuevoUsuario);
    return 0;
}
