#include <stdio.h>
#include <stdint.h>  
#include <stdlib.h>
#include <string.h>

#define NAME_LEN 50

typedef struct{
	char name[NAME_LEN];
	uint8_t edad;
}persona_t;

persona_t* crearPersona(char *str, int edad);
void eliminarPersona(persona_t* persona);

int main(void){
	persona_t *puntero = crearPersona("Tomas", 21);
	printf("Esta persona se llama %s y tiene %d años\n", puntero->name, puntero->edad); // es igual a (*p).name y (*p).edad
	eliminarPersona(puntero);
	return 0;
}

persona_t* crearPersona(char *str, int edad){
	persona_t *persona = malloc(sizeof(persona_t)); //ya inclute padding/alineamiento
	if (!persona) return NULL;

	//si fuera de mas de 50 usando strcpy, se usa este para que corte la copia si es mas largo
	strncpy(persona->name, str, NAME_LEN-1);
	persona->name[NAME_LEN-1] = '\0'; // poner el ultimo bit en el nulo
	persona->edad = edad;  //es lo mismo que (*persona).edad = edad
	return persona;
}

void eliminarPersona(persona_t* persona){
	free(persona);
}