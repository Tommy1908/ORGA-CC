#include <stdio.h>
#include <stdint.h>

int main()
{

    uint8_t l[] = {1,2,3,4};

    for(int i = 0; i < 4 ; i++){
        printf("%d",l[i]);
    }
    printf("\n");

    uint8_t a = l[0];
    l[0] = l[3];
    l[3] = a;

    for(int i = 0; i < 4 ; i++){
        printf("%d",l[i]);
    }
    printf("\n");

    return 0;
}
