#include <stdio.h>

int main(){
    char *str1 = "Hola";
    char str2[] = "Hola";
    printf("%s\n", str1);
    printf("%s\n", str2);

    //*(str1 + 1) = 'a';
    str2[0] = 'a';

    printf("%s\n", str1);
    printf("%s\n", str2);

    return 0;
}