`timescale 1ns / 1ps
module ram_verilog #
(
    parameter integer BRAM_ADDR_WIDTH       = 10,
    parameter integer NUM_OF_CORES          = 1
)
(
    input                        clk,          // Clock Input
    input                        resetn,       // Synchronous reset

    input  [BRAM_ADDR_WIDTH-1:0] addr_sw,      // Address Input
    input  [31:0]                din_sw,       // Data bi-directional
    input                        we_sw,        // Write Enable

    input  [511:0]               din_hw1,      // Data input in parallel
    input  [511:0]               din_hw2,      // Data input in parallel
    output                       din_hw_read,  // Indicates that din_hw has been processed
    input                        we_hw1,       // Write enable in portb
    input                        we_hw2,       // Write enable in portb
    output [511:0]               dout_hw1,     // Data output for reading
    output [511:0]               dout_hw2,     // Data output for reading
    output                       dout_hw_valid
);

reg [31:0] mem [0:31];

reg r_din_hw_read;

always @ (posedge clk)
begin
    if (we_sw) begin
       mem[addr_sw/4] <= din_sw;
       r_din_hw_read <= 0;
    end
    else if(we_hw1 & NUM_OF_CORES == 1) begin
        {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],
         mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],
         mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
         mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]} <= {512'h0 , din_hw1};
        r_din_hw_read <= 1;
    end
    else if(we_hw1 & we_hw2 & NUM_OF_CORES == 2) begin    
        {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],
         mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],
         mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
         mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]} <= {din_hw2 , din_hw1};
        r_din_hw_read <= 1;
    end
    else
        r_din_hw_read <= 0;
end
assign din_hw_read = r_din_hw_read;


//Assume that the data is written from address zero to the maximum address
//dout_hw_valid is high after the highest value is written
reg r_dout_hw_valid;

always @ (posedge clk)
begin
    if (resetn==1'b0)
        r_dout_hw_valid <= 1'b0;
    else
    begin
        if (we_sw & (addr_sw==(((NUM_OF_CORES*16)-1)*4)))
        begin
            r_dout_hw_valid <= 1'b1;
        end
        else
        begin
            r_dout_hw_valid <= 1'b0;
        end
    end
end

assign dout_hw_valid = r_dout_hw_valid;

assign dout_hw1 =  {mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[ 9],mem[ 8],
                    mem[ 7],mem[ 6],mem[ 5],mem[ 4],mem[ 3],mem[ 2],mem[ 1],mem[ 0]};

assign dout_hw2 = (NUM_OF_CORES == 1) ? 512'h0 :
                   {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],
                    mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16]};

endmodule