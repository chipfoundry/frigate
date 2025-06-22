###############################################################################
# Created by write_sdc
###############################################################################
current_design EF_QSPI_XIP_CTRL_AHBL
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 15.0000 [get_ports {HCLK}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.1500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 2.2000 [get_clocks {clk}]
set_clock_latency -source -max 2.4000 [get_clocks {clk}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[0]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[0]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[10]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[10]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[11]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[11]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[12]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[12]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[13]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[13]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[14]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[14]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[15]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[15]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[16]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[16]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[17]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[17]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[18]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[18]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[19]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[19]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[1]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[1]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[20]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[20]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[21]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[21]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[22]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[22]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[23]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[23]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[24]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[24]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[25]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[25]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[26]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[26]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[27]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[27]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[28]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[28]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[29]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[29]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[2]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[2]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[30]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[30]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[31]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[31]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[3]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[3]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[4]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[4]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[5]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[5]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[6]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[6]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[7]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[7]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[8]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[8]}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HADDR[9]}]
set_input_delay 16.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HADDR[9]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HREADY}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HREADY}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRESETn}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRESETn}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HSEL}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HSEL}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HTRANS[0]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HTRANS[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HTRANS[1]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HTRANS[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HWRITE}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HWRITE}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {din[0]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {din[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {din[1]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {din[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {din[2]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {din[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {din[3]}]
set_input_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {din[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[0]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[10]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[10]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[11]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[11]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[12]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[12]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[13]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[13]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[14]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[14]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[15]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[15]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[16]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[16]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[17]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[17]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[18]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[18]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[19]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[19]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[1]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[20]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[20]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[21]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[21]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[22]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[22]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[23]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[23]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[24]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[24]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[25]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[25]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[26]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[26]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[27]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[27]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[28]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[28]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[29]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[29]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[2]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[30]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[30]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[31]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[31]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[3]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[4]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[4]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[5]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[5]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[6]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[6]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[7]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[7]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[8]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[8]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HRDATA[9]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HRDATA[9]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {HREADYOUT}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {HREADYOUT}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {ce_n}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {ce_n}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dout[0]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dout[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dout[1]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dout[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dout[2]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dout[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dout[3]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dout[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {douten[0]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {douten[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {douten[1]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {douten[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {douten[2]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {douten[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {douten[3]}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {douten[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {sck}]
set_output_delay 12.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {sck}]
set_multicycle_path -hold\
    -from [list [get_ports {HADDR[0]}]\
           [get_ports {HADDR[10]}]\
           [get_ports {HADDR[11]}]\
           [get_ports {HADDR[12]}]\
           [get_ports {HADDR[13]}]\
           [get_ports {HADDR[14]}]\
           [get_ports {HADDR[15]}]\
           [get_ports {HADDR[16]}]\
           [get_ports {HADDR[17]}]\
           [get_ports {HADDR[18]}]\
           [get_ports {HADDR[19]}]\
           [get_ports {HADDR[1]}]\
           [get_ports {HADDR[20]}]\
           [get_ports {HADDR[21]}]\
           [get_ports {HADDR[22]}]\
           [get_ports {HADDR[23]}]\
           [get_ports {HADDR[24]}]\
           [get_ports {HADDR[25]}]\
           [get_ports {HADDR[26]}]\
           [get_ports {HADDR[27]}]\
           [get_ports {HADDR[28]}]\
           [get_ports {HADDR[29]}]\
           [get_ports {HADDR[2]}]\
           [get_ports {HADDR[30]}]\
           [get_ports {HADDR[31]}]\
           [get_ports {HADDR[3]}]\
           [get_ports {HADDR[4]}]\
           [get_ports {HADDR[5]}]\
           [get_ports {HADDR[6]}]\
           [get_ports {HADDR[7]}]\
           [get_ports {HADDR[8]}]\
           [get_ports {HADDR[9]}]]\
    -through [list [get_ports {HRDATA[0]}]\
           [get_ports {HRDATA[10]}]\
           [get_ports {HRDATA[11]}]\
           [get_ports {HRDATA[12]}]\
           [get_ports {HRDATA[13]}]\
           [get_ports {HRDATA[14]}]\
           [get_ports {HRDATA[15]}]\
           [get_ports {HRDATA[16]}]\
           [get_ports {HRDATA[17]}]\
           [get_ports {HRDATA[18]}]\
           [get_ports {HRDATA[19]}]\
           [get_ports {HRDATA[1]}]\
           [get_ports {HRDATA[20]}]\
           [get_ports {HRDATA[21]}]\
           [get_ports {HRDATA[22]}]\
           [get_ports {HRDATA[23]}]\
           [get_ports {HRDATA[24]}]\
           [get_ports {HRDATA[25]}]\
           [get_ports {HRDATA[26]}]\
           [get_ports {HRDATA[27]}]\
           [get_ports {HRDATA[28]}]\
           [get_ports {HRDATA[29]}]\
           [get_ports {HRDATA[2]}]\
           [get_ports {HRDATA[30]}]\
           [get_ports {HRDATA[31]}]\
           [get_ports {HRDATA[3]}]\
           [get_ports {HRDATA[4]}]\
           [get_ports {HRDATA[5]}]\
           [get_ports {HRDATA[6]}]\
           [get_ports {HRDATA[7]}]\
           [get_ports {HRDATA[8]}]\
           [get_ports {HRDATA[9]}]] 1
set_multicycle_path -setup\
    -from [list [get_ports {HADDR[0]}]\
           [get_ports {HADDR[10]}]\
           [get_ports {HADDR[11]}]\
           [get_ports {HADDR[12]}]\
           [get_ports {HADDR[13]}]\
           [get_ports {HADDR[14]}]\
           [get_ports {HADDR[15]}]\
           [get_ports {HADDR[16]}]\
           [get_ports {HADDR[17]}]\
           [get_ports {HADDR[18]}]\
           [get_ports {HADDR[19]}]\
           [get_ports {HADDR[1]}]\
           [get_ports {HADDR[20]}]\
           [get_ports {HADDR[21]}]\
           [get_ports {HADDR[22]}]\
           [get_ports {HADDR[23]}]\
           [get_ports {HADDR[24]}]\
           [get_ports {HADDR[25]}]\
           [get_ports {HADDR[26]}]\
           [get_ports {HADDR[27]}]\
           [get_ports {HADDR[28]}]\
           [get_ports {HADDR[29]}]\
           [get_ports {HADDR[2]}]\
           [get_ports {HADDR[30]}]\
           [get_ports {HADDR[31]}]\
           [get_ports {HADDR[3]}]\
           [get_ports {HADDR[4]}]\
           [get_ports {HADDR[5]}]\
           [get_ports {HADDR[6]}]\
           [get_ports {HADDR[7]}]\
           [get_ports {HADDR[8]}]\
           [get_ports {HADDR[9]}]]\
    -through [list [get_ports {HRDATA[0]}]\
           [get_ports {HRDATA[10]}]\
           [get_ports {HRDATA[11]}]\
           [get_ports {HRDATA[12]}]\
           [get_ports {HRDATA[13]}]\
           [get_ports {HRDATA[14]}]\
           [get_ports {HRDATA[15]}]\
           [get_ports {HRDATA[16]}]\
           [get_ports {HRDATA[17]}]\
           [get_ports {HRDATA[18]}]\
           [get_ports {HRDATA[19]}]\
           [get_ports {HRDATA[1]}]\
           [get_ports {HRDATA[20]}]\
           [get_ports {HRDATA[21]}]\
           [get_ports {HRDATA[22]}]\
           [get_ports {HRDATA[23]}]\
           [get_ports {HRDATA[24]}]\
           [get_ports {HRDATA[25]}]\
           [get_ports {HRDATA[26]}]\
           [get_ports {HRDATA[27]}]\
           [get_ports {HRDATA[28]}]\
           [get_ports {HRDATA[29]}]\
           [get_ports {HRDATA[2]}]\
           [get_ports {HRDATA[30]}]\
           [get_ports {HRDATA[31]}]\
           [get_ports {HRDATA[3]}]\
           [get_ports {HRDATA[4]}]\
           [get_ports {HRDATA[5]}]\
           [get_ports {HRDATA[6]}]\
           [get_ports {HRDATA[7]}]\
           [get_ports {HRDATA[8]}]\
           [get_ports {HRDATA[9]}]] 2
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.2000 [get_ports {HREADYOUT}]
set_load -pin_load 0.2000 [get_ports {ce_n}]
set_load -pin_load 0.2000 [get_ports {sck}]
set_load -pin_load 0.2000 [get_ports {HRDATA[31]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[30]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[29]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[28]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[27]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[26]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[25]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[24]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[23]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[22]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[21]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[20]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[19]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[18]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[17]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[16]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[15]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[14]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[13]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[12]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[11]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[10]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[9]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[8]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[7]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[6]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[5]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[4]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[3]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[2]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[1]}]
set_load -pin_load 0.2000 [get_ports {HRDATA[0]}]
set_load -pin_load 0.2000 [get_ports {dout[3]}]
set_load -pin_load 0.2000 [get_ports {dout[2]}]
set_load -pin_load 0.2000 [get_ports {dout[1]}]
set_load -pin_load 0.2000 [get_ports {dout[0]}]
set_load -pin_load 0.2000 [get_ports {douten[3]}]
set_load -pin_load 0.2000 [get_ports {douten[2]}]
set_load -pin_load 0.2000 [get_ports {douten[1]}]
set_load -pin_load 0.2000 [get_ports {douten[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_16 -pin {X} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {HCLK}]
set_input_transition -rise -max 0.2000 [get_ports {HCLK}]
set_input_transition -fall -max 0.2000 [get_ports {HCLK}]
set_input_transition -rise -max 0.2000 [get_ports {HREADY}]
set_input_transition -fall -max 0.2000 [get_ports {HREADY}]
set_input_transition -rise -max 0.2000 [get_ports {HRESETn}]
set_input_transition -fall -max 0.2000 [get_ports {HRESETn}]
set_input_transition -rise -max 0.2000 [get_ports {HSEL}]
set_input_transition -fall -max 0.2000 [get_ports {HSEL}]
set_input_transition -rise -max 0.2000 [get_ports {HWRITE}]
set_input_transition -fall -max 0.2000 [get_ports {HWRITE}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[31]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[31]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[30]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[30]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[29]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[29]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[28]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[28]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[27]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[27]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[26]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[26]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[25]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[25]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[24]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[24]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[23]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[23]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[22]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[22]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[21]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[21]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[20]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[20]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[19]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[19]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[18]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[18]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[17]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[17]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[16]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[16]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[15]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[15]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[14]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[14]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[13]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[13]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[12]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[12]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[11]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[11]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[10]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[10]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[9]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[9]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[8]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[8]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[7]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[7]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[6]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[6]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[5]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[5]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[4]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[4]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[3]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[3]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[2]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[2]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[1]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[1]}]
set_input_transition -rise -max 0.2000 [get_ports {HADDR[0]}]
set_input_transition -fall -max 0.2000 [get_ports {HADDR[0]}]
set_input_transition -rise -max 0.2000 [get_ports {HTRANS[1]}]
set_input_transition -fall -max 0.2000 [get_ports {HTRANS[1]}]
set_input_transition -rise -max 0.2000 [get_ports {HTRANS[0]}]
set_input_transition -fall -max 0.2000 [get_ports {HTRANS[0]}]
set_input_transition -rise -max 0.2000 [get_ports {din[3]}]
set_input_transition -fall -max 0.2000 [get_ports {din[3]}]
set_input_transition -rise -max 0.2000 [get_ports {din[2]}]
set_input_transition -fall -max 0.2000 [get_ports {din[2]}]
set_input_transition -rise -max 0.2000 [get_ports {din[1]}]
set_input_transition -fall -max 0.2000 [get_ports {din[1]}]
set_input_transition -rise -max 0.2000 [get_ports {din[0]}]
set_input_transition -fall -max 0.2000 [get_ports {din[0]}]
set_timing_derate -early 0.9350
set_timing_derate -late 1.0650
###############################################################################
# Design Rules
###############################################################################
set_max_transition 1.0000 [current_design]
set_max_fanout 16.0000 [current_design]
