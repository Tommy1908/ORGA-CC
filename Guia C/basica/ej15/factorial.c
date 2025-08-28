#include <stdio.h>

unsigned long long factorial_recursivo(int n);
unsigned long long factorial_iterativo(int n);

int main(void){

    int n;
	printf("Ingrese un numero: ");
	scanf("%d", &n);   // se usa para leer un número del teclado

    unsigned long long r1,r2;
    r1 = factorial_recursivo(n);
    r2 = factorial_iterativo(n);

    if(r1 == r2){
        printf("Factorial de %d es %llu\n",n,r1);
    }else{
        printf("Error, no dieron igual\n");
        printf("R:%llu I:%llu\n",r1, r2);
    }
    return 0;
}

unsigned long long factorial_recursivo(int n){
    if(n < 0){
        printf("No definido para numeros negativos. Indefinido\n");
        return -1;
    }
    else if(n == 0){
        return 1;
    }
    else{
        return n * factorial_recursivo(n-1);
    }
}

unsigned long long factorial_iterativo(int n){
    if(n < 0){
        printf("No definido para numeros negativos. Indefinido\n");
        return -1;
    }
    else if(n == 0){
        return 1;
    }
    else{
        unsigned long long acum = 1;
        for(int i = 2; i <= n; i++){
            acum *= i;
        }
        return acum;
    }
}