#include "hw.h"
#include "interface.h"
#include "mp_print.h"

#include <stdint.h>

#define SIZE 16

// DMA commands
#define CMD_READ_1ST_OPERAND 0
#define CMD_READ_2ND_OPERAND 1
#define CMD_READ_3RD_OPERAND 2
#define CMD_READ_4TH_OPERAND 3
#define CMD_READ_5TH_OPERAND 4
#define CMD_START_MULT       5
#define CMD_WRITE_MULT       6
#define CMD_START_EXP        7
#define CMD_WRITE_EXP        8

// Calculates 512-bit montgomery multiplication in hardware
void HW_MontMult512(uint32_t *a, uint32_t *b, uint32_t *m, uint32_t *res) {
    // Send 1st operand (A)
    my_montgomery_port[0] = CMD_READ_1ST_OPERAND;
    bram_dma_transfer(dma_config, a, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();
    mp_print(a, "", 16);
    mp_print(my_montgomery_data, "", 16);

    // Send 2nd operand (B)
    my_montgomery_port[0] = CMD_READ_2ND_OPERAND;
    bram_dma_transfer(dma_config, b, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();
    mp_print(b, "", 16);
    mp_print(my_montgomery_data, "", 16);

    // Send 3rd operand (M)
    my_montgomery_port[0] = CMD_READ_3RD_OPERAND;
    bram_dma_transfer(dma_config, m, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();
    mp_print(m, "", 16);
    mp_print(my_montgomery_data, "", 16);

    // Send start command
    my_montgomery_port[0] = CMD_START_MULT;
    port2_wait_for_done();


    // Send write result command
    my_montgomery_port[0] = CMD_WRITE_MULT;
    port2_wait_for_done();

    // Save result
    int i; for(i = 0; i < SIZE; i++) res[i] = my_montgomery_data[i];

    mp_print(res, "", 16);
    mp_print(my_montgomery_data, "", 16);
}

// Calculates 512-bit montgomery exponentiation in hardware
void HW_MontExp512(uint32_t *x, uint32_t *e, uint32_t *m, uint32_t *r2modm, uint32_t *rmodm, uint32_t *res) {


    // Send 1st operand (X)
    my_montgomery_port[0] = CMD_READ_1ST_OPERAND;
    bram_dma_transfer(dma_config, x, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();

    // Send 2nd operand (E)
    my_montgomery_port[0] = CMD_READ_2ND_OPERAND;
    bram_dma_transfer(dma_config, e, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();

    // Send 3rd operand (M)
    my_montgomery_port[0] = CMD_READ_3RD_OPERAND;
    bram_dma_transfer(dma_config, m, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();

    // Send 4rd operand (R2modM)
    my_montgomery_port[0] = CMD_READ_4TH_OPERAND;
    bram_dma_transfer(dma_config, r2modm, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();

    // Send 5th operand (RmodM)
    my_montgomery_port[0] = CMD_READ_5TH_OPERAND;
    bram_dma_transfer(dma_config, rmodm, DMA_TRANSFER_NUMBER_OF_WORDS);
    port2_wait_for_done();

    // Send start command
    my_montgomery_port[0] = CMD_START_EXP;
    port2_wait_for_done();

    // Send write result command
    my_montgomery_port[0] = CMD_WRITE_EXP;
    port2_wait_for_done();

    // Save result
    int i; for(i = 0; i < SIZE; i++) res[i] = my_montgomery_data[i];
}
