`timescale 1ns / 1ps

module montgomery_wrapper
(
    // The clock
    input clk,
    // Active low reset
    input resetn,
    
    // data_* is used to communicate 1024-bit chunks of data with the ARM
    // A BRAM interface receives data from data_out and writes it into BRAM.
    // The BRAM interface can also receive data from DMA, 
    //   and then write it to BRAM.

    /// bram_din receives data from ARM
    
        // Data is read in 1024-bit chunks from DMA.
        input [511:0] bram_din1,
        input [511:0] bram_din2,
        // Indicates that "bram_din" is valid and can be processed by the FSM    
        input bram_din_valid,
    
    /// data_out writes results to ARM
    
        // The result of a computation is stored in data_out. 
        // Only write to "data_out" if you want to store the result
        // of a computation in memory that can be accessed by the ARM 
        output [511:0] bram_dout1,
        output [511:0] bram_dout2,
        // Indicates that there is a valid data in "bram_dout" 
        // that can be written out to memory
        output bram_dout1_valid,
        output bram_dout2_valid,
        // After asserting "bram_dout_valid", 
        // wait for the BRAM interface to read it,
        // so wait for "bram_dout_read" to become high before continuing 
        input bram_dout_read,
    
    /// P1 is to receive commands from the ARM
    
        // The data received from port1
        input [31:0] port1_din,
        // Indicates that new data (command) is available on port1
        input port1_valid,
        // Assert "port1_data_read" when the data (command) 
        //    from "port1_data" has been read .
        // This allows new data to arrive on port1
        output port1_read,
    
    /// P2 is to assert "Done" signal to ARM 
    
        // Indicates on port2 that the operation is complete/done 
        output port2_valid, 
        // You should wait until your "port2_valid" signal is read
        // so wait for "port2_read" to become high
        input port2_read,
    
    /// Outputs to LEDs for debugging

        output [3:0] leds
    );

    localparam STATE_BITS           = 4;    
    localparam STATE_WAIT_FOR_CMD   = 4'd1;
    localparam STATE_READ_1ST_OP    = 4'd2;
    localparam STATE_READ_2ND_OP    = 4'd3;
    localparam STATE_READ_3RD_OP    = 4'd4;
    localparam STATE_READ_4TH_OP    = 4'd5;
    localparam STATE_READ_5TH_OP    = 4'd6;
    localparam STATE_WRITE_MULT     = 4'd7;
    localparam STATE_WRITE_EXP      = 4'd8;
    localparam STATE_WRITE_PORT2    = 4'd9;
    localparam STATE_EXP_START      = 4'd10;
    localparam STATE_EXP_WAIT       = 4'd11;
    localparam STATE_MULT_START     = 4'd12;
    localparam STATE_MULT_WAIT      = 4'd13;
    

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ_1ST_OPERAND = 32'h0;
    localparam CMD_READ_2ND_OPERAND = 32'h1;
    localparam CMD_READ_3RD_OPERAND = 32'h2;
    localparam CMD_READ_4TH_OPERAND = 32'h3;
    localparam CMD_READ_5TH_OPERAND = 32'h4;
    localparam CMD_START_MULT       = 32'h5;
    localparam CMD_WRITE_MULT       = 32'h6;
    localparam CMD_START_EXP        = 32'h7;    
    localparam CMD_WRITE_EXP        = 32'h8;

    wire mont_exp_done;
    wire mont_mult_done;

    ////////////// - State Machine

    always @(*)
    begin
        if (resetn==1'b0)
            next_state <= STATE_WAIT_FOR_CMD;
        else
        begin
            case (r_state)
                STATE_WAIT_FOR_CMD:
                    begin
                        if (port1_valid==1'b1) begin
                            //Decode the command received on Port1
                            case (port1_din)
                                CMD_READ_1ST_OPERAND:
                                    next_state <= STATE_READ_1ST_OP;
                                CMD_READ_2ND_OPERAND:
                                    next_state <= STATE_READ_2ND_OP;
                                CMD_READ_3RD_OPERAND:
                                    next_state <= STATE_READ_3RD_OP;
                                CMD_READ_4TH_OPERAND:
                                    next_state <= STATE_READ_4TH_OP;
                                CMD_READ_5TH_OPERAND:
                                    next_state <= STATE_READ_5TH_OP;
                                CMD_START_MULT:
                                    next_state <= STATE_MULT_START;
                                CMD_START_EXP:
                                    next_state <= STATE_EXP_START;
                                CMD_WRITE_MULT:
                                    next_state <= STATE_WRITE_MULT;
                                CMD_WRITE_EXP:
                                    next_state <= STATE_WRITE_EXP;
                                default:
                                    next_state <= r_state;
                            endcase;
                        end else
                            next_state <= r_state;
                    end
                
                STATE_READ_1ST_OP:
                    //Read the bram_din and store in a1_tmp and a2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_2ND_OP:
                    //Read the bram_din and store in b1_temp and b2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_3RD_OP:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_4TH_OP:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_5TH_OP:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_EXP_START: 
                    //Perform a computation on r_tmp
                    next_state <= STATE_EXP_WAIT;

                STATE_EXP_WAIT:
                    if(!mont_exp_done)
                        next_state <= STATE_EXP_WAIT;
                    else
                        next_state <= STATE_WRITE_PORT2 ;
              
                STATE_MULT_START: 
                    //Perform a computation on r_tmp
                    next_state <= STATE_MULT_WAIT;

                STATE_MULT_WAIT:
                    if(!mont_mult_done)
                        next_state <= STATE_MULT_WAIT;
                    else
                        next_state <= STATE_WRITE_PORT2 ;
                
                STATE_WRITE_EXP:
                    //Write r_tmp to bram_dout
                    next_state <= (bram_dout_read==1'b1) ? STATE_WRITE_PORT2 : r_state;

                STATE_WRITE_MULT:
                    //Write r_tmp to bram_dout
                    next_state <= (bram_dout_read==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_WRITE_PORT2:
                    //Write a 'done' to Port2
                    next_state <= (port2_read==1'b1) ? STATE_WAIT_FOR_CMD : r_state;

                default:
                    next_state <= r_state;
            endcase
        end
    end

    ////////////// - State Update

    always @(posedge(clk))
        if (resetn==1'b0)
            r_state <= STATE_WAIT_FOR_CMD;
        else
            r_state <= next_state;    

    ////////////// - Computation

    reg [511:0] op1_data;
    reg [511:0] op2_data;
    reg [511:0] op3_data;
    reg [511:0] op4_data;
    reg [511:0] op5_data;
    wire [511:0] mult_res_data;
    wire [511:0] exp_res_data;

    reg [511:0] core1_data;

    reg exp_start;
    reg mult_start;

    always @(posedge(clk))
        if (resetn==1'b0)
        begin
            op1_data <= 512'b0;
            op2_data <= 512'b0;
            op3_data <= 512'b0;
            op4_data <= 512'b0;
            op5_data <= 512'b0;
        end
        else
        begin
            case (r_state)
                STATE_READ_1ST_OP: begin
                    if ((bram_din_valid==1'b1)) begin
                        op1_data <= bram_din1;
                    end else begin
                        op1_data <= op1_data; 
                    end
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    core1_data <= core1_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
                STATE_READ_2ND_OP: begin
                    if ((bram_din_valid==1'b1)) begin
                        op2_data <= bram_din1;
                    end else begin
                        op2_data <= op2_data;
                    end
                    op1_data <= op1_data; 
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    core1_data <= core1_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                    
                end
                STATE_READ_3RD_OP: begin
                    if ((bram_din_valid==1'b1)) begin
                        op3_data <= bram_din1;
                    end else begin
                        op3_data <= op3_data;
                    end
                    op1_data <= op1_data;
                    op2_data <= op2_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    core1_data <= core1_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
                STATE_READ_4TH_OP:begin
                    if ((bram_din_valid==1'b1)) begin
                        op4_data <= bram_din1;
                    end else begin
                        op4_data <= op4_data;
                    end
                    op1_data <= op1_data;
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op5_data <= op5_data;
                    core1_data <= core1_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
                STATE_READ_5TH_OP: begin
                    if ((bram_din_valid==1'b1)) begin
                        op5_data <= bram_din1;
                    end else begin
                        op5_data <= op5_data;
                    end
                    op1_data <= op1_data;
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    core1_data <= core1_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
                STATE_EXP_START: begin
                    core1_data <= core1_data;
                    op1_data <= op1_data; 
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    exp_start <= 1'b1;
                    mult_start <= 1'b0;
                end
                STATE_MULT_START: begin
                    core1_data <= core1_data;
                    op1_data <= op1_data; 
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b1;
                end

                STATE_WRITE_EXP: begin
                    core1_data <= exp_res_data;
                    op1_data <= op1_data; 
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end

                STATE_WRITE_MULT: begin
                    core1_data <= mult_res_data;
                    op1_data <= op1_data; 
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
                default: begin
                    core1_data <= core1_data;
                    op1_data <= op1_data; 
                    op2_data <= op2_data;
                    op3_data <= op3_data;
                    op4_data <= op4_data;
                    op5_data <= op5_data;
                    exp_start <= 1'b0;
                    mult_start <= 1'b0;
                end
            endcase;
        end
    
    assign bram_dout1       = core1_data;   
    assign bram_dout2       = 512'b0; 

	montgomery_exp mont_exp(
		clk,
		resetn,
		exp_start,
		op1_data,
		op2_data,
		op3_data,
        op5_data,
        op4_data,
        exp_res_data,
		mont_exp_done
	);

	montgomery mont_mult(
		clk,
		resetn,
		mult_start,
		op1_data,
		op2_data,
		op3_data,
        mult_res_data,
		mont_mult_done
	);

    ////////////// - Valid signals for notifying that the computation is done

    // Computation is done for Core 1
    reg r_bram_dout1_valid;
    always @(posedge(clk))
    begin
        r_bram_dout1_valid <= (r_state==STATE_WRITE_EXP) || (r_state==STATE_WRITE_MULT);
    end

    // Computation is done for Core 2
    reg r_bram_dout2_valid;
    always @(posedge(clk))
    begin
        r_bram_dout2_valid <= (r_state==STATE_WRITE_EXP) || (r_state==STATE_WRITE_MULT);
    end

    assign bram_dout1_valid = r_bram_dout1_valid;
    assign bram_dout2_valid = r_bram_dout2_valid;

    ////////////// - Port handshake
    
    reg r_port2_valid;
    reg r_port1_read;
    always @(posedge(clk))
    begin        
        r_port2_valid      <= (r_state==STATE_WRITE_PORT2);
        r_port1_read       <= ((port1_valid==1'b1) & (r_state==STATE_WAIT_FOR_CMD));
    end
              
    assign port1_read       = r_port1_read;
    assign port2_valid      = r_port2_valid; 

    ////////////// - Debugging signals
    
    // The four LEDs on the board are used as debug signals.
    // Here they are used to check the state transition.

    assign leds             = r_state;    

endmodule
