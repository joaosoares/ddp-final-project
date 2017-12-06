connect -url tcp:127.0.0.1:3121
source /users/cosic/fturan/DDP/forgit/rsa-project/src/sdk/rsa_project_wrapper_hw_platform_0/ps7_init.tcl
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279651974A"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo 210279651974A" && level==0} -index 1
fpga -file /users/cosic/fturan/DDP/forgit/rsa-project/src/sdk/rsa_project_wrapper_hw_platform_0/rsa_project_wrapper.bit
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279651974A"} -index 0
loadhw /users/cosic/fturan/DDP/forgit/rsa-project/src/sdk/rsa_project_wrapper_hw_platform_0/system.hdf
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279651974A"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279651974A"} -index 0
dow /users/cosic/fturan/DDP/forgit/rsa-project/src/sdk/rsa_design_example/Debug/rsa_design_example.elf
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279651974A"} -index 0
con
