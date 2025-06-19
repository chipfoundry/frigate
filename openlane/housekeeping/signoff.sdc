### Housekeeping SDC Update
### Mod Rev 2 
### Date: 7/10/2022

set ::env(WB_CLK_PERIOD) 20
set ::env(SCK_CLK_PERIOD) 100
set ::env(RESET_PORT) "wb_rstn_i"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

## MASTER CLOCKS
create_clock [get_ports {"wb_clk_i"} ] -name "wb_clk_i"  -period $::env(WB_CLK_PERIOD)
create_clock [get_ports {"hk_spi_sck"} ] -name "sck"  -period $::env(SCK_CLK_PERIOD)
##
set_propagated_clock [get_clocks {wb_clk_i}]
set_propagated_clock [get_clocks {"sck"}]

## GENERATED CLOCKS
# NOTE: change the clock pins whenever the synthesis receipe changes 
set wbbd_sck_pin [get_pins -of_objects wbbd_sck -filter lib_pin_name==Q]

create_generated_clock -name "wbbd_sck" -source [get_ports {"wb_clk_i"} ] -divide_by 2 $wbbd_sck_pin

# paths between wb_clk_i and sck shouldn't be timed
set_clock_groups -logically_exclusive -group wb_clk_i -group sck 
set_clock_groups -logically_exclusive -group wbbd_sck -group sck 

set_propagated_clock [all_clocks]

## FALSE PATHS
set_false_path -from [get_ports $::env(RESET_PORT)]
set_false_path -from [get_ports "porb"]

## INPUT/OUTPUT DELAYS
set input_delay_value 1.5
set output_delay_value 5
puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

## INPUT DELAYS
set_input_delay $input_delay_value -clock [get_clocks wb_clk_i] [all_inputs]

## OUTPUT DELAYS

# WISHBONE DELAY
set_output_delay 0.1 -clock [get_clocks wb_clk_i] [get_ports wb_ack_o]
set_output_delay 0.1 -clock [get_clocks wb_clk_i] [get_ports wb_dat_o[*]]


# IRQ 
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports irq]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports reset]

# GPIO 
# Specify serial_clock as a generated clock signal
#set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports serial_clock]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports serial_load]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports serial_resetn]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports serial_data_1]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports serial_data_2]

# FLASH 
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports spimemio_flash_io0_di]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports spimemio_flash_io1_di]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports spimemio_flash_io2_di]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports spimemio_flash_io3_di]

set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_csb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_csb_oeb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_clk]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_clk_oeb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io0_oeb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io1_oeb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io0_ieb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io1_ieb]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io0_do]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io1_do]
set_output_delay $output_delay_value  -clock [get_clocks wb_clk_i] [get_ports pad_flash_io0_ieb]

## OUTPUT LOADS
set PT_cap_load 0.21
puts "\[INFO\]: Setting load to: $PT_cap_load"
set_load $PT_cap_load [all_outputs]

## TIMING DERATE
set ::env(SYNTH_TIMING_DERATE) 0.05
puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 100}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]

## CLOCK UNCERTAINITY
set wb_clk_uncer 0.1
set sck_clk_uncer 0.1

puts "\[INFO\]: Setting WB clock uncertainity to: $wb_clk_uncer"
puts "\[INFO\]: Setting SCK clock uncertainity to: $sck_clk_uncer"
set_clock_uncertainty $wb_clk_uncer [get_clocks {wb_clk_i}]
set_clock_uncertainty $sck_clk_uncer [get_clocks {sck}]
set_clock_uncertainty $sck_clk_uncer [get_clocks {wbbd_sck}]

## CLOCK TRANSITION
set wb_clk_tran 0.15
set sck_clk_tran 0.15

puts "\[INFO\]: Setting clock transition to: $wb_clk_tran"
puts "\[INFO\]: Setting clock transition to: $sck_clk_tran"

set_clock_transition $wb_clk_tran [get_clocks {wb_clk_i}]
set_clock_transition $sck_clk_tran [get_clocks {sck}]

## FANOUT
puts "\[INFO\]: Setting maximum fanout to: $::env(MAX_FANOUT_CONSTRAINT)"
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]

## MAX Transition
set_max_trans 1.5 [current_design]