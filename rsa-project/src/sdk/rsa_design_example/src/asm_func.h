// /*
//  * asm_func.h
//  *
//  *  Created on: May 13, 2016
//  *      Author: dbozilov
//  */

// #ifndef ASM_FUNC_H_
// #define ASM_FUNC_H_

// #include <stdint.h>
// // a will be in register R0, b in R1, c in R2
// // Result is stored in register r0
// uint32_t add_3(uint32_t a, uint32_t b, uint32_t c);
// //Adds all elements of array
// uint32_t add_10(uint32_t *a, uint32_t n);
// //Copies array a to array b
// uint32_t arr_copy(uint32_t *a, uint32_t *b, uint32_t n);

// // Function that calculates {t[i+1], t[i]} = a[0]*b[0] + m[0]*n[0]
// // i is in R0, pointer to t array in R1, a array in R2, b array in R3
// // pointer to m array is stored in [SP]
// // pointer to n array is stored in [SP, #4] (one position above m)
// void multiply(uint32_t i, uint32_t *t, uint32_t *a, uint32_t *b, uint32_t *m, uint32_t *n);

// /* Performs the operation
//  * (C, S) = A * B + D
//  * Inputs:
//  * A, B => 32 bit numbers to be multiplied
//  * D1, D2 => 32 bit numbers added to the result of the multiplication
//  *
//  * Returns
//  * S => The value of the sum
//  */
// uint32_t multiply_and_sum(uint32_t A, uint32_t B, uint32_t D1, uint32_t D2);

// /* Returns the MSBs of the multiplication. Must be called
//  * immediately after multiply_and_sum.
//  * Inputs: none
//  * Returns:
//  * C => 32-bit integer
//  */
// uint32_t get_carry();

// /* Performs the computation inside the FIOS nested loop.
//  * Inputs:
//  * t, a, b, n => Multiple precision numbers (in the order of SIZE x 32 bits)
//  * C => carry from outside the loop
//  * i, j => index for both outer and inner loops respectively
//  * m => 32-bit integer
//  */
// void montgomery_loop(uint32_t* a, uint32_t* b, uint32_t * t, uint32_t C, uint32_t * n, uint32_t i, uint32_t j, uint32_t m);

// // void add_carry(uint32_t *t, uint32_t i, uint32_t c);

// #endif /* ASM_FUNC_H_ */
