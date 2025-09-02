#include <stdio.h>

int main(){
    int x = 42;
    int *p = &x;
    
    printf("Direccion de x: %p Valor: %d\n", (void*) &x, x);
    printf("Direccion de p: %p Valor: %p\n", (void*) &p, (void*) p);
    printf("Valor de lo que apunta p: %d\n", *p);
}

// %p espera void*, por eso se hace el casteo.