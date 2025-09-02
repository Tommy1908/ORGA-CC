#include <stdio.h>
#include <stdint.h>  
#include <stdlib.h>
#define N 10


uint16_t *secuencia(uint16_t n){
	uint16_t *arr = malloc(n * sizeof(uint16_t));
	if (arr == NULL) {
	// Manejar el error de asignación de memoria
	return NULL;
	}
	for(uint16_t i = 0; i < n; i++)
		arr[i] = i;
	return arr;
}

int main(){
	uint16_t *arr = secuencia(N);
	if (arr == NULL) {
	// Manejar el error de asignación de memoria
	return 1;
	}
	for(uint16_t i = 0; i < N; i++)
		printf("%d\n", arr[i]);
	free(arr); // Liberar la memoria reservada
	return 0;
}