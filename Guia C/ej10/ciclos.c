#include <stdio.h>
#include <stdint.h>

int main()
{

    printf("Con while\n");
    int i = 10;
    while(i--){
        printf("i = %d\n",i); // imprime o no el 0? Si
    }

    printf("Con for\n");
    for (int i = 9; i >= 0; i--) {
        printf("i = %d\n", i);
    }

    printf("1-10\n");
    //Este no lo pedia pero queda aca
    for (int i = 0; i < 10; i++) {
        printf("i = %d\n", i);
    }
    return 0;
}
