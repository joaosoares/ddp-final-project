`timescale 1ns / 1ps


`define NUM_OF_CORES 2


`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_montgomery_wrapper#
(
    parameter integer WORD_LEN     = 512
)
();
    
    reg                 clk;
    reg                 resetn;
    reg  [WORD_LEN-1:0] bram_din1;
    reg  [WORD_LEN-1:0] bram_din2;
    reg                 bram_din_valid;
    wire [WORD_LEN-1:0] bram_dout1;
    wire [WORD_LEN-1:0] bram_dout2;
    wire                bram_dout1_valid;
    wire                bram_dout2_valid;
    reg                 bram_dout_read;
    reg  [31:0]         port1_din;
    reg                 port1_valid;    
    wire                port1_read;
    wire                port2_valid;    
    reg                 port2_read;
    wire [3:0]          leds;
        
    montgomery_wrapper dut(
        .clk              (clk             ),
        .resetn           (resetn          ),
        .bram_din1        (bram_din1       ),
        .bram_din2        (bram_din2       ),
        .bram_din_valid   (bram_din_valid  ),
        .bram_dout1       (bram_dout1      ),
        .bram_dout2       (bram_dout2      ),
        .bram_dout1_valid (bram_dout1_valid),
        .bram_dout2_valid (bram_dout2_valid),
        .bram_dout_read   (bram_dout_read  ),
        .port1_din        (port1_din       ), 
        .port1_valid      (port1_valid     ),
        .port1_read       (port1_read      ),
        .port2_valid      (port2_valid     ),
        .port2_read       (port2_read      ),
        .leds             (leds            )
        );
        
    // Generate a clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end
    
    // Reset
    initial begin
        resetn = 0;
        #`RESET_TIME resetn = 1;
    end
    
    // Initialise the values to zero
    initial begin
            bram_din1=0;
            bram_din2=0;
            bram_din_valid=0;
            bram_dout_read=0;
            port1_din=0;
            port1_valid=0;
            port2_read=0;
    end

    task task_bram_read;
    begin
        $display("Read BRAM_1 : %x",bram_dout1);
        if (`NUM_OF_CORES==2)
            $display("Read BRAM_2 : %x",bram_dout2);
    end
    endtask
    
    task task_bram_write;
    input [WORD_LEN-1:0] data1;
    input [WORD_LEN-1:0] data2;
    begin
        bram_din_valid <= 1;
        bram_din1 <= data1;
        $display("Write BRAM_1: %x",data1);
        if (`NUM_OF_CORES==2) begin
            bram_din2 <= data2;
            $display("Write BRAM_2: %x",data2);
        end        
        #`CLK_PERIOD;
        bram_din_valid <= 0;
    end
    endtask

    task task_port1_write;
    input [31:0] data;
    begin
        $display("P1=%x",data);
        port1_din=data;
        port1_valid=1;
        #`CLK_PERIOD;
        wait (port1_read==1);        
        port1_valid=0;
        #`CLK_PERIOD;
    end
    endtask
    
    task task_port2_read;
    begin
        port2_read=0;
        wait (port2_valid==1);
        port2_read=1;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        port2_read=0;
    end
    endtask
    
    initial begin
        forever
        begin
            bram_dout_read=0;
            if (`NUM_OF_CORES==1)    
                wait (bram_dout1_valid==1);
            else
                wait (bram_dout1_valid==1 && bram_dout2_valid==1);
            bram_dout_read=1;
            #`CLK_PERIOD;
            #`CLK_PERIOD;
        end
    end
    
    
    initial begin

        #`RESET_TIME
        #1;

        // Your task: 
        // Design a testbench to test your montgomery_wrapper 
        // using the tasks defined above: port1_write, port2_read, 
        // bram_write, and bram_read
        
        ///////////////////// START EXAMPLE  /////////////////////
        
        $display("\n\nSIMULATING with NUM_OF_CORES=%x",`NUM_OF_CORES);

        // Perform CMD_READ
        task_port1_write(32'h0); 

        // Put the values to bram to be read.
        task_bram_write( 
            512'h00000000000000000123456789abcdef000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
            512'h00000000000000000fedcba987654321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);
        
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_COMPUTE
        task_port1_write(32'h1); 
        
        // Wait for completion of the compute operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_WRITE
        task_port1_write(32'h2);

        // Wait for completion of the write operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Show the values written to the bram
        task_bram_read();

        $display("\n\n");
        ///////////////////// END EXAMPLE  /////////////////////  
        
        $finish;
    end
endmodule