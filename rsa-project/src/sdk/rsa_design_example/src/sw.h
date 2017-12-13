#ifndef _SW_H_
#define _SW_H_

#include <stdint.h>

// Calculates res = (message^exponent) mod N
void SW_MontExp1024(uint32_t *x, uint32_t *exp, uint32_t exp_len, uint32_t *n,
             uint32_t *n_prime, uint32_t *r2m, uint32_t *rm, uint32_t *res, uint32_t size);

// Calculates res = (a * b / R) mod N where R = 2^1024
void SW_MontMult1024(uint32_t *a, uint32_t *b, uint32_t *n,
                         uint32_t *n_prime, uint32_t *res, uint32_t size);

#endif
