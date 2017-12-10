#include <stdio.h>
#include <stdlib.h>

#include "xil_printf.h"
#include "xil_cache.h"

#include "platform/platform.h"
#include "platform/performance_counters.h"

#include "interface.h"
#include "sw.h"
#include "hw.h"

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


// Note that these tree CMDs are same as
// they are defined in montgomery_wrapper.v
#define CMD_READ_A1_A2    0
#define CMD_READ_B1_B2    1
#define CMD_READ_M1_M2    2
#define CMD_MULTIPLY      3
#define CMD_WRITE         4

// int main()
// {
//     int i;

//     init_platform();
//     init_performance_counters(1);
//     interface_init();

//     xil_printf("Startup..\n\r");

//     START_TIMING
// 	test_dma_transfer();
//     STOP_TIMING

//     ////////////// Test the port-based communication //////////////

// 	//// --- Create and initialize src array

// #if NUMBER_OF_CORES == 1
// 	// If NUMBER_OF_CORES == 1
// 	// then all 16 words defined below will be used to communicate with Core 1

// 	unsigned int src[DMA_TRANSFER_NUMBER_OF_WORDS]={
// 		0x00000000, 0x00000000, 0x01234567, 0x89abcdef,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000};
// #else
//     // If NUMBER_OF_CORES == 2
//     // then 32 words will be defined,
//     //      the words  0 to 15 will be used to communicate with Core 1
//     //      the words 16 to 31 will be used to communicate with Core 2

//     unsigned int src[DMA_TRANSFER_NUMBER_OF_WORDS]={
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x76543210, 0xfedcba98, 0x00000000, 0x00000000,

// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x00000000, 0x00000000, 0x00000000, 0x00000000,
// 		0x89abcdef, 0x01234567, 0x00000000, 0x00000000};

//     // If you need, you can use the src1 and src2 pointers 
//     // to access the src array defined above as two individual arrays.
//     // src1 for the lower  16-words of the src array and
//     // src2 for the higher 16-words
//     unsigned int* src1 = src;
//     unsigned int* src2 = src+16;
// #endif
//     //// --- Perform the send operation

//     // Start by writing CMD_READ to port1 (command port)
//     xil_printf("PORT1=%x\n\r",CMD_READ_A1_A2);
//     my_montgomery_port[0] = CMD_READ_A1_A2;

//     // Transfer the src array to BRAM
//     bram_dma_transfer(dma_config,src,DMA_TRANSFER_NUMBER_OF_WORDS);

//     // Wait for done of CMD_READ is done
//     // by waiting for port2 (acknowledgement port)
//     port2_wait_for_done();


//     //// --- Print BRAM contents
//     // For checking if send is successful
//     print_bram_contents();

//     // Start by writing CMD_READ to port1 (command port)
//     xil_printf("PORT1=%x\n\r",CMD_READ_B1_B2);
//     my_montgomery_port[0] = CMD_READ_B1_B2;

//     // Transfer the src array to BRAM
//     bram_dma_transfer(dma_config,src,DMA_TRANSFER_NUMBER_OF_WORDS);

//     // Wait for done of CMD_READ is done
//     // by waiting for port2 (acknowledgement port)
//     port2_wait_for_done();


//     //// --- Print BRAM contents
//     // For checking if send is successful
//     print_bram_contents();

//     // Start by writing CMD_READ to port1 (command port)
//     xil_printf("PORT1=%x\n\r",CMD_READ_M1_M2);
//     my_montgomery_port[0] = CMD_READ_M1_M2;

//     // Transfer the src array to BRAM
//     bram_dma_transfer(dma_config,src,DMA_TRANSFER_NUMBER_OF_WORDS);

//     // Wait for done of CMD_READ is done
//     // by waiting for port2 (acknowledgement port)
//     port2_wait_for_done();


//     //// --- Print BRAM contents
//     // For checking if send is successful
//     print_bram_contents();


//     //// --- Perform the compute operation

//     // Start by writing CMD_COMPUTE to port1 (command port)
//     xil_printf("PORT1=%x\n\r",CMD_MULTIPLY);
//     my_montgomery_port[0] = CMD_MULTIPLY;

//     // Wait for done of CMD_COMPUTE is done
// 	// by waiting for port2 (acknowledgement port)
//     port2_wait_for_done();


//     //// --- Perform the read operation

//     // Start by writing CMD_WRITE to port1 (command port)
//     xil_printf("PORT1=%x\n\r",CMD_WRITE);
//     my_montgomery_port[0] = CMD_WRITE;

//     // Wait for done of CMD_WRITE is done
//     port2_wait_for_done(); //Wait until Port2=1


//     //// --- Print BRAM contents

//     // For receiving the read output of the computation
//     print_bram_contents();

//     cleanup_platform();

//     return 0;
// }
/* AUTOGENERATED FILE. DO NOT EDIT. */

/*=======Test Runner Used To Run Each Test Below=====*/
#define RUN_TEST(TestFunc, TestLineNum) \
{ \
  Unity.CurrentTestName = #TestFunc; \
  Unity.CurrentTestLineNumber = TestLineNum; \
  Unity.NumberOfTests++; \
  if (TEST_PROTECT()) \
  { \
      setUp(); \
      TestFunc(); \
  } \
  if (TEST_PROTECT()) \
  { \
    tearDown(); \
  } \
  UnityConcludeTest(); \
}

/*=======Automagically Detected Files To Include=====*/
#ifdef __WIN32__
#define UNITY_INCLUDE_SETUP_STUBS
#endif
#include "../test/unity.h"
#include <setjmp.h>
#include <stdio.h>
#include "../src/sw.h"
#include "../test/testvector.h"

/*=======External Functions This Runner Calls=====*/
extern void setUp(void);
extern void tearDown(void);
extern void test_MpAdd(void);
extern void test_MpSubTest(void);
extern void test_MpSubTestZeros(void);
extern void test_Mod(void);
extern void test_ModAdd(void);
extern void test_ModSub(void);
extern void test_MontMultiply1(void);
extern void test_MontMultiply2(void);
extern void test_MontMultiply3(void);
extern void test_AddCarry(void);
extern void test_ModExp(void);


/*=======Suite Setup=====*/
static void suite_setup(void)
{
#if defined(UNITY_WEAK_ATTRIBUTE) || defined(UNITY_WEAK_PRAGMA)
  suiteSetUp();
#endif
}

/*=======Suite Teardown=====*/
static int suite_teardown(int num_failures)
{
#if defined(UNITY_WEAK_ATTRIBUTE) || defined(UNITY_WEAK_PRAGMA)
  return suiteTearDown(num_failures);
#else
  return num_failures;
#endif
}

/*=======Test Reset Option=====*/
void resetTest(void);
void resetTest(void)
{
  tearDown();
  setUp();
}


/*=======MAIN=====*/
int main(void)
{
  suite_setup();
  UnityBegin("test/sw_test.c");
  RUN_TEST(test_MpAdd, 19);
  RUN_TEST(test_MpSubTest, 33);
  RUN_TEST(test_MpSubTestZeros, 45);
  RUN_TEST(test_Mod, 57);
  RUN_TEST(test_ModAdd, 67);
  RUN_TEST(test_ModSub, 77);
  RUN_TEST(test_MontMultiply1, 92);
  RUN_TEST(test_MontMultiply2, 105);
  RUN_TEST(test_MontMultiply3, 118);
  RUN_TEST(test_AddCarry, 131);
  RUN_TEST(test_ModExp, 142);

  return suite_teardown(UnityEnd());
}
