#include <stdio.h>

int global = 3;

int main() 
{
    int local_basura;
    

    printf("Global: %d, local: %d\n", global, local_basura);

    int global = 4;

    printf("Global: %d, local: %d\n", global, local_basura);

    return 0;
}
