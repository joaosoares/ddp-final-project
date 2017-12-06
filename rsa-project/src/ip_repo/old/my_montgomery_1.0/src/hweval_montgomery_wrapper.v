`timescale 1ns / 1ps

module hweval_montgomery_wrapper(
    output wire data_ok,
    input wire clk,
    input wire resetn
    );
       
    localparam integer RSA_BITS = 1024;
    
    reg [RSA_BITS-1:0] bram_din;
    reg bram_din_valid;
    wire [RSA_BITS-1:0] bram_dout;
    wire bram_dout_valid;
    reg bram_dout_read;
    reg [31:0] port1_din;   
    reg port1_valid;    
    wire port1_read;   
    wire port2_valid;    
    reg port2_read;
    
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
        
        always @(posedge(clk))
        begin
            if (resetn==0)
            begin
                bram_din = 1024'h0000FF0000;
                bram_din_valid = 0;
                bram_dout_read = 1;                
                port1_din = 0;
                port1_valid = 0;
                port2_read = 0;
           end
            else
            begin
                bram_din = bram_din ^ {1024{1'b1}};                
                bram_din_valid = bram_din_valid ^ 1;
                bram_dout_read = bram_dout_read ^ 1;
                port1_din = port1_din + 1;
                port1_valid = port1_valid ^ 1;
                port2_read = port2_read ^ 1;
           end
        end
        
        assign data_ok = (bram_dout==1024'h0) & (bram_dout_valid==1);
endmodule
