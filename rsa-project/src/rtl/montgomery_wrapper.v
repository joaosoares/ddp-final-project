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
    localparam STATE_READ_X1_X2     = 4'd2;
    localparam STATE_READ_E1_E2     = 4'd3;
    localparam STATE_READ_M1_M2     = 4'd4;
    localparam STATE_READ_R2M1_R2M2 = 4'd5;
    localparam STATE_READ_RM1_RM2   = 4'd6;
    localparam STATE_WRITE_RESULTS  = 4'd7;
    localparam STATE_WRITE_PORT2    = 4'd8;
    localparam STATE_EXP_START      = 4'd9;
    localparam STATE_EXP_WAIT       = 4'd10;

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ_X1_X2       = 32'h0;
    localparam CMD_READ_E1_E2       = 32'h1;
    localparam CMD_READ_M1_M2       = 32'h2;
    localparam CMD_READ_R2M1_R2M2   = 32'h3;
    localparam CMD_READ_RM1_RM2     = 32'h4;
    localparam CMD_EXP_START        = 32'h5;    
    localparam CMD_WRITE            = 32'h6;


    wire mont1_done;
    wire mont2_done;


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
                                CMD_READ_X1_X2:
                                    next_state <= STATE_READ_X1_X2;
                                CMD_READ_E1_E2:
                                    next_state <= STATE_READ_E1_E2;
                                CMD_READ_M1_M2:
                                    next_state <= STATE_READ_M1_M2;
                                CMD_READ_R2M1_R2M2:
                                    next_state <= STATE_READ_R2M1_R2M2;
                                CMD_READ_RM1_RM2:
                                    next_state <= STATE_READ_RM1_RM2;
                                CMD_EXP_START:                            
                                    next_state <= STATE_EXP_START;                                
                                CMD_WRITE:
                                    next_state <= STATE_WRITE_RESULTS;
                                default:
                                    next_state <= r_state;
                            endcase;
                        end else
                            next_state <= r_state;
                    end
                
                STATE_READ_X1_X2:
                    //Read the bram_din and store in a1_tmp and a2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_E1_E2:
                    //Read the bram_din and store in b1_temp and b2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_M1_M2:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_RM1_RM2:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_READ_R2M1_R2M2:
                    //Read the bram_din and store in m1_temp and m2_temp
                    next_state <= (bram_din_valid==1'b1) ? STATE_WRITE_PORT2 : r_state;
                
                STATE_EXP_START: 
                    //Perform a computation on r_tmp
                    next_state <= STATE_EXP_WAIT;

                STATE_EXP_WAIT:
                    if(!mont1_done || !mont2_done)
                        next_state <= STATE_EXP_WAIT;
                    else
                        next_state <= STATE_WRITE_PORT2 ;
                
                STATE_WRITE_RESULTS:
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

    reg [511:0] x1_data;
    reg [511:0] x2_data;

    reg [511:0] e1_data;
    reg [511:0] e2_data;

    reg [511:0] m1_data;
    reg [511:0] m2_data;

    reg [511:0] r2m1_data;
    reg [511:0] r2m2_data;

    reg [511:0] rm1_data;
    reg [511:0] rm2_data;

    wire [511:0] res1_data;
    wire [511:0] res2_data;

    reg [511:0] core1_data;
    reg [511:0] core2_data;

    reg exp_start;

    always @(posedge(clk))
        if (resetn==1'b0)
        begin
            x1_data <= 512'b0;
            x2_data <= 512'b0;
            e1_data <= 512'b0;
            e2_data <= 512'b0;
            m1_data <= 512'b0;
            m2_data <= 512'b0;
            r2m1_data <= 512'b0;
            r2m2_data <= 512'b0;
            rm1_data <= 512'b0;
            rm2_data <= 512'b0;
        end
        else
        begin
            case (r_state)
                STATE_READ_X1_X2: begin
                    if ((bram_din_valid==1'b1)) begin
                        x1_data <= bram_din1;
                        x2_data <= bram_din2;
                    end else begin
                        x1_data <= x1_data; 
                        x2_data <= x2_data; 
                    end
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    exp_start <= 1'b0;
                end
                STATE_READ_E1_E2: begin
                    if ((bram_din_valid==1'b1)) begin
                        e1_data <= bram_din1;
                        e2_data <= bram_din2;
                    end else begin
                        e1_data <= e1_data;
                        e2_data <= e2_data;
                    end
                    x1_data <= x1_data; 
                    x2_data <= x2_data; 
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    exp_start <= 1'b0;
                    
                end
                STATE_READ_M1_M2:begin
                    if ((bram_din_valid==1'b1)) begin
                        m1_data <= bram_din1;
                        m2_data <= bram_din2;
                    end else begin
                        m1_data <= m1_data;
                        m2_data <= m2_data;
                    end
                    x1_data <= x1_data;
                    x2_data <= x2_data;
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    exp_start <= 1'b0;
                end
                STATE_READ_R2M1_R2M2:begin
                    if ((bram_din_valid==1'b1)) begin
                        r2m1_data <= bram_din1;
                        r2m2_data <= bram_din2;
                    end else begin
                        r2m1_data <= r2m1_data;
                        r2m2_data <= r2m2_data;
                    end
                    x1_data <= x1_data;
                    x2_data <= x2_data;
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    exp_start <= 1'b0;
                end
                STATE_READ_RM1_RM2: begin
                    if ((bram_din_valid==1'b1)) begin
                        rm1_data <= bram_din1;
                        rm2_data <= bram_din2;
                    end else begin
                        rm1_data <= rm1_data;
                        rm2_data <= rm2_data;
                    end
                    x1_data <= x1_data;
                    x2_data <= x2_data;
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    exp_start <= 1'b0;
                end
                STATE_EXP_START: begin
                    core1_data <= res1_data;
                    core2_data <= res2_data;
                    x1_data <= x1_data; 
                    x2_data <= x2_data; 
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    exp_start <= 1'b1;
                end

                STATE_WRITE_RESULTS: begin
                    core1_data <= res1_data;
                    core2_data <= res2_data;
                    x1_data <= x1_data; 
                    x2_data <= x2_data; 
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    exp_start <= 1'b0;
                end
                default: begin
                    core1_data <= core1_data;
                    core2_data <= core2_data;
                    x1_data <= x1_data; 
                    x2_data <= x2_data; 
                    e1_data <= e1_data;
                    e2_data <= e2_data;
                    m1_data <= m1_data;
                    m2_data <= m2_data;
                    r2m1_data <= r2m1_data;
                    r2m2_data <= r2m2_data;
                    rm1_data <= rm1_data;
                    rm2_data <= rm2_data;
                    exp_start <= 1'b0;
                end
            endcase;
        end
    
    assign bram_dout1       = core1_data;   
    assign bram_dout2       = core2_data; 

	montgomery_exp mont1(
		clk,
		resetn,
		exp_start,
		x1_data,
		e1_data,
		m1_data,
        rm1_data,
        r2m1_data,
        res1_data,
		mont1_done
	);

	montgomery_exp mont2(
		clk,
		resetn,
		exp_start,
		x2_data,
		e2_data,
		m2_data,
        rm2_data,
        r2m2_data,
        res2_data,
		mont2_done
	);

    ////////////// - Valid signals for notifying that the computation is done

    // Computation is done for Core 1
    reg r_bram_dout1_valid;
    always @(posedge(clk))
    begin
        r_bram_dout1_valid <= (r_state==STATE_WRITE_RESULTS);
    end

    // Computation is done for Core 2
    reg r_bram_dout2_valid;
    always @(posedge(clk))
    begin
        r_bram_dout2_valid <= (r_state==STATE_WRITE_RESULTS);
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
