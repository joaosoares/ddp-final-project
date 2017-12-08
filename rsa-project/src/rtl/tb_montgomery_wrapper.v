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

    reg  [WORD_LEN-1:0] in_A1;
    reg  [WORD_LEN-1:0] in_B1;
    reg  [WORD_LEN-1:0] in_M1;
    reg  [WORD_LEN-1:0] expected1;
    reg  [WORD_LEN-1:0] in_A2;
    reg  [WORD_LEN-1:0] in_B2;
    reg  [WORD_LEN-1:0] in_M2;
    reg  [WORD_LEN-1:0] expected2;
        
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

            in_A1     <=  512'h93839e5e13a37ec8ed23695c461935fc6aba8f0deb9b0072252da300313891824904135ff35393c2f2e60bfdeff3104515066f84dd1e1d87471d68a5d30031dd;
            in_B1     <=  512'h8414503273af1a6d42221f8e862360625fec669daa47aeaf87c66065ced2e45187b04b6aae4da91725abbed34b5a700652093bd78fa8f4cd28c58f08f383ec2a;
            in_M1     <=  512'hdc40c654d33a8e20772d173b05c7394321f7bbba8934652d7bf0e11756774638b6e023287e27c662255be5637460ed16cc2136c4f646821c576b39dae6016875;
            expected1 <=  512'h7bd8d21c2addd679eec5f188121d93b0b16ee0708f399842b3f0953287d209e703769242e3e14cbb5de9f24e77f6e846f3964c148507354557e485fccc292a74;


            in_A2     <=  512'hd172d670ad0261812640142589728768c618fc9ca474753caa8717e206166f0b49050c814d3dd9a21bc07d6ddfe302045b9fee73e6c0d86e11f43bd2f9749ed0;
            in_B2     <=  512'h87dec1dfd0da7e8a6ca7103fec172371212d332b031ceac1366f8e000fcad4f774bcd153912ad5149f5369cd1bd2345e40434c34241cfb871d8d2eb87c88daa3;
            in_M2     <=  512'ha4d387875d4ad037c6943d25228e11fc40c2c3a32fcaad4cf36e11315dd9a071f445a3125572cb2fc5a3a9fefecde8ad5cf00dee391b1fa324aea1abc86b673d;
            expected2 <=  512'h92c8540b95a0504d65f8fc6845e441782d77bfbde1880b0e833f5e6b25515b51842725d3748e28ae5d3f76f1eac2d026a17433b6f5ff880343da5e2ea49aa186;
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

        // Perform CMD_READ_A1_A2
        task_port1_write(32'h0); 
        // Put the values to bram to be read.
        task_bram_write(in_A1, in_A2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_B1_B2
        task_port1_write(32'h1); 
        // Put the values to bram to be read.
        task_bram_write(in_B1, in_B2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_M1_M2
        task_port1_write(32'h2); 
        // Put the values to bram to be read.
        task_bram_write(in_M1, in_M2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_MULTIPLY
        task_port1_write(32'h3); 
        // Wait for completion of the compute operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_WRITE
        task_port1_write(32'h4);
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