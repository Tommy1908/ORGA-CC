#include "ej4b.h"

#include <string.h>

// OPCIONAL: implementar en C
void invocar_habilidad(void* carta_generica, char* habilidad) {
	card_t* carta = carta_generica;

	for(uint16_t i = 0; i < carta->__dir_entries; i++){
		if(strcmp(carta->__dir[i]->ability_name, habilidad) == 0){
			void (*func) (void* carta) = carta->__dir[i]->ability_ptr;
			func(carta);
			return;
		}
	}
	if(carta->__archetype == 0){ //Null
		return;
	}
	card_t* carta_de_archetype = carta->__archetype;
	for(uint16_t i = 0; i < carta_de_archetype->__dir_entries; i++){
		if(strcmp(carta_de_archetype->__dir[i]->ability_name, habilidad)  == 0){
			void (*func) (void* carta) = carta_de_archetype->__dir[i]->ability_ptr;
			func(carta_de_archetype);
			return;
		}
	}
	invocar_habilidad(carta_de_archetype, habilidad);
	return;
}
