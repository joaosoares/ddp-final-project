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





// //Does this: a+b+(m*n); returns lower 32 bits. get upper 32 bits with getRegR1()
// uint32_t simpleMultiply64(uint32_t a, uint32_t b, uint32_t m, uint32_t n);


// //Does this: a+b+(m*n); returns lower 32 bits. get upper 32 bits at address C
// uint32_t mul64(uint32_t a, uint32_t b, uint32_t m, uint32_t n, uint32_t *C);


// void new_add(uint32_t *t, uint32_t startIdx, uint32_t C);


// uint32_t getRegR1();



// uint32_t innerLoop(uint32_t C, uint32_t SIZE, uint32_t m, uint32_t bk, uint32_t *a, uint32_t *ttemp, uint32_t *n);


// #endif /* ASM_FUNC_H_ */
