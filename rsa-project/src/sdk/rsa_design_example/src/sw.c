#include <stdint.h>

#include "xil_printf.h"

#include "sw.h"

// These variables are defined and assigned in testvector.c
extern uint32_t M[32],
                N[32],       N_prime[32],
                e[32],
                e_len,
                p[16],       q[16],
                d_p[16],     d_q[16],
                d_p_len[16], d_q_len[16],
                x_p[32],     x_q[32],
                R2p[16],     R2q[16],
                R_1024[32],  R2_1024[32],
                One[32];


// Calculates res = (x^exp) mod N
void mod_exp(uint32_t *x, uint32_t *exp, uint32_t exp_len, uint32_t *n, uint32_t *n_prime, uint32_t *res)
{
	int i;
	int bit;

	uint32_t x_tilde[32], A[32];

	// Calculate x_tilde = MontMul(x, R^2 mod m)
	//   R2_1024 is defined in global.h
	// montgomery_multiply(msg, R2_1024, n, n_prime, x_tilde, SIZE);

	// Copy R to A
	//   R_1024 is defined in global.h
	// for(i = 0; i < 32; i++)
	//   A[i] = R_1024[i];

	while(exp_len>=0)
	{
		exp_len--;

		bit = (exp[exp_len/32] >> (exp_len%32)) & 1;

		xil_printf("Bit[%d] of exponent is: %d\n\r", exp_len, bit);

		// Calculate A = MontMul(A, A)
		// montgomery_multiply(A, A, n, n_prime, A, SIZE);

		if(bit)
		{
			// Calculate A = MontMul(A, x_tilde)
			// montgomery_multiply(A, x_tilde, n, n_prime, A, SIZE);
		}
	}

	// Calculate A = MontMul(A, 1)
	//   One is defined in global.h
	// montgomery_multiply(A, One, n, n_prime, A, SIZE);
}

// Calculates res = (a * b / R) mod N where R = 2^1024
void montgomery_multiply(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res, uint32_t size)
{

}

// Calculates res = (a + b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_add(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *res, uint32_t size)
{

}

// Calculates res = (a - b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_sub(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *res, uint32_t size)
{

}

// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{

}

// Calculates res = a - b.
// a and b represent large integers stored in uint32_t arrays
// a, b and res are arrays of size elements
void mp_sub(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{

}
