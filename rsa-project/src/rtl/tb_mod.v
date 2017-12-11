`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_mod();
    
    reg          clk;
    reg          resetn;
    reg          start;
    reg  [511:0] in_a;
    reg  [511:0] in_n;
    wire [511:0] result;
    wire         done;

    reg  [511:0] expected;
    reg          result_ok;
    
    //Instantiating montgomery module
    mod mod_instance( .clk    (clk    ),
                                        .resetn (resetn ),
                                        .start  (start  ),
                                        .in_a   (in_a   ),
                                        .in_n   (in_n   ),
                                        .result (result ),
                                        .done   (done   ));

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
        in_a     <= 512'hf59b616f4026145c9523c601567ab75c920002e59a5e3385d77c05dba137b0a3657a23da39ac57cc8884d23a01fb24c6f4d93bad497ce2247ee5ea907e3e0765;
        in_n     <= 512'h9b524c36e3d2fd92b935c6082478574be7cc66dd17cbb37d4a4155a21613505cae6ace3bd697f929552b593a51f2ee77ae139a6ec6d61ca58cf7f64ff2e3c663;
        expected <= 512'h5a4915385c5316c9dbedfff932026010aa339c08829280088d3ab0398b246046b70f559e63145ea3335978ffb008364f46c5a13e82a6c57ef1edf4408b5a4102;
         
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