#include <stdio.h>
#define FELIZ 0
#define TRISTE 1

void ser_feliz(void);
void print_estado(int estado);

int main(){
    int estado = TRISTE; // automatic duration. Block scope
    ser_feliz();
    print_estado(estado); // qué imprime?
    // Imprime triste porque el cambio de estado se hace local
}

void ser_feliz(void){
    estado = FELIZ;
}

void print_estado(int estado){
    printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");   //"operador ternario" se cumple devuleve la primera sino la seg
}