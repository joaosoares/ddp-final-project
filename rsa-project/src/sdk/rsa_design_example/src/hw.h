#ifndef _HW_H_
#define _HW_H_

#include <stdint.h>

// Calculates 512-bit montgomery multiplication in hardware
void HW_MontMult512(uint32_t *a, uint32_t *b, uint32_t *m, uint32_t *res);

// Calculates 512-bit montgomery exponentiation in hardware
void HW_MontExp512(uint32_t *x, uint32_t *e, uint32_t *m, uint32_t *r2modm, uint32_t *rmodm, uint32_t *res);

#endif
