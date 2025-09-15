#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - optimizar
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t *compartida, uint32_t (*fun_hash)(attackunit_t *))
{
    //[row][columns]
    uint8_t fila, columna;
    fila = 255;
    columna = 255;

    uint32_t hashCompartida, hashIJ;
    attackunit_t *unitIJ;
    hashCompartida = fun_hash(compartida);

    for (uint8_t i = 0; i < fila; i++)
    {
        for (uint8_t j = 0; j < columna; j++)
        {

            unitIJ = mapa[i][j];

            if (unitIJ == compartida || unitIJ == 0)
            { // aparentemente puede haber nulls
                continue;
            }

            hashIJ = fun_hash(unitIJ);

            if (hashCompartida == hashIJ)
            {
                mapa[i][j] = compartida;
                compartida->references++;
                if (unitIJ->references == 1)
                {
                    free(unitIJ);
                }
                else
                {
                    unitIJ->references--;
                }
            }
        }
    }
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char *))
{
    uint8_t fila, columna;
    fila = 255;
    columna = 255;
    uint32_t total = 0;

    for (uint8_t i = 0; i < fila; i++)
    {
        for (uint8_t j = 0; j < columna; j++)
        {
            attackunit_t *au = mapa[i][j];
            if (au == 0)
            {
                continue;
            }
            char *clase = au->clase;
            uint16_t combustible_base = fun_combustible(clase);
            uint16_t combustible_total = au->combustible;
            total += combustible_total - combustible_base;
        }
    }
    return total;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t *))
{

    attackunit_t *au = mapa[x][y];
    if (au == 0)
    {
        return;
    }
    if (au->references == 1)
    {
        fun_modificar(au);
        return;
    }

    au->references--;

    attackunit_t *mod_au = (attackunit_t *)malloc(sizeof(attackunit_t));
    mod_au->combustible = au->combustible;
    mod_au->references = 1;
    strncpy(mod_au->clase, au->clase, 11);
    // mod_au->clase = au->clase; esto no anda porque es un array no un puntero

    mapa[x][y] = mod_au;

    fun_modificar(mod_au);

    return;
}
