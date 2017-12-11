`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2017 05:43:49 PM
// Design Name: 
// Module Name: mod
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


module mod(
    input clk,
    input resetn,
    input start,
    input [513:0] in_a,
    input [513:0] in_n,
    output [513:0] result,
    input done
    );


    reg [2:0] state, nextstate;

    reg [513:0] a_reg, n_reg;

    // Declare states
    parameter START = 0,
    SUB_START = 1,
    SUB_WAIT = 2,
    COMPARE = 3,
    SAVE_PREV_RES = 4,
    RES_WRITE = 5,
    DONE = 6;

    // Data registers
    reg [513:0] prev_result;
    reg [513:0] cur_result;

    // Datapath control in signals
    wire sub_done, sub_negative;
    wire [514:0] sub_full_result;
    wire sub_carry;
    wire [513:0] sub_result;

    // Datapath control out signals
    reg start_sub, write_res, write_prev_res;

	// Next state update
	always @(posedge clk)
	begin
		if(!resetn)
			state <= START;
		else
			state <= nextstate;
	end

    // Control out signals logic
    always @(*)
    begin
        case(state)
            SUB_START: begin
                start_sub <= 1'b1;
                write_prev_res <= 1'b0;
                write_res <= 1'b0;
            end
            SAVE_PREV_RES: begin
                start_sub <= 1'b0;
                write_prev_res <= 1'b1;
                write_res <= 1'b1;
            end
            RES_WRITE: begin
                start_sub <= 1'b0;
                write_prev_res <= 1'b0;
                write_res <= 1'b1;
            end
            default: begin
                start_sub <= 1'b0;
                write_prev_res <= 1'b0;
                write_res <= 1'b0;
            end
        endcase
    end

    // Next state logic
    always @(*) begin
        case(state)
            START: begin
                if (start)
                    nextstate <= SUB_START;
                else
                    nextstate <= START;
            end
            SUB_START: begin
                nextstate <= SUB_WAIT;
            end
            SUB_WAIT: begin
                if (sub_done == 1'b1)
                    nextstate <= COMPARE;
                else
                    nextstate <= SUB_WAIT;
            end
            COMPARE: begin
                if (sub_carry == 1'b1)
                    nextstate <= RES_WRITE;
                else
                    nextstate <= SAVE_PREV_RES;
            end
            SAVE_PREV_RES: begin
                nextstate <= SUB_START;
            end
            RES_WRITE: begin
                nextstate <= DONE;
            end
        endcase
    end

    // Datapath
    adder subtract(
        clk,
        resetn,
        start_sub,
        1'b1,
        1'b0,
        a_reg,
        n_reg,
        sub_full_result,
        sub_done
    );

    always @(posedge clk) begin
        if (start) begin
            a_reg <= in_a;
            n_reg <= in_n;
            prev_result <= in_a;
            cur_result <= 514'b0;
        end  
        else if (write_prev_res) begin
            prev_result <= sub_result;
            a_reg <= sub_result;
        end
        else if (write_res) begin
            cur_result <= a_reg;
        end
    end

    assign result = cur_result;
    assign sub_result = sub_full_result[512:0];
    assign sub_carry = sub_full_result[513];
	assign done = (state==DONE) ? 1'b1 : 1'b0;

endmodule
