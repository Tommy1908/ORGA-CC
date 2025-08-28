#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 6

int main() 
{
    srand(time(NULL));
    int random_variable = rand();
    printf("Random value on [0,%d]: %d\n", RAND_MAX, random_variable);
 
    int tiradas = 60000000;
    int bucket[N] = {0}; //inician todos en 0


    // roll a N-sided die 20 times
    for (int n=0; n != tiradas; ++n) {
        int x = N+1;
        while(x > N) 
            x = 1 + rand()/((RAND_MAX + 1u)/N); // Note: 1+rand()%6 is biased
        printf("%d ",  x);
        bucket[x-1]++; 
    }

    printf("\n");
    for(int i = 0; i < N ; i++){
        printf("%d ",bucket[i]);
    }
    printf("\n");
    printf("Razon de \n");
    double suma = 0;
    for(int i = 0; i < N ; i++){
        printf("%f ",(double) bucket[i]/tiradas);
        suma += (double) bucket[i]/tiradas;
    }
    printf("\n%f\n",suma);

    return 0;
}
