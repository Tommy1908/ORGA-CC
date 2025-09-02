#include <stdio.h>
#include <string.h>


int main(void){
    
    char s1[] = "Hola mundo";
    char s2[] = "Soy una cadena que ocupa ";
    char dest[50];

    strcpy(dest, s1);  // copia src en dest
    strcpy(dest, s2);  // copia src en dest
    printf("dest: %s %zu\n", dest,sizeof(dest));


    char str1[50] = "Hola ";
    char str2[] = "mundo";

    strcat(str1, str2);  // concatena str2 al final de str1
    printf("Concat: %s\n", str1);

    char str[] = "Hola mundo";
    printf("Len: %zu, %zu\n", strlen(str),sizeof(str));
    //strlen ignora el caracter \0 del final del string, sizeof lo cuenta porque cuenta bytes
    return 0;
}

// Restrict le garantiza al compilador que los 2 punteros no se solaparan en memoria. Permite optimizar mejor el codigo porque no se pueden afectar el uno al otro