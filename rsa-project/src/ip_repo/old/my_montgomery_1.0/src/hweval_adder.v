`timescale 1ns / 1ps

module hweval_adder(
    output data_ok,
    input clk,
    input resetn
);

    reg [1024:0] in_a;
    reg [1024:0] in_b;
    reg subtract;
    reg start;
    reg shift;
    wire [1025:0] result;
    wire done;
   
    //Instantiate the adder    
    adder dut
       (.clk(clk),
        .resetn(resetn),
        .start(start),
        .in_a(in_a),
        .in_b(in_b),
        .shift(shift),
        .subtract(subtract),
        .result(result),
        .done(done)
        );

    //Assign values to the inputs to the adder
    always @(posedge(clk))
    begin
        if (resetn==0)
        begin
            in_a <= 0;
            in_b <= 0;
            start <= 0;
            subtract <= 0;
            shift <= 0;
        end
        else
        begin
            in_a <= in_a ^ {1025{1'b1}};
            in_b <= in_b ^ {1025{1'b1}};
            start <= start ^ 1;
            subtract <= subtract ^ 1;
            shift <= shift ^ 1;
        end
    end
    
    assign data_ok = done & (result=={1025{1'b0}});
    
endmodule
