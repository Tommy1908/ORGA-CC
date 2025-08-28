
int b, c;  // Globales → duración estática (sin aclarar static), scope global (visibles en todo el archivo, y en otros tambien xque no son static)

void f(void)
{
int b, d; // Locales a f → duración automática, block scope
}

void g(int a)
{
int c; // Local a g → duración automática, scope de g
	{
	int a, d; // Locales a este bloque → duración automática, scope solo dentro de estas llaves
	//aca c no es accesible
	}
}

