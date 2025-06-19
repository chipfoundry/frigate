## CLOCK CONSTRAINTS
create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period 17
set_propagated_clock [get_clocks $::env(CLOCK_PORT)]
# set_clock_transition 1.5 [get_clocks $::env(CLOCK_PORT)]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_4 -pin {X} [get_ports $::env(CLOCK_PORT)]
set_clock_uncertainty 0.1 [get_clocks $::env(CLOCK_PORT)]

## INPUT DELAY
set_input_transition 0.5 [all_inputs]
set_input_delay  4.8 -clock [get_clocks $::env(CLOCK_PORT)] [all_inputs]
set_input_delay -min 3.2 -clock [get_clocks $::env(CLOCK_PORT)] [get_ports PADDR*]

## OUTPUT DELAY
set_output_delay 4.8 -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]
set_output_delay 4.5 -clock [get_clocks $::env(CLOCK_PORT)] [get_ports PRDATA*]

## CAP LOAD
set cap_load 0.075
puts "\[INFO\]: Setting load to: $cap_load"
set_load $cap_load [all_outputs]

## MAX TRANS
set_max_transition 1 [current_design]

## DERATES
puts "\[INFO\]: Setting timing derate to: [expr {0.05 * 100}] %"
set_timing_derate -early 0.95
set_timing_derate -late 1.05

# Maximum fanout
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
puts "\[INFO\]: Setting maximum fanout to: $::env(MAX_FANOUT_CONSTRAINT)"

# Separate address and data phase
set_multicycle_path -setup 2 -through [get_ports {PADDR*}] -through [get_ports {PRDATA*}]
set_multicycle_path -hold 1 -through [get_ports {PADDR*}] -through [get_ports {PRDATA*}]
