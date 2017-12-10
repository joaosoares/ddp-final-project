`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2017 05:43:49 PM
// Design Name: 
// Module Name: mod
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mod(
    input clk,
    input resetn,
    input start,
    input [512:0] a,
    input [512:0] n,
    output [512:0] res,
    input done
    );

    reg [2:0] state, nextstate,

    // Declare states
    parameter START = 0,
    SUB_START = 1,
    SUB_WAIT = 2,
    COMPARE = 3,
    DONE = 4;

    // Datapath control in signals
    wire sub_done;

    // Datapath control out signals
    reg start_sub;

    // Control out signals logic
    always @(*)
    begin
        case(state)
            START: begin
                start_sub <= 1'b1;
            end
            default: begin
                start_sub <= 1'b0;
            end
        endcase
    end

    // Next state logic
    always @(*) begin
        case(state)
            START: begin
                if (start)
                    nextstate <= COMPARE;


endmodule
