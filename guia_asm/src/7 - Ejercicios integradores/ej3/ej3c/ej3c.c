#include "../ejs.h"

estadisticas_t *calcular_estadisticas(caso_t *arreglo_casos, int largo, uint32_t usuario_id)
{
    estadisticas_t *estadisticas = malloc(sizeof(estadisticas_t));
    estadisticas->cantidad_estado_0 = 0;
    estadisticas->cantidad_estado_1 = 0;
    estadisticas->cantidad_estado_2 = 0;
    estadisticas->cantidad_CLT = 0;
    estadisticas->cantidad_RBO = 0;
    estadisticas->cantidad_KSC = 0;
    estadisticas->cantidad_KDT = 0;

    for (int i = 0; i < largo; i++)
    {
        if (usuario_id == 0)
        { // Se cuenta todo
            char *cat = &arreglo_casos[i].categoria;
            if (strncmp(cat, "CLT", 3) == 0)
            {
                estadisticas->cantidad_CLT++;
            }
            else if (strncmp(cat, "RBO", 3) == 0)
            {
                estadisticas->cantidad_RBO++;
            }
            else if (strncmp(cat, "KSC", 3) == 0)
            {
                estadisticas->cantidad_KSC++;
            }
            else if (strncmp(cat, "KDT", 3) == 0)
            {
                estadisticas->cantidad_KDT++;
            }
            uint16_t estado = arreglo_casos[i].estado;
            switch (estado)
            {
            case 0:
                estadisticas->cantidad_estado_0++;
                break;
            case 1:
                estadisticas->cantidad_estado_1++;
                break;
            case 2:
                estadisticas->cantidad_estado_2++;
                break;

            default:
                break;
            }
        }
        else
        {
            if (arreglo_casos[i].usuario->id == usuario_id)
            {
                char *cat = &arreglo_casos[i].categoria;
                if (strncmp(cat, "CLT", 3) == 0)
                {
                    estadisticas->cantidad_CLT++;
                }
                else if (strncmp(cat, "RBO", 3) == 0)
                {
                    estadisticas->cantidad_RBO++;
                }
                else if (strncmp(cat, "KSC", 3) == 0)
                {
                    estadisticas->cantidad_KSC++;
                }
                else if (strncmp(cat, "KDT", 3) == 0)
                {
                    estadisticas->cantidad_KDT++;
                }
                uint16_t estado = arreglo_casos[i].estado;
                switch (estado)
                {
                case 0:
                    estadisticas->cantidad_estado_0++;
                    break;
                case 1:
                    estadisticas->cantidad_estado_1++;
                    break;
                case 2:
                    estadisticas->cantidad_estado_2++;
                    break;

                default:
                    break;
                }
            }
        }
    }
    return estadisticas;
}

// typedef struct {
//	uint8_t cantidad_CLT;
//	uint8_t cantidad_RBO;
//	uint8_t cantidad_KSC;
//	uint8_t cantidad_KDT;
//	uint8_t cantidad_estado_0;
//	uint8_t cantidad_estado_1;
//	uint8_t cantidad_estado_2;
// } estadisticas_t;