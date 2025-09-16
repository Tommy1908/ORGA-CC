#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej4a.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - init_fantastruco_dir
 */
bool EJERCICIO_1A_HECHO = true;

// OPCIONAL: implementar en C
void init_fantastruco_dir(fantastruco_t* card) {
    char * ability = "sleep";
    directory_entry_t* sleep_dir_entry = create_dir_entry(ability, sleep);

    ability = "wakeup";
    directory_entry_t* wakeup_dir_entry = create_dir_entry(ability, wakeup);

    directory_t directory = malloc(sizeof(directory_entry_t*)*2);
    directory[0] = sleep_dir_entry;
    directory[1] = wakeup_dir_entry;

    card->__dir = directory;
    card->__dir_entries = 2;

}

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - summon_fantastruco
 */
bool EJERCICIO_1B_HECHO = true;

// OPCIONAL: implementar en C
fantastruco_t* summon_fantastruco() {
    fantastruco_t* card = malloc(sizeof(fantastruco_t));
    card->face_up = 1;
    card->__archetype = NULL;
    init_fantastruco_dir(card);
    return card;
}
