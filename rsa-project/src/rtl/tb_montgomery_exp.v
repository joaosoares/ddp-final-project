`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_montgomery_exp();
    
    reg          clk;
    reg          resetn;
    reg          start;
    reg  [511:0] in_x;
    reg  [511:0] in_e;
    reg  [511:0] in_m;
    reg  [511:0] in_rmodm;
    reg  [511:0] in_r2modm;
    wire [511:0] result;
    wire         done;

    reg  [511:0] expected;
    reg          result_ok;
    
    //Instantiating montgomery module
    montgomery_exp montgomery_instance( .clk        (clk       ),
                                        .resetn     (resetn    ),
                                        .start      (start     ),
                                        .in_x       (in_x      ),
                                        .in_e       (in_e      ),
                                        .in_m       (in_m      ),
                                        .in_rmodm   (in_rmodm  ),
                                        .in_r2modm  (in_r2modm ),
                                        .result     (result    ),
                                        .done       (done      ));

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

        #`RESET_TIME
        
        // You can generate your own with test vector generator python script
        in_x      <= 512'hb55708a7f2daa5631117b7d03ec4d7992ccad8d7e22d891db1e03e15ad545a33fc9f444b1a16dbae60d527f8f7118db19d65258cb9977527fbfc19786b18ba76;
        in_e      <= 512'hb1;
        in_m      <= 512'hd9bf2caaf3992d7e456563271a7c22da97d772cf8fb8a8d34756a335657daf63eff091961c4ea3c56066c5822baa68d108e9b45d95aa98852b71d44daca7419f;
        in_rmodm  <= 512'h2640d3550c66d281ba9a9cd8e583dd2568288d307047572cb8a95cca9a82509c100f6e69e3b15c3a9f993a7dd455972ef7164ba26a55677ad48e2bb25358be61;
        in_r2modm <= 512'h11b888061a9fa4c1e127abf0cc06521d665d89887d56418d7afdd6a5198ee6b1b91f65e9c6ced5f8c25bbf4ca140c94dbaf69aca2a9d2b8f62af84fbeb9b0420;
        expected  <= 512'h1f5ecf6fd0360d82f945f69d758ee549849318119ff546a3c7c3435fd89b697e244014456e0cae507ad93e76df859e210b611214d3f513ac057f8e27ee3a1fcb;
         
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);
        #`CLK_PERIOD;   
        
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        
        $finish;
    end
           
endmodule