`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2017 05:21:28 PM
// Design Name: 
// Module Name: montgomery_exp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module montgomery_exp(
    input clk,
    input resetn,
    input start,
    input [511:0] x,
    input [511:0] e,
    input [511:0] m,
    output [511:0] res,
    output done
    );


    // Declare states
    parameter START = 0;
    ASSIGN_R = 1,
    ASSIGN_R2 = 2,
    ASSIGN_A = 3,
    ASSIGN_X_TILDE_START = 4,
    ASSIGN_X_TILDE_WAIT = 5,
    ASSIGN_T = 6,
    LOOP_START = 7,
    LOOP_ASSIGN_A_START = 8,
    LOOP_ASSIGN_A_WAIT = 9,
    LOOP_IF_BIT = 10,
    LOOP_IF_BIT_ASSIGN_A_START = 11,
    LOOP_IF_BIT_ASSIGN_A_WAIT = 12,
    LOOP_MULT_A_BY_ONE = 13,
    DONE = 14;

    // Datapath control in signals
    
endmodule

