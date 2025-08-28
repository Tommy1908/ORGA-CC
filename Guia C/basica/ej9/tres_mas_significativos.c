#include <stdio.h>
#include <stdint.h>

int main()
{

    int32_t a,b,c,d,mask;

    a = 0xB15B; //101
    b = 0xA62C; //101
    c = 0x67AA; //011
    d = 0x6100; //011
    mask=0xE000; //1110

    printf("Comparacion de %X con %X -> %X y %X por lo tanto: %d \n", a, b, a & mask, b & mask, (a & mask) == (b & mask));
    printf("Comparacion de %X con %X -> %X y %X por lo tanto: %d \n", c, d, c & mask, d & mask, (c & mask) == (d & mask));
    printf("Comparacion de %X con %X -> %X y %X por lo tanto: %d \n", a, c, a & mask, c & mask, (a & mask) == (c & mask));
    printf("Comparacion de %X con %X -> %X y %X por lo tanto: %d \n", b, d, b & mask, d & mask, (b & mask) == (d & mask));

    return 0;
}
