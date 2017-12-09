#include <stdint.h>

#ifdef __APPLE__
#include "../test/mock_xil_printf.h"
#else
#include "xil_printf.h"
#endif

#define SIZE 32

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
	for(i = 0; i < 32; i++)
	  A[i] = R_1024[i];

	while(exp_len>=0)
	{
		exp_len--;

		bit = (exp[exp_len/32] >> (exp_len%32)) & 1;

		xil_printf("Bit[%d] of exponent is: %d\n\r", exp_len, bit);

		// Calculate A = MontMul(A, A)
		montgomery_multiply(A, A, n, n_prime, A, SIZE);

		if(bit)
		{
			// Calculate A = MontMul(A, x_tilde)
			montgomery_multiply(A, x_tilde, n, n_prime, A, SIZE);
		}
	}

	// Calculate A = MontMul(A, 1)
	//   One is defined in global.h
	montgomery_multiply(A, One, n, n_prime, A, SIZE);
}

// Calculates res = (a * b / R) mod N where R = 2^1024
void montgomery_multiply(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *n_prime, uint32_t *res, uint32_t size)
{

}

// Calculates res = (a + b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_add(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *res, uint32_t size)
{
  mp_add(a, b, res, size); // res length is size+1 
    
  // Pad N with an extra 0 on front
  uint32_t paddedN[size+1];
  int i;
  for(i = 0; i < size; i++) paddedN[i] = N[i]; paddedN[size] = 0;
  
  mod(res, N, size);
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
  uint32_t c = 0;
  uint32_t i = 0;
  uint64_t single_result;
  for (i = 0; i < size; i++)
  {
    single_result = (uint64_t) a[i] + b[i] + c;
    res[i] = (uint32_t) single_result;
    c = (uint32_t) (single_result >> 32);
  }
  res[size] = c;
}

// Calculates res = a - b.
// a and b represent large integers stored in uint32_t arrays
// a, b and res are arrays of size elements
void mp_sub(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{
  uint32_t c = 0;
  uint32_t i;
  uint64_t single_result;
  for (i = 0; i < size; i++)
  {
    single_result = (uint64_t) a[i] - b[i] + c;
    res[i] = (uint32_t) single_result;
    c = (uint32_t) (single_result >> 32);
    if ( (b[i] + c) > a[i]) {
      c = -1;
    } else {
      c = 0;
    }
    // printf("\t\n%08x", c);    
  }
}


// Multiple precision greater than or equal
// Returns true if a is greater than or equal to b.
int mp_gte(uint32_t *a, uint32_t *b, uint32_t size)
{
  int i;
  for (i = size - 1; i >= 0; i--)
  {
    if (a[i] > b[i])
    {
      return 1;
    } else if (b[i] > a[i]) {
      return 0;
    }
  }
  // This means they're completely the same
  return 1;
}


// Calculates (a mod N) where a and N are 2 multiprecision numbers.
// Modifies input array a.
// Ex:
// uint32_t a[2] = {0x00000002, 0x00000000}
// uint32_t N[2] = {0x00000003, 0x00000000}
// mod(a, N, 2) -> a = {0x00000001, 0x00000000}
void mod(uint32_t *a, uint32_t *N, uint32_t size) {
  while (mp_gte(a, N, size)) {
    mp_sub(a, N, a, size);
  }
}