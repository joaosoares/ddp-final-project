`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_montgomery_wrapper#
(
    parameter integer RSA_BITS = 1024
)
(
    );
    
    reg [RSA_BITS-1:0] bram_din;
    reg bram_din_valid;
    wire [RSA_BITS-1:0] bram_dout;
    wire bram_dout_valid;
    reg bram_dout_read;
    reg [31:0] port1_din;
    reg [31:0] port2_dout;    
    reg port1_valid;    
    wire port1_read;   
    wire port2_valid;    
    reg port2_read;
    reg clk;
    reg resetn;
    
    montgomery_wrapper dut(
        .clk(clk),
        .resetn(resetn),
        .bram_din(bram_din),
        .bram_din_valid(bram_din_valid),
        .bram_dout(bram_dout),
        .bram_dout_valid(bram_dout_valid),
        .bram_dout_read(bram_dout_read),
        .port1_din(port1_din),
        .port1_valid(port1_valid),
        .port1_read(port1_read),
        .port2_valid(port2_valid),
        .port2_read(port2_read)
        );
        
    //Generate a clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end
    
    //Reset
    initial begin
        resetn = 0;
        #`RESET_TIME resetn = 1;
    end
    
    task task_bram_read;
    begin
        $display("Read BRAM: %x",bram_dout);
    end
    endtask
    
    task task_bram_write;
    input [1023:0] data;
    begin
        bram_din_valid <= 1;
        bram_din <= data;
        $display("Write BRAM: %x",data);
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
        port2_dout=0;
        $display("P2=%x",port2_dout);
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
        port2_dout=1;
        $display("P2=%x",port2_dout);
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
            wait (bram_dout_valid==1);
            //$display("New data available on BRAM: %x",bram_dout);
            bram_dout_read=1;
            #`CLK_PERIOD;
            #`CLK_PERIOD;
        end
    end
    
    initial begin
            bram_din_valid=0;
            port1_valid=0;
            port1_din=0;
            bram_din=0;
            port2_read=0;
    end
    
    initial begin
        $dumpfile("/tmp/test.lxt2");
        $dumpvars(0,tb_montgomery_wrapper);
        $display("tb_montgomery: START");

        #`RESET_TIME
        #1;

        /**************Do not make any changes to the code above this line*********/
        /* Your task: Design a testbench to test your montgomery_wrapper using port1_write, port2_read, bram_write, and bram_read
        
        /**********************START example command 1*********************/  
        //32'h0 is command that is recognised by montgomery_wrapper. It expects for data to be received from BRAM        
        task_port1_write(32'h0); //Perform CMD_READ
        task_bram_write(1024'h00000000000000000123456789abcdef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);
        task_port2_read(); //Wait for port2_valid to go high.
        
        task_port1_write(32'h1); //Perform CMD_COMPUTE
        task_port2_read(); //Wait for port2_valid to go high.
        
        task_port1_write(32'h2); //Perform CMD_WRITE
        task_port2_read(); //Wait for port2_valid to go high.
        
        task_bram_read();
        /**********************End example command 1*********************/        
        $finish;
    end
endmodule
