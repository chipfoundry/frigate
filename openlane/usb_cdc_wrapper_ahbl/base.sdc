
create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period 36
create_clock [get_ports {usb_cdc_clk_48MHz}] -name usb_clk -period 18

set_propagated_clock [all_clocks]
set_clock_transition 0.15 [all_clocks]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_16 -pin {X} [get_ports $::env(CLOCK_PORT)]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_16 -pin {X} [get_ports usb_cdc_clk_48MHz]
set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) [all_clocks]
puts "\[INFO\]: Setting clock uncertainity to: $::env(CLOCK_UNCERTAINTY_CONSTRAINT)"

## INPUT DELAY
set_input_transition 0.5 [all_inputs]
set_input_delay -max 5 -clock [get_clocks $::env(CLOCK_PORT)] [all_inputs]
set_input_delay -min 2  -clock [get_clocks $::env(CLOCK_PORT)] [all_inputs]
## OUTPUT DELAY
set_output_delay -max 10 -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]
set_output_delay -min 3  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]

## CAP LOAD
set cap_load 0.075
puts "\[INFO\]: Setting load to: $cap_load"
set_load $cap_load [all_outputs]

## MAX TRANS
set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]
puts "\[INFO\]: Setting maximum transition to: $::env(MAX_TRANSITION_CONSTRAINT)"

## DERATES
set derate [expr $::env(TIME_DERATING_CONSTRAINT) / 100] 
puts "\[INFO\]: Setting timing derate to:  $::env(TIME_DERATING_CONSTRAINT) %"
set_timing_derate -early [expr {1 - $derate}]
set_timing_derate -late [expr {1 + $derate}]

set_clock_latency -max 5.5 [get_clocks {usb_clk}] -source
set_clock_latency -max 4.5 [get_clocks $::env(CLOCK_PORT)] -source
set_clock_latency -min 2.5 [get_clocks {usb_clk}] -source
set_clock_latency -min 3   [get_clocks $::env(CLOCK_PORT)] -source

# Maximum fanout
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
puts "\[INFO\]: Setting maximum fanout to: $::env(MAX_FANOUT_CONSTRAINT)"