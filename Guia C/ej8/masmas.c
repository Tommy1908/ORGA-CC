#include<stdio.h>

int main(){

    int a = 0;
    int b = 0;

    printf("Antes de aplicar a++, a:%d \n",a);
    printf("Ahora aplico a++, devuelve: %d \n", a++);
    printf("Luego a vale %d \n", a);
    
    printf("Antes de aplicar ++b, b:%d \n",b);
    printf("Ahora aplico ++b, devuelve: %d \n", ++b);
    printf("Luego b vale %d \n", b);
    

    return 0;
}