#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {

	if(tamanio <= 1){
		return true;
	}

	item_t* a = inventario[indice[0]];
	item_t* b;

	for(uint16_t i = 1; i < tamanio; i++){
		
		b = inventario[indice[i]]; //puntero a item en la iesima pos del array
		if(!(comparador(a,b))){
			return false;
		}
		a = b;
	}

	return true;
}

/**
 * OPCIONAL: implementar en C
 */
//item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	// ¿Cuánta memoria hay que pedir para el resultado?
	item_t** resultado;
	resultado = (item_t**) malloc(sizeof(item_t) * tamanio);

	for(uint16_t i = 0; i < tamanio; i++){
		resultado[i] = inventario[indice[i]];
	}

	return resultado;
}
