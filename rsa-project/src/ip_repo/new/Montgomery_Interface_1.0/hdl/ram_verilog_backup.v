`timescale 1ns / 1ps
module ram_verilog #
(
    parameter integer BRAM_ADDR_WIDTH       = 10,
    parameter integer NUM_OF_CORES          = 1
)
(
    input                           clk,        // Clock Input
    input                           resetn,     // Synchronous reset
    input  [BRAM_ADDR_WIDTH-1:0]    addra,      // Address Input
    input  [31:0]                   dina,       // Data bi-directional
    input                           wea,        // Write Enable
    input  [(NUM_OF_CORES*512)-1:0] dinb,       // Data input in parallel
    output                          dinb_read,  // Indicates that dinb has been processed
    input                           web,        // Write enable in portb
    output [(NUM_OF_CORES*512)-1:0] doutb,      // Data output for reading
    output                          doutb_valid
);

// reg [31:0] mem [0:31];
reg [31:0] mem [0:(NUM_OF_CORES*16)-1];

reg r_dinb_read;
always @ (posedge clk)
begin
    if (wea)
    begin
       mem[addra/4] <= dina;
       r_dinb_read <= 0;
    end
    else if(web)
    begin
        if (NUM_OF_CORES == 1)
            {mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
             mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]} <= dinb;
        else
            {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],
             mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],
             mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
             mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]} <= dinb;
        r_dinb_read <= 1;
    end
    else
        r_dinb_read <= 0;
end
assign dinb_read = r_dinb_read;


//Assume that the data is written from address zero to the maximum address
//doutb_valid is high after the highest value is written
reg r_doutb_valid;
always @ (posedge clk)
begin
    if (resetn==1'b0)
        r_doutb_valid <= 1'b0;
    else
    begin
        if (wea & (addra==(((NUM_OF_CORES*16)-1)*4)))
        begin
            r_doutb_valid <= 1'b1;
        end
        else
        begin
            r_doutb_valid <= 1'b0;
        end
    end
end

assign doutb_valid = r_doutb_valid;

assign doutb = (NUM_OF_CORES == 1) ?
    {mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
     mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]}:
    {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],
     mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],
     mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
     mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]};

endmodule