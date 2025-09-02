#include <stdio.h>

#define NAME_LEN 50

typedef struct{
    char name[50];
    int vida;
    double ataque;
    double defensa;
} monstruo_t;

monstruo_t evolution(monstruo_t monstruo);

int main(void){

    monstruo_t monstruos[5] = {
        {"Chirko", 150, 0.5, 3},
        {"Golem", 100, 3, 1.5},
        {"Goblin", 30, 1.5, 0.5},
        {"Bruja", 70, 3.5, 1}
        //En teoria habria 1 mas vacio porque puse 5 y defini 4
    };

    printf("Tamaño de cada monstruo %zu \n",sizeof(monstruos[0]));
    size_t len = (sizeof(monstruos) / sizeof(monstruos[0]));
    printf("%zu \n",len);

    for(size_t i = 0; i < len; i++){
        printf("%s tiene %d vida, %f de ataque y %f de defensa\n",monstruos[i].name,monstruos[i].vida,monstruos[i].ataque,monstruos[i].defensa);
    }

    monstruo_t chirko = monstruos[0];
    printf("\n %s tiene %d vida, %f de ataque y %f de defensa\n", chirko.name, chirko.vida, chirko.ataque, chirko.defensa);
    printf("Oh no chirko salvaje esta evolucionado!!\n");
    chirko = evolution(chirko);
    printf("%s tiene %d vida, %f de ataque y %f de defensa\n", chirko.name, chirko.vida, chirko.ataque, chirko.defensa);

    return 0;
}


monstruo_t evolution(monstruo_t monstruo){
    monstruo.ataque += 10;
    monstruo.defensa += 10;
    return monstruo;
}