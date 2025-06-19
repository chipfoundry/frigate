
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_4 -pin {X} [all_inputs]

## CAP LOAD
set cap_load 0.19
puts "\[INFO\]: Setting load to: $cap_load"
set_load $cap_load [all_outputs]

## MAX TRANS
set_max_trans 1.5 [current_design]
