#include <stdint.h>
#include "mp_arith.h"

// Calculates res = (a + b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored
// in uint32_t arrays of size elements
void mod_add(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *res,
             uint32_t size) {
  mp_add(a, b, res, size);  // res length is size+1

  // Pad N with an extra 0 on front
  uint32_t paddedN[size + 1];
  int i;
  for (i = 0; i < size; i++) paddedN[i] = n[i];
  paddedN[size] = 0;
  mod(res, n, size);
}

// Calculates res = (a - b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored
// in uint32_t arrays of size elements
void mod_sub(uint32_t *a, uint32_t *b, uint32_t *n, uint32_t *res,
             uint32_t size) {
  int i;
  uint32_t tmp_res[size];
  if (mp_gte(a, b, size)) {
    mp_sub(a, b, res, size);
    mod(res, n, size);
  } else {
    mp_sub(b, a, res, size);
    mod(res, n, size);
    mp_sub(n, res, tmp_res, size);
    for (i = 0; i < size; i++) res[i] = tmp_res[i];
  }
}

// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size) {
  uint32_t c = 0;
  uint32_t i = 0;
  uint64_t single_result;
  for (i = 0; i < size; i++) {
    single_result = (uint64_t)a[i] + b[i] + c;
    res[i] = (uint32_t)single_result;
    c = (uint32_t)(single_result >> 32);
  }
  res[size] = c;
}

// Calculates res = a - b.
// a and b represent large integers stored in uint32_t arrays
// a, b and res are arrays of size elements
uint32_t mp_sub(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size) {
  uint32_t c = 0;
  uint32_t i;
  uint64_t single_result;
  for (i = 0; i < size; i++) {
    single_result = (uint64_t)a[i] - b[i] + c;
    res[i] = (uint32_t)single_result;
    c = (uint32_t)(single_result >> 32);
    if ((b[i] - c) > a[i]) {
      c = -1;
    } else {
      c = 0;
    }
  }
  return c;
}

// Multiple precision greater than or equal
// Returns true if a is greater than or equal to b.
int mp_gte(uint32_t *a, uint32_t *b, uint32_t size) {
  int i;
  for (i = size - 1; i >= 0; i--) {
    if (a[i] > b[i]) {
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
  uint32_t tmp_res[size];
  int i = 0;
  while (mp_gte(a, N, size)) {
    if (i > 100) break;
    mp_sub(a, N, tmp_res, size);
    for (i = 0; i < size; i++) {
      a[i] = tmp_res[i];
    }
    i++;
  }
}