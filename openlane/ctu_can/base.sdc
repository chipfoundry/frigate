
create_clock [get_ports $::env(CLOCK_PORT)]  -name clk  -period $::env(CLOCK_PERIOD)

set_propagated_clock [all_clocks]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_16 -pin {X} [get_ports $::env(CLOCK_PORT)]
set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) [get_clocks {clk}]
puts "\[INFO\]: Setting clock uncertainity to: $::env(CLOCK_UNCERTAINTY_CONSTRAINT)"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [get_clocks {clk}]
puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"

# Maximum transition time for the design nets
set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]
puts "\[INFO\]: Setting maximum transition to: $::env(MAX_TRANSITION_CONSTRAINT)"

# Maximum fanout
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
puts "\[INFO\]: Setting maximum fanout to: $::env(MAX_FANOUT_CONSTRAINT)"

## DERATES
set derate [expr $::env(TIME_DERATING_CONSTRAINT) / 100] 
puts "\[INFO\]: Setting timing derate to:  $::env(TIME_DERATING_CONSTRAINT) %"
set_timing_derate -early [expr {1 - $derate}]
set_timing_derate -late [expr {1 + $derate}]

# # Clock source latency
# set clk_max_latency 2.4
# set clk_min_latency 2.2
# set_clock_latency -source -max $clk_max_latency [get_clocks {clk}]
# set_clock_latency -source -min $clk_min_latency [get_clocks {clk}]
# puts "\[INFO\]: Setting clock latency range: $clk_min_latency : $clk_max_latency"

# Input delays
set_input_delay -max 4.5 -clock [get_clocks {clk}] [all_inputs]
set_input_delay -min 3.5 -clock [get_clocks {clk}] [all_inputs]

set_input_delay -min 0.2 -clock [get_clocks {clk}] [get_ports {adress* can_rx data_in[*]}]
set_input_delay -max 1.2 -clock [get_clocks {clk}] [get_ports {adress* can_rx data_in[*]}]

# Input Transition
set_input_transition -max 0.20  [all_inputs]

# Output delays
set_output_delay -max 4.5 -clock [get_clocks {clk}] [all_outputs]
set_output_delay -min 3.5 -clock [get_clocks {clk}] [all_outputs]


# Output loads
set_load 0.20 [all_outputs]

