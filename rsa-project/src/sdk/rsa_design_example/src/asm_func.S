@ .text
@ 
@ .global add_3
@ .func add_3, add_3
@ .type add_3, %function
@ 
@ add_3:
@ add r0, r0, r1
@ add r0, r0, r2
@ bx lr
@ .endfunc
@ 
@ .text
@ 
@ .global add_10
@ .func add_10, add_10
@ .type add_10, %function
@ 
@ add_10:
@ cmp r1, #0
@ beq end_add
@ mov r2, #0
@ add_loop:
@ 	ldr r3, [r0], #4
@ 	add r2, r2, r3
@ 	subs r1, r1, #1
@ 	bne  add_loop
@ mov r0, r2
@ end_add:
@ bx lr
@ .endfunc
@ 
@ .text
@ 
@ .global arr_copy
@ .func arr_copy, arr_copy
@ .type arr_copy, %function
@ 
@ arr_copy:
@ cmp r2, #0
@ beq end_add
@ copy_loop:
@ 	ldr r3, [r0], #4
@ 	str r3, [r1], #4
@ 	subs r2, r2, #1
@ 	bne  copy_loop
@ end_copy:
@ bx lr
@ .endfunc
@ 
@ .text
@ 
@ .global multiply
@ .func multiply, multiply
@ .type multiply, %function
@ 
@ multiply:
@ 	push {r4-r9}
@ 	// If more registers are used in the function make sure to do push them on the stack to preserve them
@ 	ldr r4, [sp, #24]		@m pointer is stored in R4
@ 	ldr r5, [sp, #28]		@n pointer is stored in R5
@ 	add r1, r1, r0, lsl #2
@ 	ldr r6, [r4]
@ 	ldr r7, [r5]
@ 	umull r8, r9, r6, r7
@ 	ldr r6, [r2]
@ 	ldr r7, [r3]
@ 	umull r4, r5, r6, r7
@ 	adds r8, r8, r4
@ 	adc r9, r9, r5
@ 	stmia r1, {r8, r9}
@ 	pop {r4-r9}
@ 	bx lr
@ .endfunc
@ 
@ .text
@ 
@ .global multiply_and_sum
@ .func multiply_and_sum, multiply_and_sum
@ .type multiply_and_sum, %function
@ 
@ multiply_and_sum:
@ 	@ Input arguments: r0 -> A, r1 -> B, r2 -> D1, r3 -> D2
@ 	@ Multiply, save S in r4 and C in r5 
@ 	umull r0, r1, r0, r1
@ 	@ D1+D2
@ 	adds r2, r2, r3
@ 	@ Add possible carry to C
@ 	adc r1, r1, #0
@ 	@ Add D1+D2 to S
@ 	adds r0, r0, r2
@ 	@ Add possible carry to C
@ 	adc r1, r1, #0
@ 	@ Branch back
@ 	bx lr
@ .endfunc
@ 
@ .text
@ 
@ .global get_carry
@ .func get_carry, get_carry
@ .type get_carry, %function
@ 
@ get_carry:
@ 	@ Returns r1
@ 	mov r0, r1
@ 	bx lr
@ .endfunc
@ 
@ 
@ .text
@ 
@ .global add_carry
@ .func add_carry, add_carry
@ .type add_carry, %function
@ 
@ @ *t -> r0
@ @ i  -> r1
@ @ c  -> r2
@ 
@ add_carry:
@ 	@ Muliply i by 4 and add to first address
@ 	mov r1, r1, lsl #2
@ 	add r0, r0, r1
@ 	@ Loop while c != 0
@ 	cmp r2, #0
@ 	beq add_carry_end
@ add_carry_loop:
@ 	@ Get t[i] and add the carry
@ 	ldr r3, [r0]
@ 	adds r3, r3, r2
@ 	str r3, [r0], #4
@ 	@ Update the carry
@ 	mov r2, #0
@ 	adc r2, r2, #0
@ 	@ Check c != 0
@ 	cmp r2, #0
@ 	bne add_carry_loop
@ add_carry_end:
@ 	bx lr
@ 
@ .endfunc
@ 
@ 
@ .text
@ 
@ .global montgomery_loop
@ .func montgomery_loop, montgomery_loop
@ .type montgomery_loop, %function
@ 
@ @ initial arguments
@ @ r0 -> a, r1 -> b, r2 -> t, r3 -> c, r4 -> n, r5 -> i, r6 -> j, r7 -> m
@ 
@ montgomery_loop:
@ 	@ Passing a, b, t, c in r0-r3
@ 	@ Save registers to stack
@ 	push {r4-r10}
@ 	@ Save the link register
@ 	mov r10, lr
@ 	@ Get arguments from stack
@ 	ldr r4, [sp, #28]
@ 	ldr r5, [sp, #32]
@ 	ldr r6, [sp, #36]
@ 	ldr r7, [sp, #40]
@ 	@@ S = multiply_and_sum(a[j], b[i], t[j], C);
@ 	@ Move t from r2 to r9
@ 	mov r9, r2
@ 	@ Stores S in r0 and C in r1
@ 	ldr r0, [r0, r6, lsl #2]
@ 	ldr r1, [r1, r5, lsl #2]
@ 	ldr r2, [r2, r6, lsl #2]
@ 	bl multiply_and_sum
@ 	@ Save S in r8
@ 	mov r8, r0
@ 	@@ add_carry(t, j + 1, C);
@ 	@ Move t from r9 to r0 and C (r1) to r2
@ 	mov r0, r9
@ 	mov r2, r1
@ 	@ Move j o r1 and increment it by 1
@ 	mov r1, r6
@ 	add r1, #1
@ 	bl add_carry
@ 	@@ S = multiply_and_sum(m, n[j], S, 0);
@ 	@ Get address of n[j]
@ 	mov r1, r6, lsl #2
@ 	add r1, r1, r4
@ 	@ Get value in that address
@ 	ldr r1, [r1]
@ 	@ Move S to r2
@ 	mov r2, r8
@ 	@ Move m from r7 to r0
@ 	mov r0, r7
@ 	@ Move 0 to r3
@ 	mov r3, #0
@ 	@ Call function
@ 	bl multiply_and_sum
@ 	@@ t[j - 1] = S;
@ 	@ Get address of t[j-1]
@ 	sub r6, r6, #1
@ 	mov r6, r6, lsl #2
@ 	add r6, r6, r9
@ 	@ Save S in that address
@ 	str r0, [r6]
@ 	@ Restore registers
@ 	mov r1, r10
@ 	pop {r4-r10}
@ 	bx r1
@ .endfunc
@ 
@ 
@ 
@ 
@ 
@ 
@ 
@ 
@ @USEFUL FUNCTIONS
@ 
@ @ add Rx, Ry, Rz	//Rx = Ry + Rz  second operand can be constant
@ @ sub Rx, Ry, Rz	//Rx = Ry - Rz second operand can be constant
@ @ addc Rx, Ry, Rz	//Rx = Ry + Rz + CARRY   one operand can be constant
@ @ cmp Rx, Ry		//compares Rx and Ry and if they are equal sets Z flag, otherwise resets Z flag (works by subtracting two values and checks if result is zero)
@ @ b{cond} <label>		//Jumps to given label in the code if given condition is satisfied
@ @ umull Rn, Rm, Rx, Ry 	//{Rm, Rn} = Rx * Ry Multiplies unsigned 32bit values in Rx and Ry. Stores the higher 32 bits in Rm, and lower in Rn
@ @ ldr Rx, [Ry]		//Loads from memory pointed by Ry to register Rx, see addressing modes for post increment, pre decrement
@ @ str Rx, [Ry]		//Stores to memory pointed by Ry value in register Rx, see addressing modes for post increment, pre decrement
@ @ pop {}			//Pops values from stack to specified registers in order they are specified
@ @ push {}			//Push registers to stack in orded they are specified
@ @ ldmia rx, {set of registers} //Loads to specified set of registers memory values, starting from rx. Increasing addresses
@ @ stmia rx, {set of registers} //Stores specified set of registers in memory, starting from address pointed by rx. Increasing addresses
@ 