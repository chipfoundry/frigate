###############################################################################
# Created by write_sdc
###############################################################################
current_design clk_rst
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name xclk -period 20.0000 [get_ports {xclk}]
set_clock_uncertainty 0.3500 xclk
set_propagated_clock [get_clocks {xclk}]
create_clock -name rcosc_500k -period 2000.0000 [get_ports {rcosc_500k}]
set_clock_uncertainty 0.3500 rcosc_500k
set_propagated_clock [get_clocks {rcosc_500k}]
create_clock -name rcosc_16m -period 62.5000 [get_ports {rcosc_16m}]
set_clock_uncertainty 0.3500 rcosc_16m
set_propagated_clock [get_clocks {rcosc_16m}]
create_clock -name hsxo -period 62.5000 [get_ports {hsxo}]
set_clock_uncertainty 0.3500 hsxo
set_propagated_clock [get_clocks {hsxo}]
create_clock -name lsxo -period 31249.9980 [get_ports {lsxo}]
set_clock_uncertainty 0.3500 lsxo
set_propagated_clock [get_clocks {lsxo}]
create_clock -name dll_clk -period 4.6700 [get_ports {dll_clk}]
set_clock_uncertainty 0.3500 dll_clk
set_propagated_clock [get_clocks {dll_clk}]
create_clock -name dll_clk90 -period 4.6700 [get_ports {dll_clk90}]
set_clock_uncertainty 0.3500 dll_clk90
set_propagated_clock [get_clocks {dll_clk90}]
create_clock -name CLKDIV_0.DIV_BYPASS_MUX.Q2b -period 9.3400 [get_pins {_280_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.DIV_BYPASS_MUX.Q2b
set_propagated_clock [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q2b}]
create_clock -name CLKDIV_0.DIV_BYPASS_MUX.Q1b -period 9.3400 [get_pins {_281_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.DIV_BYPASS_MUX.Q1b
set_propagated_clock [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q1b}]
create_clock -name CLKDIV_1.DIV_BYPASS_MUX.Q2b -period 9.3400 [get_pins {_313_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.DIV_BYPASS_MUX.Q2b
set_propagated_clock [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q2b}]
create_clock -name CLKDIV_1.DIV_BYPASS_MUX.Q1b -period 9.3400 [get_pins {_314_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.DIV_BYPASS_MUX.Q1b
set_propagated_clock [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q1b}]
create_clock -name CLKDIV_2.DIV_BYPASS_MUX.Q2b -period 9.3400 [get_pins {_334_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.DIV_BYPASS_MUX.Q2b
set_propagated_clock [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q2b}]
create_clock -name CLKDIV_2.DIV_BYPASS_MUX.Q1b -period 9.3400 [get_pins {_335_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.DIV_BYPASS_MUX.Q1b
set_propagated_clock [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q1b}]
create_clock -name CLKDIV_0.DIV_BYPASS_MUX.clk1 -period 9.3400 [get_pins {_295_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.DIV_BYPASS_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.clk1}]
create_clock -name CLKDIV_1.DIV_BYPASS_MUX.clk1 -period 9.3400 [get_pins {_328_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.DIV_BYPASS_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk1}]
create_clock -name CLKDIV_2.DIV_BYPASS_MUX.clk1 -period 9.3400 [get_pins {_349_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.DIV_BYPASS_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.clk1}]
create_clock -name CLKDIV_0.CLK_DIV_MUX.clk0 -period 9.3400 [get_pins {_296_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.CLK_DIV_MUX.clk0
set_propagated_clock [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk0}]
create_clock -name CLKDIV_0.CLK_DIV_MUX.clk1 -period 9.3400 [get_pins {_297_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.CLK_DIV_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk1}]
create_clock -name CLKDIV_0.CLK_DIV_MUX.clk2 -period 9.3400 [get_pins {_298_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.CLK_DIV_MUX.clk2
set_propagated_clock [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk2}]
create_clock -name CLKDIV_0.CLK_DIV_MUX.clk3 -period 9.3400 [get_pins {_299_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_0.CLK_DIV_MUX.clk3
set_propagated_clock [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk3}]
create_clock -name CLKDIV_1.CLK_DIV_MUX.clk0 -period 9.3400 [get_pins {_329_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.CLK_DIV_MUX.clk0
set_propagated_clock [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk0}]
create_clock -name CLKDIV_1.CLK_DIV_MUX.clk1 -period 9.3400 [get_pins {_330_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.CLK_DIV_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk1}]
create_clock -name CLKDIV_1.CLK_DIV_MUX.clk2 -period 9.3400 [get_pins {_331_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.CLK_DIV_MUX.clk2
set_propagated_clock [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk2}]
create_clock -name CLKDIV_1.CLK_DIV_MUX.clk3 -period 9.3400 [get_pins {_332_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_1.CLK_DIV_MUX.clk3
set_propagated_clock [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk3}]
create_clock -name CLKDIV_2.CLK_DIV_MUX.clk0 -period 9.3400 [get_pins {_350_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.CLK_DIV_MUX.clk0
set_propagated_clock [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk0}]
create_clock -name CLKDIV_2.CLK_DIV_MUX.clk1 -period 9.3400 [get_pins {_351_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.CLK_DIV_MUX.clk1
set_propagated_clock [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk1}]
create_clock -name CLKDIV_2.CLK_DIV_MUX.clk2 -period 9.3400 [get_pins {_352_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.CLK_DIV_MUX.clk2
set_propagated_clock [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk2}]
create_clock -name CLKDIV_2.CLK_DIV_MUX.clk3 -period 9.3400 [get_pins {_353_/Q}]
set_clock_uncertainty 0.3500 CLKDIV_2.CLK_DIV_MUX.clk3
set_propagated_clock [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk3}]
create_clock -name CLKDIV_1.DIV_BYPASS_MUX.clk0 -period 4.6700 [get_pins {_211_/X}]
set_clock_uncertainty 0.3500 CLKDIV_1.DIV_BYPASS_MUX.clk0
set_propagated_clock [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk0}]
create_clock -name pclk -period 9.3400 [get_pins {_245_/Q}]
set_clock_uncertainty 0.3500 pclk
set_propagated_clock [get_clocks {pclk}]
create_clock -name VIRTUAL_CLK -period 15.0000 
set_clock_uncertainty 0.3500 VIRTUAL_CLK
set_clock_groups -name clock_group -logically_exclusive \
 -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk0}]\
 -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk1}]\
 -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk2}]\
 -group [get_clocks {CLKDIV_0.CLK_DIV_MUX.clk3}]\
 -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q1b}]\
 -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.Q2b}]\
 -group [get_clocks {CLKDIV_0.DIV_BYPASS_MUX.clk1}]\
 -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk0}]\
 -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk1}]\
 -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk2}]\
 -group [get_clocks {CLKDIV_1.CLK_DIV_MUX.clk3}]\
 -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q1b}]\
 -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.Q2b}]\
 -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk0}]\
 -group [get_clocks {CLKDIV_1.DIV_BYPASS_MUX.clk1}]\
 -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk0}]\
 -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk1}]\
 -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk2}]\
 -group [get_clocks {CLKDIV_2.CLK_DIV_MUX.clk3}]\
 -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q1b}]\
 -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.Q2b}]\
 -group [get_clocks {CLKDIV_2.DIV_BYPASS_MUX.clk1}]\
 -group [get_clocks {VIRTUAL_CLK}]\
 -group [get_clocks {dll_clk}]\
 -group [get_clocks {dll_clk90}]\
 -group [get_clocks {hsxo}]\
 -group [get_clocks {lsxo}]\
 -group [get_clocks {pclk}]\
 -group [get_clocks {rcosc_16m}]\
 -group [get_clocks {rcosc_500k}]\
 -group [get_clocks {xclk}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk_mon_sel[0]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk_mon_sel[1]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk_mon_sel[2]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {dll_clk}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {dll_clk90}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hkrst_n}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hsxo}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hsxo_en}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hsxo_standby}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {lsxo}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {lsxo_en}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {lsxo_standby}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {por_n}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_16m}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_16m_en}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_500k}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_500k_en}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv0[0]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv0[1]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv0[2]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv1[0]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv1[1]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv1[2]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv2[0]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv2[1]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_clkdiv2[2]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux0}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux1}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux2}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux3}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux4}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {sel_mux5}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {user_dly_sel[0]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {user_dly_sel[1]}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {xclk}]
set_input_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {xrst_n}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk_mon}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {clk_mux1_out}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hsxo_en_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {hsxo_standby_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {lsxo_en_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {lsxo_standby_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {pclk}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_16m_en_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rcosc_500k_en_tf}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {rst_n}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {usb_clk}]
set_output_delay 3.0000 -clock [get_clocks {VIRTUAL_CLK}] -add_delay [get_ports {user_clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.2000 [get_ports {clk}]
set_load -pin_load 0.2000 [get_ports {clk_mon}]
set_load -pin_load 0.2000 [get_ports {clk_mux1_out}]
set_load -pin_load 0.2000 [get_ports {hsxo_en_tf}]
set_load -pin_load 0.2000 [get_ports {hsxo_standby_tf}]
set_load -pin_load 0.2000 [get_ports {lsxo_en_tf}]
set_load -pin_load 0.2000 [get_ports {lsxo_standby_tf}]
set_load -pin_load 0.2000 [get_ports {pclk}]
set_load -pin_load 0.2000 [get_ports {rcosc_16m_en_tf}]
set_load -pin_load 0.2000 [get_ports {rcosc_500k_en_tf}]
set_load -pin_load 0.2000 [get_ports {rst_n}]
set_load -pin_load 0.2000 [get_ports {usb_clk}]
set_load -pin_load 0.2000 [get_ports {user_clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {dll_clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {dll_clk90}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {hkrst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {hsxo}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {hsxo_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {hsxo_standby}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {lsxo}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {lsxo_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {lsxo_standby}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {por_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rcosc_16m}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rcosc_16m_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rcosc_500k}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rcosc_500k_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux0}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux1}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux2}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux3}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux4}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_mux5}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {xclk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {xrst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk_mon_sel[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk_mon_sel[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk_mon_sel[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv0[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv0[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv0[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv1[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv1[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv1[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv2[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv2[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {sel_clkdiv2[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {user_dly_sel[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {user_dly_sel[0]}]
set_timing_derate -early 0.9400
set_timing_derate -late 1.0600
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 18.0000 [current_design]
