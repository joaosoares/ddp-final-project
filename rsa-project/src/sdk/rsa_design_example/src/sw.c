#include <stdint.h>
#include "xil_printf.h"
#include "testvector.h"

#include "sw.h"
#include "mp_arith.h"
#include "mp_print.h"
// #include "asm_func.h"

// #define SIZE 32

void sub_cond(uint32_t *u, uint32_t *n, uint32_t size);


/* Carry addition algorithm
 *
 */
void add_carry(uint32_t *t, uint32_t i, uint32_t c) {
  while (c != 0) {
    uint64_t sum = (uint64_t) t[i] + (uint64_t) c;
    uint32_t S = (uint32_t)sum;
    c = (uint32_t)(sum >> 32);
    t[i] = S;
    i++;
  }
}


// Calculates res = (x^exp) mod N
void SW_MontExp1024(uint32_t *x, uint32_t *exp, uint32_t exp_len, uint32_t *n,
             uint32_t *n_prime, uint32_t *r2m, uint32_t *rm, uint32_t *res, uint32_t size)
{
	int i;
	int bit;

	uint32_t x_tilde[size], A[size];
	// Calculate x_tilde = MontMul(x, R^2 mod m)
	SW_MontMult1024(x, r2m, n, n_prime, x_tilde, size);
	// Copy R to A
	for(i = 0; i < 32; i++)
	  A[i] = rm[i];

	int j;
	for (j = exp_len-1; j >= 0; j--) {
		// See if current exp bit is 0 or 1
		bit = (exp[j/32] >> (j%32)) & 1;
		xil_printf("-- Iteration %d\n\r", j);
    xil_printf("@ A before -- %d : ", i);
    mp_print(A, "", 32);
		// Calculate A = MontMul(A, A)
		SW_MontMult1024(A, A, n, n_prime, A, size);
    xil_printf("@ A* A -- %d : ", i);
    mp_print(A, "", 32);
		// Do the next multiplication if bit is 1
		if(bit) {
			// Calculate A = MontMul(A, x_tilde)
			SW_MontMult1024(A, x_tilde, n, n_prime, A, size);
      xil_printf("@ xtilde * A -- %d : ", i);
      mp_print(A, "", 32);
		}
	}
	// Calculate A = MontMul(A, 1)
	SW_MontMult1024(A, One, n, n_prime, res, size);
}

void SW_MontMult1024(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res,
          uint32_t size) {
  uint32_t t[size + 2];
  int i;
  for (i = 0; i < size + 2; i++) {
    t[i] = 0;
  }

  uint64_t sum;
  uint32_t m, S, C;

  for (i = 0; i < size; i++) {
    sum = (uint64_t)t[0] + (uint64_t)a[0] * (uint64_t)b[i];
    S = (uint32_t)sum;
    C = (uint32_t)(sum >> 32);
    add_carry(t, 1, C);
    m = (uint64_t)S * (uint64_t)n_prime[0];
    sum = (uint64_t)S + (uint64_t)m * (uint64_t)n[0];
    S = (uint32_t)sum;
    C = (uint32_t)(sum >> 32);

    int j;
    for (j = 1; j < size; j++) {
      sum = (uint64_t)t[j] + (uint64_t)a[j] * (uint64_t)b[i] + (uint64_t)C;
      S = (uint32_t)sum;
      C = (uint32_t)(sum >> 32);
      add_carry(t, j + 1, C);
      sum = (uint64_t)S + (uint64_t)m * (uint64_t)n[j];
      S = (uint32_t)sum;
      C = (uint32_t)(sum >> 32);
      t[j - 1] = S;
    }
    
    sum = (uint64_t) t[size] + (uint64_t) C;
    S = (uint32_t)sum;
    C = (uint32_t)(sum >> 32);
    t[size - 1] = S;
    t[size] = t[size + 1] + C;
    t[size + 1] = 0;
  }
  sub_cond(t, n, size);
  for (i = 0; i < size; i++) {
    res[i] = t[i];
  }
}

/* Conditional subtraction algorithm
 */
void sub_cond(uint32_t *u, uint32_t *n, uint32_t size) {
  uint32_t b = 0;
  uint32_t t[size];
  int i;
  for (i = 0; i < size; i++) {
    uint32_t sub = u[i] - n[i] - b;
    if (u[i] >= n[i] + b) {
      b = 0;
    } else {
      b = 1;
    }
    t[i] = sub;
  }
  if (b == 0) {
    for (i = 0; i < size; i++) {
      u[i] = t[i];
    }
  }
}