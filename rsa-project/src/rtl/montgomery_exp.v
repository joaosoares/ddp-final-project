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
    input [511:0] in_rmodm,
    input [511:0] in_r2modm,
    output [511:0] result,
    output done
    );
 

    // Declare states
    parameter START = 0,
    A_ASSIGN = 1,
    X_TILDE_SETUP = 2,
    X_TILDE_START = 3,
    X_TILDE_WAIT = 4,
    X_TILDE_ASSIGN = 5,
    WAIT_UNTIL_BITLEN = 6,
    DECREMENT_COUNTER = 7,
    LOOP_START = 8,
    LOOP_A_SETUP = 9,
    LOOP_A_START = 10,
    LOOP_A_WAIT = 11,
    LOOP_A_ASSIGN = 12,
    LOOP_IF_BIT = 13,
    LOOP_IF_BIT_A_SETUP = 14,
    LOOP_IF_BIT_A_START = 15,
    LOOP_IF_BIT_A_WAIT = 16,
    LOOP_IF_BIT_A_ASSIGN = 17,
    LOOP_END = 18,
    MULT_A_BY_ONE_SETUP = 19,
    MULT_A_BY_ONE_START = 20,
    MULT_A_BY_ONE_WAIT = 21,
    MULT_A_BY_ONE_ASSIGN = 22,
    DONE = 23;

	// Declare state register
	reg [4:0] state, nextstate;

    // Datapath control in signals (Datapath -> FSM)
    wire mult_done, cur_bit;

    //Datapath control out signals (FSM -> Datapath)
    reg start_mult,
        assign_a_flag,
        setup_x_tilde_flag,
        assign_x_tilde_flag,
        decrement_counter_flag,
        setup_loop_a_flag,
        assign_loop_a_flag,
        setup_if_bit_a_flag,
        assign_if_bit_a_flag,
        setup_a_by_one_flag,
        assign_a_by_one_flag;

    // Datapath signals
    reg [10:0] counter;                 // Loop counter
    reg [511:0] mult_in_a, mult_in_b;   // Mult inputs
    wire [511:0] mult_result;           // Mult result
    reg [511:0] var_a, var_x_tilde, var_result;     // Algorithm variables

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

	// Next state update
	always @(posedge clk)
	begin
		if(!resetn)
			state <= START;
		else
			state <= nextstate;
	end

    // example state machine for computation flow
    always @(*)
    begin
        case(state)
            // Get results from A and set up x tilde
            A_ASSIGN: begin
                start_mult <= 0;
                assign_a_flag <= 1;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            // Save result from a and 
            X_TILDE_SETUP: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 1;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            X_TILDE_START: begin
                start_mult <= 1;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            X_TILDE_ASSIGN: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 1;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            DECREMENT_COUNTER: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 1;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_A_SETUP: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 1;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_A_START: begin
                start_mult <= 1;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_A_ASSIGN: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 1;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_IF_BIT_A_SETUP: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 1;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_IF_BIT_A_START: begin
                start_mult <= 1;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_IF_BIT_A_ASSIGN: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 1;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            LOOP_END: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 1;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            MULT_A_BY_ONE_SETUP: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 1;
                assign_a_by_one_flag <= 0;
            end
            MULT_A_BY_ONE_START: begin
                start_mult <= 1;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
            MULT_A_BY_ONE_ASSIGN: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 1;
            end
            default: begin
                start_mult <= 0;
                assign_a_flag <= 0;
                setup_x_tilde_flag <= 0;
                assign_x_tilde_flag <= 0;
                decrement_counter_flag <= 0;
                setup_loop_a_flag <= 0;
                assign_loop_a_flag <= 0;
                setup_if_bit_a_flag <= 0;
                assign_if_bit_a_flag <= 0;
                setup_a_by_one_flag <= 0;
                assign_a_by_one_flag <= 0;
            end
        endcase
    end


    // next state logic
    always @(*) begin
        case(state)
            START: begin
                if (start)
                    nextstate <= A_ASSIGN;
                else
                    nextstate <= START;
            end
            // A  = R % M;
            A_ASSIGN: begin
                nextstate <= X_TILDE_SETUP;
            end
            // X_tilde = MontMul_512(X,R2,M)
            X_TILDE_SETUP: begin
                nextstate <= X_TILDE_START;
            end
            X_TILDE_START: begin
                nextstate <= X_TILDE_WAIT;
            end
            X_TILDE_WAIT: begin
                if(!mult_done)
                    nextstate <= X_TILDE_WAIT;
                else
                    nextstate <= X_TILDE_ASSIGN;
            end
            X_TILDE_ASSIGN: begin
                nextstate <= WAIT_UNTIL_BITLEN;
            end
            // t = helpers.bitlen(E)
            WAIT_UNTIL_BITLEN: begin
                if(!cur_bit)
                    nextstate <= DECREMENT_COUNTER;
                else
                    nextstate <= LOOP_START;
            end
            DECREMENT_COUNTER: begin
                nextstate <= WAIT_UNTIL_BITLEN;
            end
            // for i in range(0,t):
            LOOP_START: begin
                nextstate <= LOOP_A_SETUP;
            end
            // A = MontMul_512(A,A,M)
            LOOP_A_SETUP: begin
                nextstate <= LOOP_A_START;
            end
            LOOP_A_START: begin
                nextstate <= LOOP_A_WAIT;
            end
            LOOP_A_WAIT: begin
                if(!mult_done)
                    nextstate <= LOOP_A_WAIT;
                else
                    nextstate <= LOOP_A_ASSIGN;
            end
            LOOP_A_ASSIGN: begin
                nextstate <= LOOP_IF_BIT;
            end
            // if helpers.bit(E,t-i-1) == 1:
            LOOP_IF_BIT: begin
                if (cur_bit)
                    nextstate <= LOOP_IF_BIT_A_SETUP;
                else
                    nextstate <= LOOP_END;
            end
            // A = MontMul_512(A,X_tilde,M)
            LOOP_IF_BIT_A_SETUP: begin
                nextstate <= LOOP_IF_BIT_A_START;
            end
            LOOP_IF_BIT_A_START: begin
                nextstate <= LOOP_IF_BIT_A_WAIT;
            end
            LOOP_IF_BIT_A_WAIT: begin
                if(!mult_done)
                    nextstate <= LOOP_IF_BIT_A_WAIT;
                else
                    nextstate <= LOOP_IF_BIT_A_ASSIGN;
            end
            LOOP_IF_BIT_A_ASSIGN: begin
                nextstate <= LOOP_END;
            end
            LOOP_END: begin
                if (counter > 0)
                    nextstate <= LOOP_START;
                else
                    nextstate <= MULT_A_BY_ONE_SETUP;
            end
            // A = MontMul_512(A,1,M)
            MULT_A_BY_ONE_SETUP: begin
                nextstate <= MULT_A_BY_ONE_START;
            end
            MULT_A_BY_ONE_START: begin
                nextstate <= MULT_A_BY_ONE_WAIT;
            end
            MULT_A_BY_ONE_WAIT: begin
                if(!mult_done)
                    nextstate <= MULT_A_BY_ONE_WAIT;
                else
                    nextstate <= MULT_A_BY_ONE_ASSIGN;
            end
            MULT_A_BY_ONE_ASSIGN: begin
                nextstate <= DONE;
            end
            // return A
            DONE: begin
                if (!start)
                    nextstate <= DONE;
                else
                    nextstate <= START;
            end
        endcase
    end

    // datapath
	always @(posedge clk)
	begin
	    if (start) begin
	        counter <= 511;
	    end
        else if (assign_a_flag) begin
            var_a <= in_rmodm;
        end
        else if (setup_x_tilde_flag) begin
            mult_in_a <= in_x;
            mult_in_b <= in_r2modm;
        end
        else if (assign_x_tilde_flag) begin
            var_x_tilde <= mult_result;
        end
        else if (decrement_counter_flag) begin
            counter <= counter - 1;
        end
        else if (setup_loop_a_flag) begin
            mult_in_a <= var_a;
            mult_in_b <= var_a;
        end
        else if (assign_loop_a_flag) begin
            var_a <= mult_result;
        end
        else if (setup_if_bit_a_flag) begin
            mult_in_a <= var_a;
            mult_in_b <= var_x_tilde;
        end
        else if (assign_if_bit_a_flag) begin
            var_a <= mult_result;
        end
        else if (setup_a_by_one_flag) begin
            mult_in_a <= var_a;
            mult_in_b <= 512'b1;
        end
        else if (assign_a_by_one_flag) begin
            var_result <= mult_result;
        end
    end

    assign result = var_result;
	assign done = (state==DONE) ? 1'b1 : 1'b0;
    assign cur_bit = in_e[counter];

endmodule

