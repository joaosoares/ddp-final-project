#Generate a clock with a period of 100MHz
create_clock -period 10 -name clk_gen -add [get_ports clk]
set_property PACKAGE_PIN L16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN R19 [get_ports data_ok]
set_property IOSTANDARD LVCMOS33 [get_ports data_ok]

set_property PACKAGE_PIN P19 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]