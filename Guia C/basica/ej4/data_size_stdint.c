#include<stdio.h>
#include<stdint.h>

int main(){

    uint8_t ui8   = 19;
    int8_t i8   = -19;

    uint16_t ui16 = 300;
    int16_t i16 = -300;
    
    uint32_t ui32 = 30000;
    int32_t i32 = -30000;

    uint64_t ui64 = 30000000;
    int64_t i64 = -30000000;

    printf("uint8_t(%lu): %u \n", sizeof(ui8),ui8);
    printf("int8_t(%lu): %d \n", sizeof(i8),i8);

    printf("uint8_t(%lu): %u \n", sizeof(ui16),ui16);
    printf("int8_t(%lu): %d \n", sizeof(i16),i16);

    printf("uint8_t(%lu): %u \n", sizeof(ui32),ui32);
    printf("int8_t(%lu): %d \n", sizeof(i32),i32);

    printf("uint8_t(%lu): %lu \n", sizeof(ui64),ui64);
    printf("int8_t(%lu): %ld \n", sizeof(i64),i64);

    return 0;
}