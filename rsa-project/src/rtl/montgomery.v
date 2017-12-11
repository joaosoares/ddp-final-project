`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:15:43 11/14/2016 
// Design Name: 
// Module Name:    add_ddp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


// This is an example "compute" module that computes an addition of two operands

module montgomery(clk, resetn, start, in_a, in_b, in_m, result, done);
    input clk;
    input resetn; // reset 
    input start; // start signal for an addition

    input [511:0] in_a, in_b, in_m; // input operands
    output [513:0] result; // output result
    output done; // done is 1 when an addition complets

    // Parameters
    parameter WIDTH = 512;

    // Declare state register
    reg [3:0] state, nextstate;

    // Declare states
    localparam START  =  0,
    LOOP_START        =  1,
    LOOP_ADD_B_SETUP  =  2,
    LOOP_ADD_B_START  =  3,
    LOOP_ADD_B_WAIT   =  4,
    LOOP_ADD_B_RESULT =  5,
    LOOP_ADD_M_SETUP  =  6,
    LOOP_ADD_M_START  =  7,
    LOOP_ADD_M_WAIT   =  8,
    LOOP_ADD_M_RESULT =  9,
    LOOP_SHIFT        = 10,
    SUB_COND_SETUP    = 11,
    SUB_COND_START    = 12,
    SUB_COND_WAIT     = 13,
    DONE              = 14,
    RESET_BETWEEN_B_M = 15;

    // Datapath control in signals
    wire c0,
    adder_done,
    adder_resetn,
    cur_a;

    // Datapath control out signals
    reg setup_add_b_flag,
        assign_add_b_flag,
        setup_add_m_flag,
        assign_add_m_flag,
        shift_c_flag,
        setup_sub_cond_flag,
        assign_sub_cond_flag,
        adder_resetn_flag,
        adder_start_flag,
        adder_subtract_flag;

    // Wires
    // Temporary registers
    reg [513:0] c_reg, b_reg, m_reg;
    reg [11:0] counter;
    wire [514:0] adder_res;

    reg [513:0] adder_in_a, adder_in_b;

    adder adder1(
        clk,
        adder_resetn,
        adder_start_flag,
        adder_subtract_flag,
        1'b0,
        adder_in_a,
        adder_in_b,
        adder_res,
        adder_done
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
            LOOP_ADD_B_SETUP: begin
                setup_add_b_flag		<= 1;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 1;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            LOOP_ADD_B_START: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 1;
                adder_subtract_flag 	<= 0;
            end
            LOOP_ADD_B_RESULT: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 1;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            RESET_BETWEEN_B_M: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 1;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            LOOP_ADD_M_SETUP: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 1;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 1;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            LOOP_ADD_M_START: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 1;
                adder_subtract_flag 	<= 0;
            end
            LOOP_ADD_M_RESULT: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 1;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            LOOP_SHIFT: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 1;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 1;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            SUB_COND_SETUP: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 1;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            SUB_COND_START: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 1;
                adder_subtract_flag 	<= 1;
            end
            DONE: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 1;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
            default: begin
                setup_add_b_flag		<= 0;
                assign_add_b_flag		<= 0;
                setup_add_m_flag		<= 0;
                assign_add_m_flag		<= 0;
                shift_c_flag			<= 0;
                setup_sub_cond_flag		<= 0;
                assign_sub_cond_flag	<= 0;
                adder_resetn_flag		<= 0;
                adder_start_flag		<= 0;
                adder_subtract_flag 	<= 0;
            end
        endcase
    end

    // nextstate logic
    always @(*)
    begin
        case(state)
            START: begin
                if (start == 1'b1)
                    nextstate <= LOOP_START;
                else
                    nextstate <= START;
            end
            LOOP_START: begin
                if(cur_a == 1'b1) 
                    nextstate <= LOOP_ADD_B_SETUP;
                else
                    nextstate <= LOOP_ADD_B_RESULT;
            end
            LOOP_ADD_B_SETUP: begin
                nextstate <= LOOP_ADD_B_START;
            end
            LOOP_ADD_B_START: begin
                nextstate <= LOOP_ADD_B_WAIT;
            end
            LOOP_ADD_B_WAIT: begin
                if (!adder_done)
                    nextstate <= LOOP_ADD_B_WAIT;
                else begin
                    nextstate <= LOOP_ADD_B_RESULT;
                end
            end
            LOOP_ADD_B_RESULT: begin
                 if (c0 == 0)
                     nextstate <= LOOP_ADD_M_RESULT;
                 else
                     nextstate <= LOOP_ADD_M_SETUP;
            end
            LOOP_ADD_M_SETUP: begin
                nextstate <= RESET_BETWEEN_B_M;
            end
            RESET_BETWEEN_B_M: begin
                nextstate <= LOOP_ADD_M_START;
            end
            LOOP_ADD_M_START: begin
                nextstate <= LOOP_ADD_M_WAIT;
            end
            LOOP_ADD_M_WAIT: begin
                if(!adder_done)
                    nextstate <= LOOP_ADD_M_WAIT;
                else
                    nextstate <= LOOP_ADD_M_RESULT;
            end
            LOOP_ADD_M_RESULT:
                nextstate <= LOOP_SHIFT;
            LOOP_SHIFT: begin
                if (counter < WIDTH-1)
                    nextstate <= LOOP_START;
                else
                    nextstate <= SUB_COND_SETUP;
            end
            SUB_COND_SETUP: begin
                nextstate <= SUB_COND_START;
            end
            SUB_COND_START: begin
                nextstate <= SUB_COND_WAIT;
            end
            SUB_COND_WAIT: begin
                if (!adder_done)
                    nextstate <= SUB_COND_WAIT;
                else
                    nextstate <= DONE;
            end
            DONE: begin
                if (!start)
                    nextstate <= DONE;
                else
                    nextstate <= LOOP_START;
            end
            default: nextstate <= START;
        endcase
    end

    // Datapath
    always @(posedge clk)
    begin
        // C reg modifications
        if (start) begin
            c_reg <= {WIDTH{1'd0}};
            b_reg <= {2'b0, in_b};
            m_reg <= {2'b0, in_m};
            counter <= 12'd0;
        end
        else if (shift_c_flag) begin
            // Shift C to divide by 2
            c_reg <= c_reg >> 1;
            // Increment counter
            counter <= counter + 1;
        end
        else if (setup_add_b_flag) begin
            adder_in_a <= c_reg;
            adder_in_b <= b_reg;
        end
        else if (assign_add_b_flag) begin
            c_reg <= adder_res;
        end
        else if (setup_add_m_flag) begin
            adder_in_a <= c_reg;
            adder_in_b <= m_reg;
        end
        else if (assign_add_m_flag) begin
            c_reg <= adder_res;
        end
        else if (setup_sub_cond_flag) begin
            adder_in_a <= c_reg;
            adder_in_b <= m_reg;
        end
        else if (assign_sub_cond_flag) begin
            if (adder_res[WIDTH] == 0)
                c_reg <= adder_res;
            else
                c_reg <= c_reg;
        end
        else
            c_reg <= c_reg;

    end

    assign done = (state==DONE) ? 1'b1 : 1'b0;
    assign cur_a = in_a[counter];
    assign c0 = c_reg[0];
    assign result = c_reg;
    
    // Reset for adder
    assign adder_resetn = resetn && ~adder_resetn_flag;
endmodule
