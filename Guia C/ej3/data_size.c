#include<stdio.h>

int main(){

    char c = 84; //max 127
    unsigned char uc = 157; //mmax 255
    short s = 32767;
    unsigned short us = 65535;
    int i = 2147483647;
    unsigned u = 429496729;
    long l = 922337203685477580;
    unsigned long ul = 1844674407370955161;
    size_t st = 1234;

    printf("char(%lu): %d o %c \n", sizeof(c),c,c);
    printf("unsigned char(%lu): %d o %c \n", sizeof(uc),uc,uc);
    printf("short(%lu): %d \n", sizeof(s),s);
    printf("unsigned short(%lu): %d \n", sizeof(us),us);
    printf("int(%lu): %d \n", sizeof(i),i);
    printf("unsigned(%lu): %d \n", sizeof(u),u);
    printf("long(%lu): %ld \n", sizeof(l),l);
    printf("unsigned long(%lu): %ld \n", sizeof(ul),ul);
    printf("size_t(%zu): %zu \n", sizeof(st),st);

    return 0;
}