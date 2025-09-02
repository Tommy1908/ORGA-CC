#include <stdio.h>
#include <stdint.h>

int main(){
    uint8_t memoria[9] = {255, 31, 42, 0 ,55, 67, -128, 127, 99};
    uint8_t *x = (uint8_t*) &memoria[0];
    int8_t *y = &memoria[6];

    printf("Dir de x: %p Valor: %d\n", (void*) x, *x);
    printf("Dir de y: %p Valor: %d\n", (void*) y, *y);

    return 0;
}
//El valor era 255 pero con int8_t imposible, tendria que ser uint aunque ponga negativos lo leo como int en ese especifico