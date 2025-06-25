
create_clock [get_ports $::env(CLOCK_PORT)]  -name clk  -period 20

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
	set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}
if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL_PIN)] } {
	set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
}

# Clock non-idealities
set_propagated_clock [all_clocks]
set_clock_uncertainty 0.1 [get_clocks {clk}]
puts "\[INFO\]: Setting clock uncertainity to: 0.1"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [get_clocks {clk}]
puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"

# Maximum transition time for the design nets
set_max_transition 1.5 [current_design]
puts "\[INFO\]: Setting maximum transition to: 1.5"

# Maximum fanout
set_max_fanout 20 [current_design]
puts "\[INFO\]: Setting maximum fanout to: 20"

# Timing paths delays derate
set_timing_derate -early [expr {1-0.05}]
set_timing_derate -late [expr {1+0.05}]
puts "\[INFO\]: Setting timing derate to: [expr {0.05 * 100}] %"

# Clock input Transition
set clk_tran 0.50
set_input_transition $clk_tran [get_ports $::env(CLOCK_PORT)]
puts "\[INFO\]: Setting clock transition: $clk_tran"

# Input delays
set_input_delay -max 4.5 -clock [get_clocks {clk}] [all_inputs]
set_input_delay -min 3.5 -clock [get_clocks {clk}] [all_inputs]
set_input_delay -max 1.5 -clock [get_clocks {clk}] [get_ports {adress* can_rx data_in[*]}]
set_input_delay -min 0.5 -clock [get_clocks {clk}] [get_ports {adress* can_rx data_in[*]}]
# Input Transition
set_input_transition -max 0.20  [all_inputs]

# Output delays
set_output_delay -max 4.5  -clock [get_clocks {clk}] [all_outputs]
set_output_delay -min 3.5  -clock [get_clocks {clk}] [all_outputs]

# Output loads
set_load 0.20 [all_outputs]

# Clock source latency
# set clk_max_latency 2.2
# set clk_min_latency 2.4
# set_clock_latency -source -max $clk_max_latency [get_clocks {clk}]
# set_clock_latency -source -min $clk_min_latency [get_clocks {clk}]
# puts "\[INFO\]: Setting clock latency range: $clk_min_latency : $clk_max_latency"
