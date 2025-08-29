#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// se me hizo terrible lio meter el imput, creo q esperaban otra cosa xq no lo habian mostrado

int main(int argc, char *argv[]) 
{
    printf("%d\n",argc);
    int n = atoi(argv[1]);
    printf("%d\n",n);

    uint32_t l[] = {1,2,3,4};

    size_t len = sizeof(l) / sizeof(l[0]);
    uint32_t copy[len];
    for(size_t i = 0; i < len; i++){
        copy[i] = l[i];
    } 

    for(int i = 0; i < 4 ; i++){
        printf("%d",copy[i]);
    }
    printf("\n");


    for(size_t j = 0; j<len; j++){
        l[(j+n)%len] = copy[j];
    }


    for(int i = 0; i < 4 ; i++){
        printf("%d",l[i]);
    }
    printf("\n");

    return 0;
}
