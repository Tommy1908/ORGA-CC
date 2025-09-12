//*************************************
// Declaración de estructuras
//*************************************

typedef struct item_s
{
	char nombre[9];	   // asmdef_offset: 0-8
	uint32_t id;	   // asmdef_offset: 10-13
	uint32_t cantidad; // asmdef_offset: 14-17
} item_t;

// a b
// c d
// e f
// g h
// i _
// 1 1
// 1 1
// 2 2
// 2 2