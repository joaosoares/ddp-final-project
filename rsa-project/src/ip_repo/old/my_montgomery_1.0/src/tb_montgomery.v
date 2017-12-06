`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_montgomery(   
    );
    
    reg clk,resetn;
    reg [1023:0] in_a, in_b, in_m;
    reg start;
    wire [1023:0] result;
    wire done;
    
    //Instantiating montgomery module
    montgomery montgomery_instance
           (.clk(clk),
            .resetn(resetn),
            .in_a(in_a),
            .in_b(in_b),
            .in_m(in_m),
            .start(start),
            .result(result),
            .done(done)
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
    
    //Test data
    initial begin
        $dumpfile("/tmp/test.lxt2");
        $dumpvars(0,tb_montgomery);
        $display("tb_montgomery: START");

        #`RESET_TIME
        
        //First test vector:
        in_a<=1024'h1;
        in_b<=1024'h2;
        in_m<=1024'h3;
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        wait (done==1);
        $display("result=%x",result);
        #`CLK_PERIOD;
        
        //Second test vector:
        //The test vector that was given in mtgo1024.c on Toledo
        in_a<=1024'h1BA;
        in_b<=1024'h91B;
        in_m<=1024'hD1D3B4D60ED3982C36A53DD9CFB0450E6887926D199AF8FEE7990185F907210129AB96B24F2E543827028A894DA058EC2DAAE084358E7C2456BA1EB0CF1AE468093C99331D501EA97F89EBB5E1709725DC771F4293ADE44605453C47716A5C3B8E88E8CF2ADE1186BE08BC1E2AB9A7C832DFF4023B9E66F8A677BCE5E67A6F31;
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        wait (done==1);
        $display("result=%x",result);
        #`CLK_PERIOD;
        $finish;
    end
           
endmodule
