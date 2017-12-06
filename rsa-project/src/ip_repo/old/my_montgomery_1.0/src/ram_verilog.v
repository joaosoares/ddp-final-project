`timescale 1ns / 1ps
module ram_verilog #
(
    parameter integer BRAM_ADDR_WIDTH       = 10,
    parameter integer BRAM_WORD_COUNT       = 32
)
(
    input clk,                          // Clock Input
    input resetn,                       // Synchronous reset
    input [BRAM_ADDR_WIDTH-1:0] addra,  // Address Input
    input [31:0] dina,                  // Data bi-directional
    input wea,                          // Write Enable
    input [4095:0] dinb,                // 4096 bit data input in parallel
    output dinb_read,                   // Indicates that dinb has been processed
    input web,                          // Write enable in portb
    output [4095:0] doutb,              // 4096 bit data output for reading
    output doutb_valid
);
//
//reg [31:0] mem [0:127];
reg [31:0] mem [0:31];

always @ (posedge clk)
begin
    if (wea)
    begin
       mem[addra/4] <= dina;
       r_dinb_read <= 0;
    end
    else if(web)
    begin
//        {mem[127],mem[126],mem[125],mem[124],mem[123],mem[122],mem[121],mem[120],mem[119],mem[118],mem[117],mem[116],mem[115],mem[114],mem[113],mem[112],mem[111],mem[110],mem[109],mem[108],mem[107],mem[106],mem[105],mem[104],mem[103],mem[102],mem[101],mem[100],mem[99],mem[98],mem[97],mem[96],mem[95],mem[94],mem[93],mem[92],mem[91],mem[90],mem[89],mem[88],mem[87],mem[86],mem[85],mem[84],mem[83],mem[82],mem[81],mem[80],mem[79],mem[78],mem[77],mem[76],mem[75],mem[74],mem[73],mem[72],mem[71],mem[70],mem[69],mem[68],mem[67],mem[66],mem[65],mem[64],mem[63],mem[62],mem[61],mem[60],mem[59],mem[58],mem[57],mem[56],mem[55],mem[54],mem[53],mem[52],mem[51],mem[50],mem[49],mem[48],mem[47],mem[46],mem[45],mem[44],mem[43],mem[42],mem[41],mem[40],mem[39],mem[38],mem[37],mem[36],mem[35],mem[34],mem[33],mem[32],mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8],mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]} <= dinb;
        {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8],mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]} <= dinb;
        r_dinb_read <= 1;
    end
    else
        r_dinb_read <= 0;
end
reg r_dinb_read;
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
        if (wea & (addra==((BRAM_WORD_COUNT-1)*4)))
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

/*
assign doutb = 
{mem[127],mem[126],mem[125],mem[124],mem[123],mem[122],mem[121],mem[120],mem[119],mem[118],mem[117],mem[116],
mem[115],mem[114],mem[113],mem[112],mem[111],mem[110],mem[109],mem[108],mem[107],mem[106],mem[105],mem[104],
mem[103],mem[102],mem[101],mem[100],mem[99],mem[98],mem[97],mem[96],mem[95],mem[94],mem[93],mem[92],mem[91],
mem[90],mem[89],mem[88],mem[87],mem[86],mem[85],mem[84],mem[83],mem[82],mem[81],mem[80],mem[79],mem[78],
mem[77],mem[76],mem[75],mem[74],mem[73],mem[72],mem[71],mem[70],mem[69],mem[68],mem[67],mem[66],mem[65],mem[64],
mem[63],mem[62],mem[61],mem[60],mem[59],mem[58],mem[57],mem[56],mem[55],mem[54],mem[53],mem[52],mem[51],mem[50],
mem[49],mem[48],mem[47],mem[46],mem[45],mem[44],mem[43],mem[42],mem[41],mem[40],mem[39],mem[38],mem[37],mem[36],
mem[35],mem[34],mem[33],mem[32],mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],mem[23],mem[22],
mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8],
mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]};
*/

assign doutb = 
{mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],mem[23],mem[22],
mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8],
mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]};
endmodule