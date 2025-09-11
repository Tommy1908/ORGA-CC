#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_4_using_c(536, 906, 697, 260) == 67);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 10);

	assert(alternate_sum_8(5, 3, 1, 9, 20, 1, 5, 8) == 10);

	assert(alternate_sum_8(-5, 6, 1, 9, -20, 1, 5, 8) == -43);

	uint32_t *ptr = (uint32_t *) malloc(3 * sizeof(uint32_t));

	product_2_f(ptr,2, 2.5);
	assert(ptr[0]== 5);
	product_2_f(ptr + 1, 19, 7.562);
	assert(ptr[1]== 143);
	product_2_f(ptr + 2, 460, 846.24);
	assert(ptr[2]== 389270);

	double *dptr = (double *) malloc(2 * sizeof(double));
	product_9_f(dptr, 2, 2.5, 5, 0.5, 1, 3.5568, 678, 3.62, 1, 1.0, 1, 1.0, 2, 2.1, 6, 7.7, 1, 3.0);
	printf("%f",dptr[0]);
	//assert(dptr[0] == 63521418.185045);
	
	return 0;
}