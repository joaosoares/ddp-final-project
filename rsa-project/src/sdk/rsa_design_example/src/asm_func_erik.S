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
@ add_10: //r0 stores address of array, r1 stores length of aray
@ cmp r1, #0 //compare value in register 1 to 0. (
@ beq end_add //if equal (size = 0), then no additions will be made. Jump to end
@ mov r2, #0 // initialize r2 to zero.
@ add_loop:
@ 	ldr r3, [r0], #4 //load from address. #4 is incremented to address register r0
@ 	add r2, r2, r3
@ 	subs r1, r1, #1
@ 	bne  add_loop //branch if zero flag is not set Checks the zero flag
@ mov r0, r2 //r0 is the register the function will return
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
@ cmp r2, #0 // if length is zero, there is nothing to copy. skip to end
@ beq end_add //skip or not
@ copy_loop:
@ 	ldr r3, [r0], #4 //loads element from a array, and increments address pointer by 4
@ 	str r3, [r1], #4 //put content of r3 to memory location in r1
@ 	subs r2, r2, #1 //subtracts and updates comparison flags
@ 	bne  copy_loop //if zero flag is not set, loop again
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
@ 	//m pointer and n pointer are added to stack.
@ 	push {r4-r9} //store initial register state. stackpointer decremented by 24 (4 bytes/reg times 6 reg)
@ 	// If more registers are used in the function make sure to do push them on the stack to preserve them
@ 	ldr r4, [sp, #24]		@m pointer is stored in R4
@ 	ldr r5, [sp, #28]		@n pointer is stored in R5
@ 	//below line is equivalent to: r1 = r1+(r0*4), or r1 = r1+(r0<<2)
@ 	//r1 is the pointer to the output array, and we move the pointer corresponding to index i
@ 	add r1, r1, r0, lsl #2 //multiplies the index by four, so that the address is modified properly
@ 	ldr r6, [r4] //load from m
@ 	ldr r7, [r5] //load from n
@ 	umull r8, r9, r6, r7 //multiply m[0] and n[0]
@ 	ldr r6, [r2] //load from a
@ 	ldr r7, [r3] //load from b
@ 	umull r4, r5, r6, r7 //muliply a[0] and b[0]
@ 	adds r8, r8, r4 //add LSBs of each multiplication and set flags
@ 	adc r9, r9, r5 //add arguments AND carry and set flags
@ 	stmia r1, {r8, r9} //store the contents of r8 and r9 in memory, starting from address r1
@ 	pop {r4-r9} //restore stack to previous state
@ 	bx lr
@ .endfunc
@ 
@ 
@ 
@ 
@ .text
@ 
@ .global simpleMultiply64
@ .func simpleMultiply64, simpleMultiply64
@ .type simpleMultiply64, %function
@ 
@ simpleMultiply64:
@ 	//r0 = a, r1 = b, r2 = m, r3= n
@ 	// want a+b + m*n
@ 	adds r0, r0, r1 //a+b
@ 	umull r1, r2, r2, r3 //m*n
@ 	adc r2, #0 // m*n higher bits + carry
@ 	adds r0, r0, r1; //m*n [lower bits] +(a+b) lower bits
@ 	mov r1, r2;
@ 	adc r1, #0; //carry added to m*n [higher bits]
@ 
@ 	//result is now in r0 and r1 [low, high] bits
@ 	//get r1 with getRegR1 function
@ 	bx lr
@ .endfunc
@ 
@ 
@ 
@ .text
@ 
@ .global mul64
@ .func mul64, mul64
@ .type mul64, %function
@ 
@ mul64:
@ 	//r0 = a, r1 = b, r2 = m, r3= n, r4 = *C
@ 	push {r4} //store initial register state. stackpointer decremented by 4 (4 bytes/reg times 1 reg)
@ 	ldr r4, [sp, #4]		//C pointer is stored in R4
@ 
@ 	umaal r0, r1, r2, r3
@ 
@ 	stmia r4, {r1} //store the contents of r8 and r9 in memory, starting from address r1
@ 	pop {r4} //restore stack to previous state
@ 	bx lr
@ 
@ .endfunc
@ 
@ 
@ 
@ 
@ 
@ .text
@ 
@ .global new_add
@ .func new_add, new_add
@ .type new_add, %function
@ 
@ 
@ new_add:
@ 
@    lsl r1, #2
@    add r0, r0, r1				// r3 = base address + 32
@    ldr r1, [r0]
@    adds r1, r1, r2				// load value pointed by r3					// r0 contains next element of array
@    str r1, [r0], #4
@    bcs loop
@    bx lr
@    loop:
@    	ldr r1, [r0]
@    	adcs r1, r1, #0
@    	str r1, [r0], #4
@    	bcs loop
@    	b endloop
@    endloop:
@    bx lr
@ 
@ .endfunc
@ 
@ 
@ 
@ .text
@ 
@ .global getRegR1
@ .func getRegR1, getRegR1
@ .type getRegR1, %function
@ 
@ getRegR1:
@ mov r0, r1
@ bx lr
@ .endfunc
@ 
@ 
@ 
@ 
@ 
@ //inner loop
@ 
@ .text
@ 
@ .global innerLoop
@ .func innerLoop, innerLoop
@ .type innerLoop %function
@ 
@ /*void innerLoop(C, Size, m, bk, *a, *ttemp, *n);
@ &a		0		-32
@ &ttemp	-4		-36
@ */
@ 
@ innerLoop:
@ 	push {r4-r11} //store initial register state. stackpointer decremented by 32 (4 bytes/reg times 8 reg)
@ 	ldr r4, [sp, #32] // *a
@ 	ldr r5, [sp, #36]// *ttemp
@ 	ldr r8, [sp, #40]// *n
@ 
@ 	sub r1, r1, #1; // will decrement size until it's zero
@ 
@ 	add r4, r4, #4; //offset because j starts at 1
@ 	add r5, r5, #4; // same as above
@ 	add r8, r8, #4; // same as above
@ 
@ 
@ 
@ 
@ 	loopSection:
@ 
@ 
@ 	//														[S,C] = a[j]*bk + ttemp[j] + C
@ 	ldr r6, [r4], #4; //put a[j] into reg r6, post increments address so next time it will point to j+1
@ 	ldr r7, [r5], #4; //put ttemp[j] into reg7
@ 	adds r7, r7, r0 //ttemp[j] + C
@ 	umull r6,r0,r6,r3; //MSB of a[j]*bk in r0, LSB in r06
@ 	adc r0,r0, #0;
@ 	adds r6, r6, r7
@ 	adc r0,r0, #0
@ 
@ 	//result is now in r6 and r0 [low, high] bits
@ 
@ 
@ 
@ 
@ 	//														addFunction(ttemp,j+1,C);
@    mov r9, r5			//already incremented, points to j+1. r9 now contains a pointer
@    ldr r10, [r9]		//ttemp[j+1]
@    adds r10, r10, r0	//add C to ttemp[j+1]
@    str r10, [r9], #4	//store result in array
@    bcs loop2
@    b endloop2
@    loop2:
@    	ldr r10, [r9]
@    	adcs r10, r10, #0
@    	str r10, [r9], #4
@    	bcs loop2
@    endloop2:
@ 
@ 
@ 	ldr r10, [r8], #4; //put n[j] into reg10
@ 	//												[S,C] = m * n[j] + S
@ 	umull r9, r10, r2, r10
@ 	adds r9, r9, r6	//S
@ 	adc r0, r10, #0		//C
@ 
@ 
@ 
@ 	//			temp[j-1] = S;
@ 	str r9, [r5,#-8]
@ 
@ 
@ 
@ 		subs r1, r1, #1 //decrementing SIZE
@ 		bne loopSection //if zero flag is not set, loop again
@ 
@ 	pop {r4-r11}
@ 	bx lr
@ .endfunc
@ 
@ 