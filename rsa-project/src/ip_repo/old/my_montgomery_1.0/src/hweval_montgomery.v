`timescale 1ns / 1ps

module hweval_montgomery(
    output wire data_ok,
    input wire clk,
    input wire resetn
    );
    
    reg resetn;
    reg start;
    reg [1023:0] in_a, in_b, in_m;
    wire [1023:0] result;
    wire done;
    
    //Instantiating montgomery module
    montgomery montgomery_instance
           (.clk(clk),
            .resetn(resetn),
            .start(start),
            .in_a(in_a),
            .in_b(in_b),
            .in_m(in_m),
            .result(result),
            .done(done)
            );
            
            always @(posedge(clk))
            begin
                if (resetn==0)
                begin
                    in_a = 1024'h0000FF0000;
                    in_b = 1024'h0FF0000000;
                    in_m = 1024'h0000000FF0;
                    resetn = 0;
                    start = 0;
               end
                else
                begin
                    resetn = 1;
                    start = start ^ 1;
                    in_a = in_a ^ {1024{1'b1}};
                    in_b = in_b ^ {1024{1'b1}};
                    in_m = in_m ^ {1024{1'b1}};
               end
            end
            
            assign data_ok = (done) & (result==1024'h0);
endmodule
