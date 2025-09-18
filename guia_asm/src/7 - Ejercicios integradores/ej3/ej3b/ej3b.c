#include "../ejs.h"

void resolver_automaticamente(funcionCierraCasos_t* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo){

    int caso_a_revisar_n = 0;
    for(int i = 0; i < largo; i++){
        caso_t caso = arreglo_casos[i];

        usuario_t user = *(arreglo_casos[i].usuario);

        if(user.nivel == 0){
            casos_a_revisar[caso_a_revisar_n] = caso;
            caso_a_revisar_n++;
            continue;
        }
        else{ //en teoria solo seria 1 o 2 las otras opciones
            int res = funcion(&caso);
            if(res == 1){
                arreglo_casos[i].estado = 1;
                continue;
            }
            else{
                int r1 = strncmp(caso.categoria, "CLT",4); //por discord aclararon q el test no pasa sino
                int r2 = strncmp(caso.categoria, "RBO",4);
                if(r1 == 0 || r2 == 0){
                    arreglo_casos[i].estado = 2;
                    continue;
                    
                }
                else{
                    casos_a_revisar[caso_a_revisar_n] = caso;
                    caso_a_revisar_n++;
                }
            }
        }
    }

}

