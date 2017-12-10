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
    input [511:0] in_x,
    input [511:0] in_e,
    input [511:0] in_m,
    output [511:0] res,
    output done
    );
 

    // Declare states
    parameter START = 0,
    ASSIGN_R = 1,
    ASSIGN_R2_START = 2,
    ASSIGN_R2_WAIT = 3,
    ASSIGN_A_START = 4,
    ASSIGN_A_WAIT = 5,
    ASSIGN_X_TILDE_START = 6,
    ASSIGN_X_TILDE_WAIT = 7,
    ASSIGN_T = 8,
    LOOP_START = 9,
    LOOP_ASSIGN_A_START = 10,
    LOOP_ASSIGN_A_WAIT = 11,
    LOOP_IF_BIT = 12,
    LOOP_IF_BIT_ASSIGN_A_START = 13,
    LOOP_IF_BIT_ASSIGN_A_WAIT = 14,
    LOOP_MULT_A_BY_ONE = 15,
    DONE = 16;

	// Declare state register
	reg [3:0] state, nextstate;

    // Datapath control in signals (Datapath -> FSM)
    wire mod_done, 
        mult_done;

    //Datapath control out signals (FSM -> Datapath)
    reg start_mult,
        start_mod;

    // temporary registers
    reg [15:0] counter;
    reg [511:0] mult_in_a, 
                mult_in_b, 
                mult_result, 
                mod_result, 
                mod_in_a;

    
    montgomery mult(
        clk,
        resetn,
        start_mult, 
        mult_in_a,
        mult_in_b,
        in_m,
        mult_result,
        mult_done
    );

    mod mod1(
        clk,
        resetn,
        start_mod,
        mod_in_a,
        in_m,
        mod_result,
        mod_done
    );
    // example state machine for computation flow
    always @(*)
    begin
        case(state)
            START: begin
                
            end
        endcase
    end


    // next state logic

    always @(*) begin
      case(state)
        START: begin
            if (start)
                nextstate <= ASSIGN_R;
            else
                nextstate <= START;
        end
        ASSIGN_R: begin
            nextstate <= ASSIGN_R2_START;
        end
        ASSIGN_R2_START: begin
            nextstate <= ASSIGN_R2_WAIT;
        end
        ASSIGN_R2_WAIT: begin
            if(!mod_done)
                nextstate <= ASSIGN_R2_WAIT;
            else
                nextstate <= ASSIGN_A_START;
        end
        ASSIGN_A_START: begin
            nextstate <= ASSIGN_A_WAIT;
        end
        ASSIGN_A_WAIT: begin
            if(!mod_done)
            nextstate <= ASSIGN_A_WAIT;
            else
            nextstate <= ASSIGN_X_TILDE_START;
        end
        ASSIGN_X_TILDE_START: begin
            nextstate <= ASSIGN_X_TILDE_WAIT;
        end
        ASSIGN_X_TILDE_WAIT: begin
            if(!mult_done)
            nextstate <= ASSIGN_X_TILDE_WAIT;
            else
            nextstate <= ASSIGN_T;
        end
        ASSIGN_T: begin
            if(cur_bit == 1'b1)
            nextstate <= LOOP_START;
            else
            nextstate <= ASSIGN_T;
        end
        LOOP_START: begin
            nextstate <= LOOP_ASSIGN_A_START;
        end
        LOOP_ASSIGN_A_START: begin
            nextstate <= LOOP_ASSIGN_A_WAIT;
        end
        LOOP_ASSIGN_A_WAIT: begin
            if(!mult_done)
                nextstate <= LOOP_ASSIGN_A_WAIT;
            else
                nextstate <= LOOP_IF_BIT;
        end
        LOOP_IF_BIT: begin
            if(cur_bit == 1'b1)
                nextstate <= LOOP_IF_BIT_ASSIGN_A_START;
            else
                nextstate <= LOOP_MULT_A_BY_ONE;
        end
        LOOP_IF_BIT_ASSIGN_A_START: begin
            nextstate <= LOOP_IF_BIT_ASSIGN_A_WAIT;
        end
        LOOP_IF_BIT_ASSIGN_A_WAIT: begin
            if(!mult_done)
                nextstate <= LOOP_IF_BIT_ASSIGN_A_WAIT;
            else
                nextstate <= DONE;
        end
        DONE:
            nextstate <= DONE;
        endcase
    end

    // datapath


assign cur_bit = in_e[counter];

endmodule

