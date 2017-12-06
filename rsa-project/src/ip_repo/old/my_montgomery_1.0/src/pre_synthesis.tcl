set curdir [pwd]
remove_files -fileset constrs_1 $curdir/../../../../../src/ip_repo/my_montgomery_1.0/src/constraints2.xdc
add_files -fileset constrs_1 -norecurse $curdir/../../../../../src/ip_repo/my_montgomery_1.0/src/constraints2.xdc
