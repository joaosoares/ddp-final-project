`timescale 1ns / 1ps

module hweval_montgomery_wrapper#
(
    parameter integer WORD_LEN     = 512
)
(
    output wire data_ok,
    input wire clk,
    input wire resetn
);
    
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
        
    montgomery_wrapper montgomery_wrapper_instance(
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
        
    always @(posedge(clk))
    begin
        if (resetn==0) begin
            bram_din1       = 512'h0000FF0000;
            bram_din2       = 512'h0000FF0000;
            bram_din_valid  = 0;
            bram_dout_read  = 1;                
            port1_din       = 0;
            port1_valid     = 0;
            port2_read      = 0;
        end
        else begin
            bram_din1       = bram_din1      << 1;
            bram_din2       = bram_din2      << 1;
            bram_din_valid  = bram_din_valid ^  1;
            bram_dout_read  = bram_dout_read ^  1;
            port1_din       = port1_din      +  1;
            port1_valid     = port1_valid    ^  1;
            port2_read      = port2_read     ^  1;
        end
    end
    
    assign data_ok = (
                        (bram_dout1==512'h0) |
                        (bram_dout2==512'h0) 
                     )
                     & 
                     (
                        bram_dout1_valid | 
                        bram_dout2_valid | 
                        port1_read       | 
                        port2_valid
                     );
endmodule
