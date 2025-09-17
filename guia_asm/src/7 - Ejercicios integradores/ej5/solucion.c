#include <stdlib.h>
#include <string.h>

#include "ejercicio.h"

/**
 * Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - hay_accion_que_toque
 */
bool EJERCICIO_1_HECHO = true;

/**
 * Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - invocar_acciones
 */
bool EJERCICIO_2_HECHO = true;

/**
 * Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contar_cartas
 */
bool EJERCICIO_3_HECHO = true;

/**
 * Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
 * nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
 * parámetro.
 *
 * El resultado es un valor booleano, la representación de los booleanos de C es
 * la siguiente:
 *   - El valor `0` es `false`
 *   - Cualquier otro valor es `true`
 */
bool hay_accion_que_toque(accion_t* accion, char* nombre) {
	if(accion == 0){
		return false;
	}
	if(strncmp(accion->destino->nombre, nombre, 12) == 0){
		return true;
	}
	accion_t* sig = accion->siguiente;
	if(sig == 0){
		return false;
	}
	return hay_accion_que_toque(sig, nombre);
}

/**
 * Invoca las acciones que fueron encoladas en la secuencia proporcionada en el
 * primer parámetro.
 *
 * A la hora de procesar una acción esta sólo se invoca si la carta destino
 * sigue en juego.
 *
 * Luego de invocar una acción, si la carta destino tiene cero puntos de vida,
 * se debe marcar ésta como fuera de juego.
 *
 * Las funciones que implementan acciones de juego tienen la siguiente firma:
 * ```c
 * void mi_accion(tablero_t* tablero, carta_t* carta);
 * ```
 * - El tablero a utilizar es el pasado como parámetro
 * - La carta a utilizar es la carta destino de la acción (`accion->destino`)
 *
 * Las acciones se deben invocar en el orden natural de la secuencia (primero
 * la primera acción, segundo la segunda acción, etc). Las acciones asumen este
 * orden de ejecución.
 */
void invocar_acciones(accion_t* accion, tablero_t* tablero) {

	if(accion == 0){
		return;
	}

	if(accion->destino->en_juego == 1){
		accion->invocar(tablero, accion->destino);

		if(accion->destino->vida <= 0){
			accion->destino->en_juego = 0;
		}
	}

	invocar_acciones(accion->siguiente, tablero);
	return;
}

/**
 * Cuenta la cantidad de cartas rojas y azules en el tablero.
 *
 * Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
 * correspondientes al jugador rojo y al jugador azul. Este conteo incluye
 * tanto a las cartas en juego cómo a las fuera de juego (siempre que estén
 * visibles en el campo).
 *
 * Se debe considerar el caso de que el campo contenga cartas que no pertenecen
 * a ninguno de los dos jugadores.
 *
 * Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
 * una carta.
 *
 * El resultado debe ser escrito en las posiciones de memoria proporcionadas
 * como parámetro.
 */
void contar_cartas(tablero_t* tablero, uint32_t* cant_rojas, uint32_t* cant_azules) {
	*cant_rojas = *cant_azules = 0;

	for(uint16_t i = 0; i < ALTO_CAMPO; i++){
		for(uint16_t j = 0; j < ANCHO_CAMPO; j++){
			if(tablero->campo[i][j] != 0){
				uint8_t jugador = tablero->campo[i][j]->jugador;
				if(jugador == JUGADOR_ROJO){
					*cant_rojas = *cant_rojas + 1;
				}
				else if(jugador == JUGADOR_AZUL){
					*cant_azules = *cant_azules + 1;
				}
			}
		}
	}
	return;
}
