set origin_dir [file dirname [info script]]

# Create project
create_project rsa_project $origin_dir/rsa_project -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]

# Set IP repository paths
set_property ip_repo_paths "[file normalize $origin_dir/src/ip_repo] [file normalize $origin_dir/src/ip_repo]" [get_filesets sources_1]

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog

# Add source files
set files [list \
               [file normalize $origin_dir/src/rtl/adder.v                     ] \
               [file normalize $origin_dir/src/rtl/montgomery.v                ] \
               [file normalize $origin_dir/src/rtl/montgomery_wrapper.v        ] \
               [file normalize $origin_dir/src/rtl/hweval_adder.v              ] \
               [file normalize $origin_dir/src/rtl/hweval_montgomery.v         ] \
               [file normalize $origin_dir/src/rtl/hweval_montgomery_wrapper.v ] \
            ]
add_files -norecurse -fileset [get_filesets sources_1] $files

set_property top hweval_adder [get_filesets sources_1]

# Create block design
source $origin_dir/src/bd/rsa_project_bd.tcl
regenerate_bd_layout

# Generate the wrapper
set design_name [get_bd_designs]
make_wrapper -files [get_files $design_name.bd] -top -import

# Add Simulation files
set files [list \
               [file normalize $origin_dir/src/rtl/tb_adder.v                  ] \
               [file normalize $origin_dir/src/rtl/tb_montgomery.v             ] \
               [file normalize $origin_dir/src/rtl/tb_montgomery_wrapper.v     ] \
             ]
add_files -norecurse -fileset [get_filesets sim_1] $files

set_property top tb_adder [get_filesets sim_1]

# Remove design sources from simulation
set files [list \
               [file normalize $origin_dir/src/rtl/hweval_adder.v                                                   ] \
               [file normalize $origin_dir/src/rtl/hweval_montgomery.v                                              ] \
               [file normalize $origin_dir/src/rtl/hweval_montgomery_wrapper.v                                      ] \
               [file normalize $origin_dir/rsa_project/rsa_project.srcs/sources_1/imports/hdl/rsa_project_wrapper.v ] \
               [file normalize $origin_dir/rsa_project/rsa_project.srcs/sources_1/bd/rsa_project/rsa_project.bd     ] \
            ]
set_property used_in_simulation false [get_files $files]

# Add Constraints
add_files -fileset constrs_1 -norecurse $origin_dir/src/constraints/constraints.tcl

# Add Waveform Files
# add_files -fileset sim_1 -norecurse $origin_dir/src/wcfg/tb_traffic_behav.wcfg
# set_property xsim.view $origin_dir/src/wcfg/tb_traffic_behav.wcfg [get_filesets sim_1]

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

# Latches -> Error
set_msg_config -id {Synth 8-327}     -new_severity {ERROR}

# Multi-driven -> Error
set_msg_config -id {Synth 8-3352}    -new_severity {ERROR}
set_msg_config -id {Synth 8-5559}    -new_severity {ERROR}

# Timing not meet -> Error
set_msg_config -id {Timing 38-282}   -new_severity {ERROR}

set_msg_config -id {BD 41-1343}      -new_severity {INFO}
set_msg_config -id {BD_TCL-1000}     -new_severity {INFO}
set_msg_config -id {IP_Flow 19-3899} -new_severity {INFO}
set_msg_config -id {IP_Flow 19-3153} -new_severity {INFO}
set_msg_config -id {IP_Flow 19-2207} -new_severity {INFO}
set_msg_config -id {Vivado 12-3482}  -new_severity {INFO}
