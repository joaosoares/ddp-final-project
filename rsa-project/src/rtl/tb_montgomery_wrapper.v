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

    reg  [WORD_LEN-1:0] in_X1;
    reg  [WORD_LEN-1:0] in_E1;
    reg  [WORD_LEN-1:0] in_M1;
    reg  [WORD_LEN-1:0] in_RM1;
    reg  [WORD_LEN-1:0] in_R2M1;
    reg  [WORD_LEN-1:0] expected1;
    reg  [WORD_LEN-1:0] in_A2;
    reg  [WORD_LEN-1:0] in_B2;
    reg  [WORD_LEN-1:0] in_M2;
    reg  [WORD_LEN-1:0] in_RM2;
    reg  [WORD_LEN-1:0] in_R2M2;
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

            in_X1     <=  512'hba613daab029ec987185ab23bd854cd8c34ee99887d821fa7c8262e2bb33a083cfdb3b7994980780ccb481abb36f677ecee79148a78c75ff68a3bd803dbc8e33;
            in_E1     <=  512'ha1;
            in_M1     <=  512'h94107f76caedc72da4d0c7bc62c956949f2011b8261107f1c1e3eaf3381097f6996438eebb72821fd6e952bc234ff50277240b71a18da4b5c2e9f4a27842aa65;
            in_RM1    <=  512'h6bef8089351238d25b2f38439d36a96b60dfee47d9eef80e3e1c150cc7ef6809669bc711448d7de02916ad43dcb00afd88dbf48e5e725b4a3d160b5d87bd559b;
            in_R2M1   <=  512'h50142167508d733a84133e763985529207f16523b3eb921c29dd95f3df1783b475442f066fa49c3c893a93b783ac3c965292694efc184a1eb2fdfd6743a24658;
            expected1 <=  512'h18f676d9f128a4568db26eb9aa94d1fbe7f536306b398da66abcda59f42e0684c859772db21d09a26de2b3ec3c205ffb8ed9c146ff83f1da3ae107f5e2ade135;

            in_A2     <=  512'h93839e5e13a37ec8ed23695c461935fc6aba8f0deb9b0072252da300313891824904135ff35393c2f2e60bfdeff3104515066f84dd1e1d87471d68a5d30031dd;
            in_B2     <=  512'h8414503273af1a6d42221f8e862360625fec669daa47aeaf87c66065ced2e45187b04b6aae4da91725abbed34b5a700652093bd78fa8f4cd28c58f08f383ec2a;
            in_M2     <=  512'hdc40c654d33a8e20772d173b05c7394321f7bbba8934652d7bf0e11756774638b6e023287e27c662255be5637460ed16cc2136c4f646821c576b39dae6016875;
            expected2 <=  512'h7bd8d21c2addd679eec5f188121d93b0b16ee0708f399842b3f0953287d209e703769242e3e14cbb5de9f24e77f6e846f3964c148507354557e485fccc292a74;
            
            // in_X2     <=  512'hb455e4ddee1ec40e35a72eb4c7772e0968b0120af8dee2c6cfdc4b3f62ec3ca8d47ed1c44b46826d344fe0b91817f10c427309c5915cd71cdbf5e9d2f8e581bd;
            // in_E2     <=  512'had;
            // in_M2     <=  512'h9a91072ee379bd4bcf1bf8cf36b298dee01297c019d20f279c2369d4569fc3d2eaccb8da37488c74d0db2452286613f4a66f4a9f66e734acb6d374dd397c8171;
            // in_RM2    <=  512'h656ef8d11c8642b430e40730c94d67211fed683fe62df0d863dc962ba9603c2d15334725c8b7738b2f24dbadd799ec0b5990b5609918cb53492c8b22c6837e8f;
            // in_R2M2   <=  512'h5089f1b91253062ffcd73a69849975b38af6d5a4efdde592c04b44dd335a6f20ffb2e024b004be4ac5c9d17e12f484c6cbeebe4d7732c79db9f7ca849f2b578;
            // expected2 <=  512'h13f7976e62510897a202d777e6e3d78781a68542c11b08ce99f2c81ecf4a52c738e22d8b3edf40eb22c1086b03e84f7a8ae3da0ba1f7884df683319951f2c4f9;
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

        // Perform CMD_READ_X1_X2
        task_port1_write(32'h0); 
        // Put the values to bram to be read.
        task_bram_write(in_X1, in_X1);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_E1_E2
        task_port1_write(32'h1); 
        // Put the values to bram to be read.
        task_bram_write(in_E1, in_E1);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_M1_M2
        task_port1_write(32'h2); 
        // Put the values to bram to be read.
        task_bram_write(in_M1, in_M1);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_R2M1_R2M2
        task_port1_write(32'h3); 
        // Put the values to bram to be read.
        task_bram_write(in_R2M1, in_R2M1);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_R2M1_R2M2
        task_port1_write(32'h4); 
        // Put the values to bram to be read.
        task_bram_write(in_RM1, in_RM1);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_EXP
        task_port1_write(32'h5); 
        // Wait for completion of the compute operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_WRITE
        task_port1_write(32'h7);
        // Wait for completion of the write operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Show the values written to the bram
        task_bram_read();

        $display("\n\n");
        ///////////////////// END EXAMPLE  /////////////////////  
        
        // Perform CMD_READ_X1_X2
        task_port1_write(32'h0); 
        // Put the values to bram to be read.
        task_bram_write(in_A2, in_A2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_E1_E2
        task_port1_write(32'h1); 
        // Put the values to bram to be read.
        task_bram_write(in_B2, in_B2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_READ_M1_M2
        task_port1_write(32'h2); 
        // Put the values to bram to be read.
        task_bram_write(in_M2, in_M2);
        // Wait for completion of the read operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 

        // Perform CMD_MULTIPLY
        task_port1_write(32'h6); 
        // Wait for completion of the compute operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Perform CMD_WRITE
        task_port1_write(32'h7);
        // Wait for completion of the write operation
        // by waiting for port2_valid to go high.
        task_port2_read(); 
        
        // Show the values written to the bram
        task_bram_read();

        $display("\n\n");

        $finish;
    end
endmodule