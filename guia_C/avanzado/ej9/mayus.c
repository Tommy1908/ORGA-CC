#include <stdio.h>

void mayus(char* str);

int main(){
    
    char str[] = "Hola MuNdO!! :D";

    printf("%s\n",str);
    mayus(str);
    printf("%s\n",str);

    return 0;
}

void mayus(char* str){

    const char MIN = 97;
    const char MAX = 122;
    const char DIFF = 'A' - 'a';
    
    for (int i = 0; str[i] != '\0'; i++) {
        if(MIN <= *(str+i) && *(str+i) <= MAX){                          //str[i]
            *(str+i) += DIFF;
        }
    }
}