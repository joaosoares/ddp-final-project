
`timescale 1 ns / 1 ps

	module my_montgomery_v1_0 #
	(
		// Parameters of Axi Slave Bus Interface S00_AXI
        parameter integer C_S00_AXI_ID_WIDTH        = 1,
        parameter integer C_S00_AXI_DATA_WIDTH      = 32,
        parameter integer C_S00_AXI_ADDR_WIDTH      = 32,
        parameter integer C_S00_AXI_AWUSER_WIDTH    = 0,
        parameter integer C_S00_AXI_ARUSER_WIDTH    = 0,
        parameter integer C_S00_AXI_WUSER_WIDTH     = 0,
        parameter integer C_S00_AXI_RUSER_WIDTH     = 0,
        parameter integer C_S00_AXI_BUSER_WIDTH     = 0,
        
        // Parameters of Axi Slave Bus Interface S01_AXI
        parameter integer C_S01_AXI_ID_WIDTH    = 1,
        parameter integer C_S01_AXI_DATA_WIDTH    = 32,
        parameter integer C_S01_AXI_ADDR_WIDTH    = 32,
        parameter integer C_S01_AXI_AWUSER_WIDTH    = 0,
        parameter integer C_S01_AXI_ARUSER_WIDTH    = 0,
        parameter integer C_S01_AXI_WUSER_WIDTH    = 0,
        parameter integer C_S01_AXI_RUSER_WIDTH    = 0,
        parameter integer C_S01_AXI_BUSER_WIDTH    = 0,
        
        parameter integer BRAM_ADDR_WIDTH           = 10,
        parameter integer BRAM_DATA_WIDTH           = 32,
        parameter integer BRAM_WORD_COUNT           = 32,        
        parameter integer BRAM_CLK_LATENCY          = 1,
        parameter integer REG_DATA_WIDTH            = 1024
    )
	(
	
	input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire [2 : 0] s00_axi_awprot,
    input wire  s00_axi_awvalid,
    output wire  s00_axi_awready,
    input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire  s00_axi_wvalid,
    output wire  s00_axi_wready,
    output wire [1 : 0] s00_axi_bresp,
    output wire  s00_axi_bvalid,
    input wire  s00_axi_bready,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire [2 : 0] s00_axi_arprot,
    input wire  s00_axi_arvalid,
    output wire  s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire  s00_axi_rvalid,
    input wire  s00_axi_rready,
            
    input wire  s01_axi_aclk,
    input wire  s01_axi_aresetn,
    input wire [C_S01_AXI_ADDR_WIDTH-1 : 0] s01_axi_awaddr,
    input wire [2 : 0] s01_axi_awprot,
    input wire  s01_axi_awvalid,
    output wire  s01_axi_awready,
    input wire [C_S01_AXI_DATA_WIDTH-1 : 0] s01_axi_wdata,
    input wire [(C_S01_AXI_DATA_WIDTH/8)-1 : 0] s01_axi_wstrb,
    input wire  s01_axi_wvalid,
    output wire  s01_axi_wready,
    output wire [1 : 0] s01_axi_bresp,
    output wire  s01_axi_bvalid,
    input wire  s01_axi_bready,
    input wire [C_S01_AXI_ADDR_WIDTH-1 : 0] s01_axi_araddr,
    input wire [2 : 0] s01_axi_arprot,
    input wire  s01_axi_arvalid,
    output wire  s01_axi_arready,
    output wire [C_S01_AXI_DATA_WIDTH-1 : 0] s01_axi_rdata,
    output wire [1 : 0] s01_axi_rresp,
    output wire  s01_axi_rvalid,
    input wire  s01_axi_rready,
    
    //BRAM interface
    input [BRAM_ADDR_WIDTH-1:0] bram_addr,
    input [BRAM_DATA_WIDTH-1:0] bram_din,
    output [BRAM_DATA_WIDTH-1:0] bram_dout,
    input bram_we,
    
    //output bram_clk,
    input bram_en,
    
    output wire [1023:0] bram_din2,
    output wire bram_din_valid,
    input wire [1023:0] bram_dout2,
    input wire bram_dout_valid,
    output wire bram_dout_read,
    output wire [31:0] port1_din,
    output wire port1_valid,
    input wire port1_read,
    input wire port2_valid, 
    output wire port2_read
	);
  
//    localparam integer RSA_BITS = 1024;
  
    /*****************These signals are connected to montgomery_wrapper*******************/
    wire [REG_DATA_WIDTH-1:0] data_in;
    wire [REG_DATA_WIDTH-1:0] data_out;
    wire data_out_valid;
    wire data_in_valid;

    wire [31:0] port1_data;
    wire port1_data_valid;
    wire port1_data_read;
    //wire [31:0] port2_data;
    wire port2_data_valid;
    wire port2_data_read;
    assign bram_dout = 0;
    
    assign bram_din2 = data_in;
    assign bram_din_valid = data_in_valid;
    assign bram_dout2 = data_out;
    assign bram_dout_valid = data_out_valid;
    assign bram_dout_read = data_out_read;
    assign port1_din = port1_data;
    assign port1_valid = port1_data_valid;
    assign port1_read = port1_data_read;
    assign port2_valid = port2_data_valid;
    assign port2_read = port2_data_read;

// Instantiation of Axi Bus Interface S00_AXI
	my_montgomery_port_slave_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myip_port_slave_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
        .PORT1_DATA(port1_data),
        .PORT1_DATA_VALID(port1_data_valid),
        .PORT1_DATA_READ(port1_data_read),
        //.PORT2_DATA(port2_data),
        .PORT2_DATA_VALID(port2_data_valid),
        .PORT2_DATA_READ(port2_data_read)
	);
	
	myip_axilite_data_slave # ( 
            .C_S_AXI_DATA_WIDTH(C_S01_AXI_DATA_WIDTH),
            .C_S_AXI_ADDR_WIDTH(C_S01_AXI_ADDR_WIDTH),
            .REG_DATA_WIDTH(REG_DATA_WIDTH)
    ) myip_data_slave_inst (
            .S_AXI_ACLK(s01_axi_aclk),
            .S_AXI_ARESETN(s01_axi_aresetn),
            .S_AXI_AWADDR(s01_axi_awaddr),
            .S_AXI_AWPROT(s01_axi_awprot),
            .S_AXI_AWVALID(s01_axi_awvalid),
            .S_AXI_AWREADY(s01_axi_awready),
            .S_AXI_WDATA(s01_axi_wdata),
            .S_AXI_WSTRB(s01_axi_wstrb),
            .S_AXI_WVALID(s01_axi_wvalid),
            .S_AXI_WREADY(s01_axi_wready),
            .S_AXI_BRESP(s01_axi_bresp),
            .S_AXI_BVALID(s01_axi_bvalid),
            .S_AXI_BREADY(s01_axi_bready),
            .S_AXI_ARADDR(s01_axi_araddr),
            .S_AXI_ARPROT(s01_axi_arprot),
            .S_AXI_ARVALID(s01_axi_arvalid),
            .S_AXI_ARREADY(s01_axi_arready),
            .S_AXI_RDATA(s01_axi_rdata),
            .S_AXI_RRESP(s01_axi_rresp),
            .S_AXI_RVALID(s01_axi_rvalid),
            .S_AXI_RREADY(s01_axi_rready),
            .data_in(data_in)

    );

    ram_verilog #
    (
        .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH),
        .BRAM_WORD_COUNT(BRAM_WORD_COUNT)
    )
    
    ram_verilog_inst
    (
        .clk(s00_axi_aclk),          // Clock Input
        .resetn(s00_axi_aresetn),
        .addra(bram_addr),            // Address Input
        .dina(bram_din),              // Data bi-directional
        .wea(bram_we),                // Write Enable
        .dinb(data_out),              // 4096 bit data input in parallel
        .dinb_read(data_out_read),
        .web(data_out_valid),         // Write enable in portb
        .doutb(data_in),              // 4096 bit data output for reading
        .doutb_valid(data_in_valid)
    );

	endmodule
