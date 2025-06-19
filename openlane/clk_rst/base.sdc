# SPDX-FileCopyrightText: 2020 Efabless Corporation
create_clock [get_ports {"xclk"} ] -name "xclk"  -period 20
create_clock [get_ports {"rcosc_500k"} ] -name "rcosc_500k"  -period 2000
create_clock [get_ports {"rcosc_16m"} ] -name "rcosc_16m"  -period 62.5
create_clock [get_ports {"hsxo"} ] -name "hsxo"  -period 62.5
create_clock [get_ports {"lsxo"} ] -name "lsxo"  -period 31250
create_clock [get_ports {"dll_clk"} ] -name "dll_clk"  -period 4.67
create_clock [get_ports {"dll_clk90"} ] -name "dll_clk90"  -period 4.67

create_clock [get_pins -of_objects CLKDIV_0.DIV_BYPASS_MUX.Q2b -filter lib_pin_name==Q] -name "CLKDIV_0.DIV_BYPASS_MUX.Q2b" -period 9.34
create_clock [get_pins -of_objects CLKDIV_0.DIV_BYPASS_MUX.Q1b -filter lib_pin_name==Q] -name "CLKDIV_0.DIV_BYPASS_MUX.Q1b" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.DIV_BYPASS_MUX.Q2b -filter lib_pin_name==Q] -name "CLKDIV_1.DIV_BYPASS_MUX.Q2b" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.DIV_BYPASS_MUX.Q1b -filter lib_pin_name==Q] -name "CLKDIV_1.DIV_BYPASS_MUX.Q1b" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.DIV_BYPASS_MUX.Q2b -filter lib_pin_name==Q] -name "CLKDIV_2.DIV_BYPASS_MUX.Q2b" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.DIV_BYPASS_MUX.Q1b -filter lib_pin_name==Q] -name "CLKDIV_2.DIV_BYPASS_MUX.Q1b" -period 9.34

create_clock [get_pins -of_objects CLKDIV_0.DIV_BYPASS_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_0.DIV_BYPASS_MUX.clk1" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.DIV_BYPASS_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_1.DIV_BYPASS_MUX.clk1" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.DIV_BYPASS_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_2.DIV_BYPASS_MUX.clk1" -period 9.34

create_clock [get_pins -of_objects CLKDIV_0.CLK_DIV_MUX.clk0 -filter lib_pin_name==Q] -name "CLKDIV_0.CLK_DIV_MUX.clk0" -period 9.34
create_clock [get_pins -of_objects CLKDIV_0.CLK_DIV_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_0.CLK_DIV_MUX.clk1" -period 9.34
create_clock [get_pins -of_objects CLKDIV_0.CLK_DIV_MUX.clk2 -filter lib_pin_name==Q] -name "CLKDIV_0.CLK_DIV_MUX.clk2" -period 9.34
create_clock [get_pins -of_objects CLKDIV_0.CLK_DIV_MUX.clk3 -filter lib_pin_name==Q] -name "CLKDIV_0.CLK_DIV_MUX.clk3" -period 9.34

create_clock [get_pins -of_objects CLKDIV_1.CLK_DIV_MUX.clk0 -filter lib_pin_name==Q] -name "CLKDIV_1.CLK_DIV_MUX.clk0" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.CLK_DIV_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_1.CLK_DIV_MUX.clk1" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.CLK_DIV_MUX.clk2 -filter lib_pin_name==Q] -name "CLKDIV_1.CLK_DIV_MUX.clk2" -period 9.34
create_clock [get_pins -of_objects CLKDIV_1.CLK_DIV_MUX.clk3 -filter lib_pin_name==Q] -name "CLKDIV_1.CLK_DIV_MUX.clk3" -period 9.34

create_clock [get_pins -of_objects CLKDIV_2.CLK_DIV_MUX.clk0 -filter lib_pin_name==Q] -name "CLKDIV_2.CLK_DIV_MUX.clk0" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.CLK_DIV_MUX.clk1 -filter lib_pin_name==Q] -name "CLKDIV_2.CLK_DIV_MUX.clk1" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.CLK_DIV_MUX.clk2 -filter lib_pin_name==Q] -name "CLKDIV_2.CLK_DIV_MUX.clk2" -period 9.34
create_clock [get_pins -of_objects CLKDIV_2.CLK_DIV_MUX.clk3 -filter lib_pin_name==Q] -name "CLKDIV_2.CLK_DIV_MUX.clk3" -period 9.34

create_clock [get_pins -of_objects CLKDIV_1.DIV_BYPASS_MUX.clk0 -filter lib_pin_name==X] -name "CLKDIV_1.DIV_BYPASS_MUX.clk0" -period 4.67

create_clock [get_pins -of_objects pclk_div -filter lib_pin_name==Q] -name "pclk" -period 9.34

create_clock -name VIRTUAL_CLK -period 15

set_clock_groups \
   -name clock_group \
   -logically_exclusive \
   -group [get_clocks {VIRTUAL_CLK}]\
   -group [get_clocks {xclk}]\
   -group [get_clocks {rcosc_500k}]\
   -group [get_clocks {rcosc_16m}]\
   -group [get_clocks {hsxo}]\
   -group [get_clocks {lsxo}]\
   -group [get_clocks {dll_clk}]\
   -group [get_clocks {dll_clk90}]\
   -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q2b}]\
   -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q1b}]\
   -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk0}]\
   -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk1}]\
   -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk2}]\
   -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk3}]\
   -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.clk1}]\
   -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q2b}]\
   -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q1b}]\
   -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk0}]\
   -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk1}]\
   -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk2}]\
   -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk3}]\
   -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk1}]\
   -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk0}]\
   -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q2b}]\
   -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q1b}]\
   -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk0}]\
   -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk1}]\
   -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk2}]\
   -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk3}]\
   -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.clk1}]\
   -group [get_clocks {pclk}]

set_propagated_clock [all_clocks]
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
set_input_delay 3  -clock [get_clocks VIRTUAL_CLK] [all_inputs]
set_output_delay 3  -clock [get_clocks VIRTUAL_CLK] [all_outputs]

set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set_load 0.20 [all_outputs]

set_timing_derate -early [expr {1-0.06}]
set_timing_derate -late [expr {1+0.06}]

puts "\[INFO\]: Setting clock uncertainity to: 0.350"
set_clock_uncertainty 0.350 [all_clocks] 
# set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [get_nets ]