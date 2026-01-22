// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`timescale 			1ns/1ps
`default_nettype 	none

module frigate_soc #(
	parameter SRAM_DEPTH = 1 << 12, // Default 32 kwords -> 128 kB
	parameter CLK_MHZ    = 12,      // For timer timebase

	`include "hazard3_config.vh"
) (
`ifdef USE_POWER_PINS
    inout vdda1,  // User area 1 3.3V supply
    inout vssa1,  // User area 1 analog ground
    inout vccd1,  // User area 1 1.8V supply
    inout vssd1,  // User area 1 digital ground
`endif // USE_POWER_PINS

`ifdef FPGA
	input wire    			clk,
	input wire      		rst_n,
`endif 

	// Flash (housekeeping pad side)
	output wire				fsclk,
	output wire				fcen,
	input wire  [3:0]       fdin,
	output wire [3:0]       fdout,
	output wire [3:0]       fdouten,

    // RISC-V JTAG-DTM 
	input  wire             dmi_psel,
	input  wire             dmi_penable,
	input  wire             dmi_pwrite,
	input  wire [8:0]       dmi_paddr,
	input  wire [31:0]      dmi_pwdata,
	output wire [31:0]      dmi_prdata,
	output wire             dmi_pready,
	output wire             dmi_pslverr,

	// Clock Sources
    input   wire        		xclk,           // External clock source
    input   wire        		rcosc_500k,     // Internal Low Speed RCOSC (500 KHz) -- Boot Oscillator
    input   wire        		rcosc_16m,      // Internal High SPeed RCOSC (16 MHz)
    input   wire        		hsxo,           // High SPeed XO
    input   wire        		lsxo,           // Low SPeed XO (32.768KHz)
     
    // Reset Sources
    input   wire        		xrst_n,         // external reset
    input   wire        		por_n,          // Power-on-Reset

	// clock source enables connected to timing frontend 
    output   wire                    rcosc_500k_en_tf, 
    output   wire                    rcosc_16m_en_tf,
    output   wire                    hsxo_en_tf,
    output   wire                    lsxo_en_tf,

    // lsxo and hsxo standby connected to timing frontend 
    output   wire                    lsxo_standby_tf,
    output   wire                    hsxo_standby_tf,

	//USB CDC 
	output  wire            usb_dp_pu,
    input   wire            usb_dp_rx,
    input   wire            usb_dn_rx,
    output  wire            usb_dp_tx,
    output  wire            usb_dn_tx,
    output  wire            usb_tx_en,

	output  wire			user_clk,
	// GPIO port G 
	input  wire [7:0]		gpioG_io_in,
	output wire [7:0]		gpioG_io_out,
	output wire [7:0]		gpioG_io_oe,

	// GPIO port H 
	input  wire 			gpioH_io_in,
	output wire 			gpioH_io_out,
	output wire 			gpioH_io_oe,

	// GPIO port J 
	input  wire [1:0]		gpioI_io_in,
	output wire [1:0]		gpioI_io_out,
	output wire [1:0]		gpioI_io_oe,

	// Pin MUX Ports
    input  wire [47:0]		pin_mux_io_in,
    output wire [47:0]		pin_mux_io_out,
    output wire [47:0]		pin_mux_io_oeb,

	// user irqs
	input wire [15:0] 		user_irqs,

    // Analog Signals
    //ADC0
	input  wire					adc0_cmp, 
	output wire 				adc0_hold, 
	output wire [11:0]			adc0_data, 
	output wire					adc0_en, 
	output wire 				adc0_dac_rst,

	//ADC1
	input  wire					adc1_cmp, 
	output wire 				adc1_hold, 
	output wire [11:0]			adc1_data, 
	output wire					adc1_en, 
	output wire 				adc1_dac_rst,

	//AUDIODAC0
	// ds-modulator outputs
	output	wire		    	ds_o,		// single-bit SD-modulator output
	output 	wire		    	ds_n_o,		//  plus the complementary output

	// RAM_0
	input wire [31:0]       SRAMRDATA_0,          // SRAM Read Data
    output wire             SRAMR_WB_0,            // SRAM write enable (active high)
    output wire [31:0]      SRAMWDATA_0,          // SRAM write data
    output wire             SRAMEN_0,             // SRAM Chip Select (active high)
    output wire [10:0]      SRAMADDR_0,           // SRAM address
	output wire				SRAMCLK_0,           // SRAM address
    output wire [31:0]      SRAMBEN_0,          // bit enable

	// RAM_1
	input wire [31:0]       SRAMRDATA_1,          // SRAM Read Data
    output wire             SRAMR_WB_1,            // SRAM write enable (active high)
    output wire [31:0]      SRAMWDATA_1,          // SRAM write data
    output wire             SRAMEN_1,             // SRAM Chip Select (active high)
    output wire [10:0]      SRAMADDR_1,           // SRAM address
	output wire				SRAMCLK_1,           // SRAM address
    output wire [31:0]      SRAMBEN_1,          // bit enable

	output wire HCLK_out,
	output wire HRESETn_out,

	// AHB2 master ports 
	input 	wire              ahb_2_hready_resp,
	output 	wire              ahb_2_hready,
	input 	wire              ahb_2_hresp,
	output 	wire [W_ADDR-1:0] ahb_2_haddr,
	output 	wire              ahb_2_hwrite,
	output 	wire [1:0]        ahb_2_htrans,
	output 	wire [2:0]        ahb_2_hsize,
	output 	wire [2:0]        ahb_2_hburst,
	output 	wire [3:0]        ahb_2_hprot,
	output 	wire              ahb_2_hmastlock,
	output 	wire [W_DATA-1:0] ahb_2_hwdata,
	input 	wire [W_DATA-1:0] ahb_2_hrdata,


    // Housekeeping 

    input 	wire              hk_spi_csb,
    input   wire              hk_spi_sck,
    input   wire              hk_spi_sdi,
    output  wire              hk_spi_sdo,

	// GPIO serial loader programming interface
    output wire               serial_clock,
    output wire               serial_load,
    output wire               serial_resetn,
    output wire               serial_data_1,
    output wire               serial_data_2,

    // Mask revision/User project ID
    input wire [31:0]           mask_rev_in,
	input wire [7:0]			prod_id,

	// Analog control signals 
	// Test points enable/disable connections
   output wire [1:0] ibias_test_to_gpio1_2,
   output wire [1:0] vbg_test_to_gpio1_1,

   // iDAC enable/disable connections
   output wire [1:0] idac_to_gpio1_3,
   output wire [1:0] idac_to_gpio1_2,

   // ADC and DAC reference voltage selection enable/disable connections
   output wire [1:0] adc_refh_to_gpio6_6,
   output wire [1:0] dac_refh_to_gpio1_1,
   output wire [1:0] adc_refl_to_gpio6_7,
   output wire [1:0] dac_refl_to_gpio1_0,

   // Right lp op-amp output enable/disable connections
   output wire [1:0] right_lp_opamp_to_ulpcomp_p,
   output wire [1:0] right_lp_opamp_to_comp_p,
   output wire [1:0] right_lp_opamp_to_adc0,
   output wire [1:0] right_lp_opamp_to_gpio4_7,
   output wire [1:0] right_lp_opamp_to_gpio4_3,
   output wire [1:0] right_lp_opamp_to_analog1,
   output wire [1:0] right_lp_opamp_to_amuxbusB,
   output wire [1:0] right_lp_opamp_to_gpio3_7,
   output wire [1:0] right_lp_opamp_to_gpio3_3,

   // Right hgbw op-amp output enable/disable connections
   output wire [1:0] right_hgbw_opamp_to_ulpcomp_n,
   output wire [1:0] right_hgbw_opamp_to_comp_n,
   output wire [1:0] right_hgbw_opamp_to_adc1,
   output wire [1:0] right_hgbw_opamp_to_gpio4_6,
   output wire [1:0] right_hgbw_opamp_to_gpio4_2,
   output wire [1:0] right_hgbw_opamp_to_analog0,
   output wire [1:0] right_hgbw_opamp_to_amuxbusA,
   output wire [1:0] right_hgbw_opamp_to_gpio3_6,
   output wire [1:0] right_hgbw_opamp_to_gpio3_2,

   // Left hgbw op-amp output enable/disable connections
   output wire [1:0] left_hgbw_opamp_to_ulpcomp_p,
   output wire [1:0] left_hgbw_opamp_to_comp_p,
   output wire [1:0] left_hgbw_opamp_to_adc0,
   output wire [1:0] left_hgbw_opamp_to_gpio4_5,
   output wire [1:0] left_hgbw_opamp_to_gpio4_1,
   output wire [1:0] left_hgbw_opamp_to_analog1,
   output wire [1:0] left_hgbw_opamp_to_amuxbusB,
   output wire [1:0] left_hgbw_opamp_to_gpio3_5,
   output wire [1:0] left_hgbw_opamp_to_gpio3_1,

   // Left lp op-amp output enable/disable connections
   output wire [1:0] left_lp_opamp_to_ulpcomp_n,
   output wire [1:0] left_lp_opamp_to_comp_n,
   output wire [1:0] left_lp_opamp_to_adc1,
   output wire [1:0] left_lp_opamp_to_gpio4_0,
   output wire [1:0] left_lp_opamp_to_analog0,
   output wire [1:0] left_lp_opamp_to_amuxbusA,
   output wire [1:0] left_lp_opamp_to_gpio3_4,

   // Right lp op-amp positive output wire enable/disable connections
   output wire right_lp_opamp_p_to_dac0,
   output wire right_lp_opamp_p_to_analog0,
   output wire right_lp_opamp_p_to_amuxbusA,
   output wire right_lp_opamp_p_to_rheostat_out,
   output wire right_lp_opamp_p_to_sio0,
   output wire right_lp_opamp_p_to_tempsense,
   output wire right_lp_opamp_p_to_left_vref,
   output wire right_lp_opamp_p_to_voutref,
   output wire [1:0] right_lp_opamp_p_to_gpio2_5,

   // Right lp op-amp negative output wire enable/disable connections
   output wire right_lp_opamp_n_to_dac1,
   output wire right_lp_opamp_n_to_analog1,
   output wire right_lp_opamp_n_to_amuxbusB,
   output wire right_lp_opamp_n_to_rheostat_out,
   output wire right_lp_opamp_n_to_rheostat_tap,
   output wire right_lp_opamp_n_to_sio1,
   output wire right_lp_opamp_n_to_vbgtc,
   output wire right_lp_opamp_n_to_right_vref,
   output wire right_lp_opamp_n_to_vinref,
   output wire [1:0] right_lp_opamp_n_to_gpio2_4,

   // Right hgbw op-amp positive output wire enable/disable connections
   output wire [1:0] right_hgbw_opamp_p_to_gpio5_0,
   output wire right_hgbw_opamp_p_to_dac0,
   output wire right_hgbw_opamp_p_to_analog0,
   output wire right_hgbw_opamp_p_to_amuxbusA,
   output wire right_hgbw_opamp_p_to_rheostat_out,
   output wire right_hgbw_opamp_p_to_sio0,
   output wire right_hgbw_opamp_p_to_left_vref,
   output wire right_hgbw_opamp_p_to_voutref,
   output wire [1:0] right_hgbw_opamp_p_to_gpio2_3,

   // Right hgbw op-amp negative output wire enable/disable connections
   output wire [1:0] right_hgbw_opamp_n_to_gpio5_1,
   output wire right_hgbw_opamp_n_to_dac1,
   output wire right_hgbw_opamp_n_to_analog1,
   output wire right_hgbw_opamp_n_to_amuxbusB,
   output wire right_hgbw_opamp_n_to_rheostat_out,
   output wire right_hgbw_opamp_n_to_rheostat_tap,
   output wire right_hgbw_opamp_n_to_sio1,
   output wire right_hgbw_opamp_n_to_vbgsc,
   output wire right_hgbw_opamp_n_to_right_vref,
   output wire right_hgbw_opamp_n_to_vinref,
   output wire [1:0] right_hgbw_opamp_n_to_gpio2_2,

   // Left hgbw op-amp positive output wire enable/disable connections
   output wire [1:0] left_hgbw_opamp_p_to_gpio5_2,
   output wire left_hgbw_opamp_p_to_dac0,
   output wire left_hgbw_opamp_p_to_analog0,
   output wire left_hgbw_opamp_p_to_amuxbusA,
   output wire left_hgbw_opamp_p_to_rheostat_out,
   output wire left_hgbw_opamp_p_to_sio0,
   output wire left_hgbw_opamp_p_to_tempsense,
   output wire left_hgbw_opamp_p_to_left_vref,
   output wire left_hgbw_opamp_p_to_voutref,
   output wire [1:0] left_hgbw_opamp_p_to_gpio2_1,

   // Left hgbw op-amp negative output wire enable/disable connections
   output wire [1:0] left_hgbw_opamp_n_to_gpio5_3,
   output wire left_hgbw_opamp_n_to_dac1,
   output wire left_hgbw_opamp_n_to_analog1,
   output wire left_hgbw_opamp_n_to_amuxbusB,
   output wire left_hgbw_opamp_n_to_rheostat_out,
   output wire left_hgbw_opamp_n_to_rheostat_tap,
   output wire left_hgbw_opamp_n_to_sio1,
   output wire left_hgbw_opamp_n_to_vbgtc,
   output wire left_hgbw_opamp_n_to_right_vref,
   output wire left_hgbw_opamp_n_to_vinref,
   output wire [1:0] left_hgbw_opamp_n_to_gpio2_0,

   // Left lp op-amp positive output wire enable/disable connections
   output wire [1:0] left_lp_opamp_p_to_gpio5_4,
   output wire left_lp_opamp_p_to_dac0,
   output wire left_lp_opamp_p_to_analog0,
   output wire left_lp_opamp_p_to_amuxbusA,
   output wire left_lp_opamp_p_to_rheostat_out,
   output wire left_lp_opamp_p_to_sio0,
   output wire left_lp_opamp_p_to_left_vref,
   output wire left_lp_opamp_p_to_voutref,

   // Left lp op-amp negative output wire enable/disable connections
   output wire [1:0] left_lp_opamp_n_to_gpio5_5,
   output wire left_lp_opamp_n_to_dac1,
   output wire left_lp_opamp_n_to_analog1,
   output wire left_lp_opamp_n_to_amuxbusB,
   output wire left_lp_opamp_n_to_rheostat_out,
   output wire left_lp_opamp_n_to_rheostat_tap,
   output wire left_lp_opamp_n_to_sio1,
   output wire left_lp_opamp_n_to_vbgsc,
   output wire left_lp_opamp_n_to_right_vref,
   output wire left_lp_opamp_n_to_vinref,

   // Left instrumentation amplifier output enable/disable connections
   output wire [1:0] left_instramp_to_ulpcomp_p,
   output wire [1:0] left_instramp_to_comp_p,
   output wire [1:0] left_instramp_to_adc0,
   output wire [1:0] left_instramp_to_gpio4_4,
   output wire [1:0] left_instramp_to_analog1,
   output wire [1:0] left_instramp_to_amuxbusB,

   // Right instrumentation amplifier output enable/disable connections
   output wire [1:0] right_instramp_to_ulpcomp_n,
   output wire [1:0] right_instramp_to_comp_n,
   output wire [1:0] right_instramp_to_adc1,
   output wire [1:0] right_instramp_to_analog0,
   output wire [1:0] right_instramp_to_amuxbusA,
   output wire [1:0] right_instramp_to_gpio3_0,

   // Left instrumentation amplifier negative output wire enable/disable connections
   output wire [1:0] left_instramp_n_to_gpio5_7,
   output wire left_instramp_n_to_analog1,
   output wire left_instramp_n_to_amuxbusB,
   output wire left_instramp_n_to_sio1,
   output wire left_instramp_n_to_right_vref,
   output wire left_instramp_n_to_vinref,

   // Left instrumentation amplifier positive output wire enable/disable connections
   output wire [1:0] left_instramp_p_to_gpio5_6,
   output wire left_instramp_p_to_analog0,
   output wire left_instramp_p_to_amuxbusA,
   output wire left_instramp_p_to_sio0,
   output wire left_instramp_p_to_tempsense,
   output wire left_instramp_p_to_left_vref,
   output wire left_instramp_p_to_voutref,

   // Right instrumentation amplifier negative output wire enable/disable connections
   output wire right_instramp_n_to_analog1,
   output wire right_instramp_n_to_amuxbusB,
   output wire right_instramp_n_to_sio1,
   output wire right_instramp_n_to_right_vref,
   output wire right_instramp_n_to_vinref,
   output wire [1:0] right_instramp_n_to_gpio2_6,

   // Right instrumentation amplifier positive output wire enable/disable connections
   output wire right_instramp_p_to_analog0,
   output wire right_instramp_p_to_amuxbusA,
   output wire right_instramp_p_to_sio0,
   output wire right_instramp_p_to_tempsense,
   output wire right_instramp_p_to_left_vref,
   output wire right_instramp_p_to_voutref,
   output wire [1:0] right_instramp_p_to_gpio2_7,

   // ULP comparator positive output wire enable/disable connections
   output wire ulpcomp_p_to_dac0,
   output wire ulpcomp_p_to_analog1,
   output wire ulpcomp_p_to_sio0,
   output wire ulpcomp_p_to_vbgtc,
   output wire ulpcomp_p_to_tempsense,
   output wire ulpcomp_p_to_left_vref,
   output wire ulpcomp_p_to_voutref,
   output wire [1:0] ulpcomp_p_to_gpio6_0,
   output wire [1:0] ulpcomp_p_to_gpio1_7,

   // ULP comparator negative output wire enable/disable connections
   output wire ulpcomp_n_to_dac1,
   output wire ulpcomp_n_to_analog0,
   output wire ulpcomp_n_to_sio1,
   output wire ulpcomp_n_to_vbgsc,
   output wire ulpcomp_n_to_right_vref,
   output wire ulpcomp_n_to_vinref,
   output wire [1:0] ulpcomp_n_to_gpio6_1,
   output wire [1:0] ulpcomp_n_to_gpio1_6,

   // Comparator positive output wire enable/disable connections
   output wire comp_p_to_dac0,
   output wire comp_p_to_analog1,
   output wire comp_p_to_sio0,
   output wire comp_p_to_vbgtc,
   output wire comp_p_to_tempsense,
   output wire comp_p_to_left_vref,
   output wire comp_p_to_voutref,
   output wire [1:0] comp_p_to_gpio6_2,
   output wire [1:0] comp_p_to_gpio1_5,

   // Comparator negative output wire enable/disable connections
   output wire comp_n_to_dac1,
   output wire comp_n_to_analog0,
   output wire comp_n_to_sio1,
   output wire comp_n_to_vbgsc,
   output wire comp_n_to_right_vref,
   output wire comp_n_to_vinref,
   output wire [1:0] comp_n_to_gpio6_3,
   output wire [1:0] comp_n_to_gpio1_4,

   // ADC0 output wire enable/disable connections
   output wire adc0_to_dac0,
   output wire adc0_to_analog1,
   output wire adc0_to_vbgtc,
   output wire adc0_to_tempsense,
   output wire adc0_to_left_vref,
   output wire adc0_to_voutref,
   output wire [1:0] adc0_to_gpio6_4,
   output wire [1:0] adc0_to_gpio1_3,

   // ADC1 output wire enable/disable connections
   output wire adc1_to_dac1,
   output wire adc1_to_analog0,
   output wire adc1_to_vbgsc,
   output wire adc1_to_right_vref,
   output wire adc1_to_vinref,
   output wire [1:0] adc1_to_gpio6_5,
   output wire [1:0] adc1_to_gpio1_2,

   // SIO pin enable/disable connections
   output wire [1:0] sio0_connect,
   output wire [1:0] sio1_connect,

   // Analog pin enable/disable connections
   output wire [1:0] analog0_connect,
   output wire [1:0] analog1_connect,

   // User project enable/disable connections
   output wire vbgtc_to_user,
   output wire vbgsc_to_user,
   output wire [1:0] user_to_comp_n,
   output wire [1:0] user_to_comp_p,
   output wire [1:0] user_to_ulpcomp_n,
   output wire [1:0] user_to_ulpcomp_p,
   output wire [1:0] user_to_adc0,
   output wire [1:0] user_to_adc1,
   output wire dac0_to_user,
   output wire dac1_to_user,
   output wire tempsense_to_user,
   output wire right_vref_to_user,
   output wire left_vref_to_user,
   output wire vinref_to_user,
   output wire voutref_to_user,

   // Audiodac output connections
   output	wire dac0_to_analog1,
   output	wire dac1_to_analog0,
   output	wire [1:0] audiodac_out_to_analog1,
   output	wire [1:0] audiodac_outb_to_analog0,

   // Instrumentation amplifier (TBD)
   output wire left_instramp_ena,
   output wire [4:0] left_instramp_G1,	// programmable gain
   output wire [4:0] left_instramp_G2,	// programmable gain

   // High gain-bandwidth operational amplifier
   output wire left_hgbw_opamp_ena,

   // Low power operational amplifier (TBD)
   output wire left_lp_opamp_ena,

   // Rheostat 1
   output wire [7:0] left_rheostat1_b,	// programmable tap

   // Rheostat 2
   output wire [7:0] left_rheostat2_b,	// programmable tap

   // Amplifiers right
   // Instrumentation amplifier (TBD)
   output wire right_instramp_ena,
   output wire [4:0] right_instramp_G1,	// programmable gain
   output wire [4:0] right_instramp_G2,	// programmable gain

   // High gain-bandwidth operational amplifier
   output wire right_hgbw_opamp_ena,

   // Low power operational amplifier (TBD)
   output wire right_lp_opamp_ena,

   // Rheostat 1
   output wire [7:0] right_rheostat1_b,	// programmable tap

   // Rheostat 2
   output wire [7:0] right_rheostat2_b,	// programmable tap

   // Comparator
   output wire  comp_ena,
   output wire [5:0] comp_trim,	// offset trim
   output wire [1:0] comp_hyst,	// hysteresis trim
   input wire      comp_out,	// comparator output wire
   
   // Ultra-low-power comparator
   output wire  ulpcomp_ena,
   output wire ulpcomp_clk,
   input wire  ulpcomp_out,		// comparator output wire

   // Bandgap
   output wire  bandgap_ena,
   output wire [15:0] bandgap_trim,		// bandgap trim
   output wire bandgap_sel,

   // LDO
   output wire  ldo_ena,

   // Bias current generator
   output wire	ibias_ena,		// bias generator master enable
   output wire [23:0] ibias_src_ena,		// bias generator individual source enables
   output wire [3:0]	ibias_snk_ena,		// bias generator individual sink enables
   output wire	ibias_ref_select,	// bias reference voltage selection

   // Overvoltage detector
   output wire overvoltage_ena,
   output wire [3:0] overvoltage_trim,	// overvoltage trip point set
   output wire	ldo_ref_sel,
   input wire overvoltage_out,		// overvoltage alarm

    // 12-bit Current DAC (TBD)
   output wire [11:0] idac_value,
   output wire  idac_ena,

   // Temperature sensor
   output wire tempsense_ena,
   output wire tempsense_sel,

   // Voltage detector 0
   input wire vdda1_pwr_good,		// power good signal
   input wire vccd1_pwr_good,		// power good signal

   // Voltage detector 1
   input wire vdda2_pwr_good,		// power good signal
   input wire vccd2_pwr_good,		// power good signal

   // 12-bit RDAC 0
   output wire rdac0_ena,
   output wire [11:0] rdac0_value,

   // 12-bit RDAC 1
   output wire rdac1_ena,
  output wire [11:0] rdac1_value,

  // Brownout detector
  output wire brownout_ena,		// brownout detector enable
  output wire [2:0] brownout_vtrip,	// brownout detector trip point
  output wire [2:0] brownout_otrip,	// brownout detector trip point
  output wire brownout_isrc_sel,	// brownout detector select current bias
  output wire brownout_oneshot,	// brownout detector force short one-shot
  output wire brownout_rc_ena,	// brownout detector force oscillator enabled
  output wire brownout_rc_dis,	// brownout detector force oscillator disabled

  input wire brownout_vunder,	// brownout detector undervoltage alarm
  input wire brownout_timeout,	// brownout detector timeout
  input wire brownout_filt,	// brownout detector undervoltage (filtered)
  input wire brownout_unfilt,	// brownout detector undervoltage (unfiltered)

   // System Registers
   output wire  vref_e_vrefgen_en,
   output wire  vref_w_vrefgen_en,
   output wire  [4:0] vref_e_ref_sel,
   output wire  [4:0] vref_w_ref_sel,
   output wire  muxsplit_se_switch_aa_sl,
   output wire  muxsplit_se_switch_aa_s0,
   output wire  muxsplit_se_switch_bb_s0,
   output wire  muxsplit_se_switch_bb_sl,
   output wire  muxsplit_se_switch_bb_sr,
   output wire  muxsplit_se_switch_aa_sr,
   output wire  muxsplit_sw_switch_aa_sl,
   output wire  muxsplit_sw_switch_aa_s0,
   output wire  muxsplit_sw_switch_bb_s0,
   output wire  muxsplit_sw_switch_bb_sl,
   output wire  muxsplit_sw_switch_bb_sr,
   output wire  muxsplit_sw_switch_aa_sr,
   output wire  muxsplit_ne_switch_aa_sl,
   output wire  muxsplit_ne_switch_aa_s0,
   output wire  muxsplit_ne_switch_bb_s0,
   output wire  muxsplit_ne_switch_bb_sl,
   output wire  muxsplit_ne_switch_bb_sr,
   output wire  muxsplit_ne_switch_aa_sr,
   output wire  muxsplit_nw_switch_aa_sl,
   output wire  muxsplit_nw_switch_aa_s0,
   output wire  muxsplit_nw_switch_bb_s0,
   output wire  muxsplit_nw_switch_bb_sl,
   output wire  muxsplit_nw_switch_bb_sr,
   output wire  muxsplit_nw_switch_aa_sr,
   output wire  user_ahb_enable,
   output wire [15:0] user_irqs_enable,
   output wire	[5:0]	sio_cfg,
   input  wire mgmt_select

);


// rst clk 
`ifndef FPGA
	wire rst_n;
	wire clk;
`endif	

assign HCLK_out = clk;
assign HRESETn_out = rst_n;

// flash controller
wire fr_sck;
wire fr_ce_n;
wire [3:0] fr_din;
wire [3:0] fr_dout;
wire [3:0] fr_douten;

localparam N_HARTS = 1;
localparam XLEN = 32;

wire                      sys_reset_req;
wire                      sys_reset_done;
wire [N_HARTS-1:0]        hart_reset_req;
wire [N_HARTS-1:0]        hart_reset_done;

wire [N_HARTS-1:0]        hart_req_halt;
wire [N_HARTS-1:0]        hart_req_halt_on_reset;
wire [N_HARTS-1:0]        hart_req_resume;
wire [N_HARTS-1:0]        hart_halted;
wire [N_HARTS-1:0]        hart_running;

wire [N_HARTS*XLEN-1:0]   hart_data0_rdata;
wire [N_HARTS*XLEN-1:0]   hart_data0_wdata;
wire [N_HARTS-1:0]        hart_data0_wen;

wire [N_HARTS*XLEN-1:0]   hart_instr_data;
wire [N_HARTS-1:0]        hart_instr_data_vld;
wire [N_HARTS-1:0]        hart_instr_data_rdy;
wire [N_HARTS-1:0]        hart_instr_caught_exception;
wire [N_HARTS-1:0]        hart_instr_caught_ebreak;

wire [31:0]               sbus_addr;
wire                      sbus_write;
wire [1:0]                sbus_size;
wire                      sbus_vld;
wire                      sbus_rdy;
wire                      sbus_err;
wire [31:0]               sbus_wdata;
wire [31:0]               sbus_rdata;

hazard3_dm #(
	.N_HARTS      (N_HARTS),
	.HAVE_SBA     (0),
	.NEXT_DM_ADDR (0)
) dm (
	.clk                         (clk),
	.rst_n                       (rst_n),

	.dmi_psel                    (dmi_psel),
	.dmi_penable                 (dmi_penable),
	.dmi_pwrite                  (dmi_pwrite),
	.dmi_paddr                   (dmi_paddr),
	.dmi_pwdata                  (dmi_pwdata),
	.dmi_prdata                  (dmi_prdata),
	.dmi_pready                  (dmi_pready),
	.dmi_pslverr                 (dmi_pslverr),

	.sys_reset_req               (sys_reset_req),
	.sys_reset_done              (sys_reset_done),
	.hart_reset_req              (hart_reset_req),
	.hart_reset_done             (hart_reset_done),

	.hart_req_halt               (hart_req_halt),
	.hart_req_halt_on_reset      (hart_req_halt_on_reset),
	.hart_req_resume             (hart_req_resume),
	.hart_halted                 (hart_halted),
	.hart_running                (hart_running),

	.hart_data0_rdata            (hart_data0_rdata),
	.hart_data0_wdata            (hart_data0_wdata),
	.hart_data0_wen              (hart_data0_wen),

	.hart_instr_data             (hart_instr_data),
	.hart_instr_data_vld         (hart_instr_data_vld),
	.hart_instr_data_rdy         (hart_instr_data_rdy),
	.hart_instr_caught_exception (hart_instr_caught_exception),
	.hart_instr_caught_ebreak    (hart_instr_caught_ebreak),

	.sbus_addr                   (sbus_addr),
	.sbus_write                  (sbus_write),
	.sbus_size                   (sbus_size),
	.sbus_vld                    (sbus_vld),
	.sbus_rdy                    (sbus_rdy),
	.sbus_err                    (sbus_err),
	.sbus_wdata                  (sbus_wdata),
	.sbus_rdata                  (sbus_rdata)
);


// Generate resynchronised reset for CPU based on upstream system reset and on
// system/hart reset requests from DM.

wire assert_cpu_reset = !rst_n || sys_reset_req || hart_reset_req[0];
wire rst_n_cpu;

reset_sync cpu_reset_sync (
	.clk       (clk),
	.rst_n_in  (!assert_cpu_reset),
	.rst_n_out (rst_n_cpu)
);

// Reset handshake: Currently simplified implementation.
// TODO: For production, consider adding proper resynchronization to DM's reset domain
// and ensuring DM waits for a rising edge after asserting reset to prevent the tail
// of the previous "done" signal from being passed on. This would improve robustness
// in multi-domain reset scenarios.
assign sys_reset_done = rst_n_cpu;
assign hart_reset_done = rst_n_cpu;

// ----------------------------------------------------------------------------------------------------
// Processor

wire [W_ADDR-1:0] proc_i_haddr;
wire              proc_i_hwrite;
wire [1:0]        proc_i_htrans;
wire [2:0]        proc_i_hsize;
wire [2:0]        proc_i_hburst;
wire [3:0]        proc_i_hprot;
wire              proc_i_hmastlock;
wire [7:0]        proc_i_hmaster;       //??
// wire              proc_i_hexcl;
wire              proc_i_hready;
wire              proc_i_hresp;
// wire              proc_i_hexokay = 1'b1; // No global monitor
wire [W_DATA-1:0] proc_i_hwdata;
wire [W_DATA-1:0] proc_i_hrdata;


wire [W_ADDR-1:0] proc_d_haddr;
wire              proc_d_hwrite;
wire [1:0]        proc_d_htrans;
wire [2:0]        proc_d_hsize;
wire [2:0]        proc_d_hburst;
wire [3:0]        proc_d_hprot;
wire              proc_d_hmastlock;
wire [7:0]        proc_d_hmaster;       //??
wire              proc_d_hexcl;
wire              proc_d_hready;
wire              proc_d_hresp;
wire              proc_d_hexokay = 1'b1; // No global monitor
wire [W_DATA-1:0] proc_d_hwdata;
wire [W_DATA-1:0] proc_d_hrdata;

wire              pwrup_req;
wire              unblock_out;


wire              dmac_irq;
wire              gpioA_irq;
wire              gpioB_irq;
wire              gpioC_irq;
wire              gpioD_irq;
wire              gpioE_irq;
wire              gpioF_irq;
wire              gpioG_irq;
wire              gpioH_irq;
wire              gpioI_irq;
wire              uart0_irq;
wire              uart1_irq;
wire              uart2_irq;
wire              uart3_irq;
wire              tmr0_irq;
wire              tmr1_irq;
wire              tmr2_irq;
wire			  tmr3_irq;
wire			  tmr4_irq;
wire			  tmr5_irq;
wire			  wdt0_irq;
wire              spi0_irq;
wire   			  spi1_irq;
wire              i2c0_irq;
wire  			  i2c1_irq;
wire              i2s0_irq;
wire              adc0_irq;
wire              adc1_irq;
wire              audiodac0_irq;
wire      		  usb_irq;
wire  			  can0_irq;

wire              timer_irq;

wire  			hk_spi_irq;	

//IRQ		peripheral
//0			DMAC


//3-7		Not assigned (tie low)
//8			GPIO Port A
//9			GPIO Port B
//10		GPIO Port C
//11		UART0
//12		UART2
//13		UART3
//14		UART4
//15		TCC0
//16		TCC1
//17		TCC2
//18		TCC3
//19		WDT
//20		SPI0
//21		SPI1
//22		I2C0
//23		I2C1
//24		I2S0
//25		I2S1
//26		ADC0
//27		DAC0
//28		DAC1
//29		ACMP0
//30		USB_CDC
//31		Not assigned (tie low)


wire [63:0] 		IRQs;

wire  				hkrst;   
wire				pclk;   
wire        		usb_clk; 

assign IRQs = { user_irqs, hk_spi_irq, can0_irq, audiodac0_irq, adc1_irq, adc0_irq , i2s0_irq, i2c1_irq ,i2c0_irq, spi1_irq ,spi0_irq, wdt0_irq, tmr5_irq , tmr4_irq , tmr3_irq ,tmr2_irq, tmr1_irq, tmr0_irq, uart3_irq, uart2_irq, uart1_irq, uart0_irq ,gpioI_irq ,gpioH_irq ,gpioG_irq ,gpioF_irq ,gpioE_irq ,gpioD_irq , gpioC_irq ,gpioB_irq, gpioA_irq, usb_irq ,dmac_irq};

hazard3_cpu_2port #(
// These must have the values given here for you to end up with a useful SoC:
	.RESET_VECTOR    (32'h0000_0040),
	.MTVEC_INIT      (32'h0000_0000),
	.CSR_M_MANDATORY (1),
	.CSR_M_TRAP      (1),
	.DEBUG_SUPPORT   (1),
	.NUM_IRQS        (64),  
	.RESET_REGFILE   (1),
	// Can be overridden from the defaults in hazard3_config.vh during
	// instantiation of example_soc():
	.EXTENSION_A         (EXTENSION_A),
	.EXTENSION_C         (EXTENSION_C),
	.EXTENSION_M         (EXTENSION_M),
	.EXTENSION_ZBA       (EXTENSION_ZBA),
	.EXTENSION_ZBB       (EXTENSION_ZBB),
	.EXTENSION_ZBC       (EXTENSION_ZBC),
	.EXTENSION_ZBS       (EXTENSION_ZBS),
	.EXTENSION_ZBKB      (EXTENSION_ZBKB),
	.EXTENSION_ZIFENCEI  (EXTENSION_ZIFENCEI),
	.EXTENSION_XH3BEXTM  (EXTENSION_XH3BEXTM),
	.EXTENSION_XH3IRQ    (EXTENSION_XH3IRQ),
	.EXTENSION_XH3PMPM   (EXTENSION_XH3PMPM),
	.EXTENSION_XH3POWER  (EXTENSION_XH3POWER),
	.CSR_COUNTER         (CSR_COUNTER),
	.U_MODE              (U_MODE),
	.PMP_REGIONS         (PMP_REGIONS),
	.PMP_GRAIN           (PMP_GRAIN),
	.PMP_HARDWIRED       (PMP_HARDWIRED),
	.PMP_HARDWIRED_ADDR  (PMP_HARDWIRED_ADDR),
	.PMP_HARDWIRED_CFG   (PMP_HARDWIRED_CFG),
	.MVENDORID_VAL       (MVENDORID_VAL),
	.BREAKPOINT_TRIGGERS (BREAKPOINT_TRIGGERS),
	.IRQ_PRIORITY_BITS   (IRQ_PRIORITY_BITS),
	.MIMPID_VAL          (MIMPID_VAL),
	.MHARTID_VAL         (MHARTID_VAL),
	.REDUCED_BYPASS      (REDUCED_BYPASS),
	.MULDIV_UNROLL       (MULDIV_UNROLL),
	.MUL_FAST            (MUL_FAST),
	.MUL_FASTER          (MUL_FASTER),
	.MULH_FAST           (MULH_FAST),
	.FAST_BRANCHCMP      (FAST_BRANCHCMP),
	.BRANCH_PREDICTOR    (BRANCH_PREDICTOR),
	.MTVEC_WMASK         (MTVEC_WMASK)
) cpu (
	// Global signals
	.clk                        (clk),
	.clk_always_on              (clk),
	.rst_n                      (rst_n_cpu),

	// Power control signals
	.pwrup_req                  (pwrup_req),
	.pwrup_ack                  (pwrup_req),   // Tied back
	.clk_en                     (/* unused */),
	.unblock_out                (unblock_out),
	.unblock_in                 (unblock_out), // Tied back

	// Instruction fetch port
	.i_haddr                    (proc_i_haddr),
	.i_hwrite                   (proc_i_hwrite),
	.i_htrans                   (proc_i_htrans),
	.i_hsize                    (proc_i_hsize),
	.i_hburst                   (proc_i_hburst),
	.i_hprot                    (proc_i_hprot),
	.i_hmastlock                (proc_i_hmastlock),
	.i_hmaster                  (proc_i_hmaster),
	.i_hready                   (proc_i_hready),
	.i_hresp                    (proc_i_hresp),
	.i_hwdata                   (proc_i_hwdata),
	.i_hrdata                   (proc_i_hrdata),

	// Load/store portproc_
	.d_haddr                    (proc_d_haddr),
	.d_hwrite                   (proc_d_hwrite),
	.d_htrans                   (proc_d_htrans),
	.d_hsize                    (proc_d_hsize),
	.d_hburst                   (proc_d_hburst),
	.d_hprot                    (proc_d_hprot),
	.d_hmastlock                (proc_d_hmastlock),
	.d_hmaster                  (proc_d_hmaster),
	.d_hexcl                    (proc_d_hexcl),
	.d_hready                   (proc_d_hready),
	.d_hresp                    (proc_d_hresp),
	.d_hexokay                  (proc_d_hexokay),
	.d_hwdata                   (proc_d_hwdata),
	.d_hrdata                   (proc_d_hrdata),

	// Debugger run/halt control
	.dbg_req_halt               (hart_req_halt),
	.dbg_req_halt_on_reset      (hart_req_halt_on_reset),
	.dbg_req_resume             (hart_req_resume),
	.dbg_halted                 (hart_halted),
	.dbg_running                (hart_running),
	// Debugger access to data0 CSR
	.dbg_data0_rdata            (hart_data0_rdata),
	.dbg_data0_wdata            (hart_data0_wdata),
	.dbg_data0_wen              (hart_data0_wen),
	// Debugger instruction injection
	.dbg_instr_data             (hart_instr_data),
	.dbg_instr_data_vld         (hart_instr_data_vld),
	.dbg_instr_data_rdy         (hart_instr_data_rdy),
	.dbg_instr_caught_exception (hart_instr_caught_exception),
	.dbg_instr_caught_ebreak    (hart_instr_caught_ebreak),
	// Optional debug system bus access patch-through
	.dbg_sbus_addr              (sbus_addr),
	.dbg_sbus_write             (sbus_write),
	.dbg_sbus_size              (sbus_size),
	.dbg_sbus_vld               (sbus_vld),
	.dbg_sbus_rdy               (sbus_rdy),
	.dbg_sbus_err               (sbus_err),
	.dbg_sbus_wdata             (sbus_wdata),
	.dbg_sbus_rdata             (sbus_rdata),

	// Level-sensitive interrupt sources
	.irq                        (IRQs),

	.soft_irq                   (1'b0),
	.timer_irq                  (timer_irq)
);

//----------------------------------------------------------------------------------------------
// DMAC

wire [W_ADDR-1:0] dmac_M_haddr;
wire              dmac_M_hwrite;
wire [1:0]        dmac_M_htrans;
wire [2:0]        dmac_M_hsize;
wire [2:0]        dmac_M_hburst;
wire [3:0]        dmac_M_hprot;
wire              dmac_M_hmastlock;
// wire              dmac_M_hexcl;
wire              dmac_M_hready;
wire              dmac_M_hresp;
wire              dmac_M_hexokay = 1'b1; // No global monitor
wire [W_DATA-1:0] dmac_M_hwdata;
wire [W_DATA-1:0] dmac_M_hrdata;

wire               dmac_S_hready_resp;
wire               dmac_S_hready;
wire               dmac_S_hresp;
wire [W_ADDR-1:0]  dmac_S_haddr;
wire               dmac_S_hwrite;
wire [1:0]         dmac_S_htrans;
wire [2:0]         dmac_S_hsize;
wire [2:0]         dmac_S_hburst;
wire [3:0]         dmac_S_hprot;
wire               dmac_S_hmastlock;
wire [W_DATA-1:0]  dmac_S_hwdata;
wire [W_DATA-1:0]  dmac_S_hrdata;


dmac_AHBL DMAC_u(
    .HCLK                       (clk),
    .HRESETn                    (rst_n),

    .IRQ                        (dmac_irq),    
    // AHB-Lite Slave Iterface
    .sHSEL                       (1'b1),
    .sHADDR                      (dmac_S_haddr),
    .sHTRANS                     (dmac_S_htrans),
    .sHWRITE                     (dmac_S_hwrite),
    .sHREADY                     (dmac_S_hready),
    .sHWDATA                     (dmac_S_hwdata),
    .sHSIZE                      (dmac_S_hsize),
    .sHREADYOUT                  (dmac_S_hready_resp),
    .sHRDATA                     (dmac_S_hrdata),
    // AHB-Lite Master nterface
    .mHADDR                    (dmac_M_haddr),
    .mHTRANS                   (dmac_M_htrans),
    .mHSIZE                    (dmac_M_hsize),
    .mHWRITE                   (dmac_M_hwrite),
    .mHWDATA                   (dmac_M_hwdata),
    .mHREADY                   (dmac_M_hready),
    .mHRDATA                   (dmac_M_hrdata),
	.PIRQ                      ({IRQs[33],IRQs[32],IRQs[24],IRQs[26],IRQs[22],IRQs[12:11],IRQs[1]}) // [user1,user0,i2c,i2s,spi,uart1,uart0,usb]

);

//--------------------------------------------------------------------------------------------------------------------------
// AHB crossbar 
// - flash ctrl at...  0x0000_0000
// - AHB 0 at........  0x2000_0000
// - AHB 1 at........  0x4000_0000

wire               flash_hready_resp;
wire               flash_hready;
wire               flash_hresp;
wire [W_ADDR-1:0]  flash_haddr;
wire               flash_hwrite;
wire [1:0]         flash_htrans;
wire [2:0]         flash_hsize;
wire [2:0]         flash_hburst;
wire [3:0]         flash_hprot;
wire               flash_hmastlock;
wire [W_DATA-1:0]  flash_hwdata;
wire [W_DATA-1:0]  flash_hrdata;
// wire [3:0]		fdi;
// wire [3:0]    	fdo;
// wire [3:0]      fdio;
// wire [3:0]	    fdoe;

wire               ahb_0_hready_resp;
wire               ahb_0_hready;
wire               ahb_0_hresp;
wire [W_ADDR-1:0]  ahb_0_haddr;
wire               ahb_0_hwrite;
wire [1:0]         ahb_0_htrans;
wire [2:0]         ahb_0_hsize;
wire [2:0]         ahb_0_hburst;
wire [3:0]         ahb_0_hprot;
wire               ahb_0_hmastlock;
wire [W_DATA-1:0]  ahb_0_hwdata;
wire [W_DATA-1:0]  ahb_0_hrdata;

wire               ahb_1_hready_resp;
wire               ahb_1_hready;
wire               ahb_1_hresp;
wire [W_ADDR-1:0]  ahb_1_haddr;
wire               ahb_1_hwrite;
wire [1:0]         ahb_1_htrans;
wire [2:0]         ahb_1_hsize;
wire [2:0]         ahb_1_hburst;
wire [3:0]         ahb_1_hprot;
wire               ahb_1_hmastlock;
wire [W_DATA-1:0]  ahb_1_hwdata;
wire [W_DATA-1:0]  ahb_1_hrdata;

ahbl_crossbar #(
	.N_MASTERS (3),
	.N_SLAVES (4),
	.W_ADDR(32),
	.W_DATA (32),

	.ADDR_MAP  (128'h00000000_20000000_40000000_60000000),
	.ADDR_MASK (128'hF0000000_F0000000_F0000000_F0000000)
) xbar (
	// Global signals
	.clk(clk),
    .rst_n(rst_n),

    .src_hready_resp ({  dmac_M_hready     , proc_i_hready     , proc_d_hready    }),
	.src_hresp       ({  dmac_M_hresp      , proc_i_hresp      , proc_d_hresp     }),
	.src_haddr       ({  dmac_M_haddr      , proc_i_haddr      , proc_d_haddr     }),
	.src_hwrite      ({  dmac_M_hwrite     , proc_i_hwrite     , proc_d_hwrite    }),
	.src_htrans      ({  dmac_M_htrans     , proc_i_htrans     , proc_d_htrans    }),
	.src_hsize       ({  dmac_M_hsize      , proc_i_hsize      , proc_d_hsize     }),
	.src_hburst      ({  dmac_M_hburst     , proc_i_hburst     , proc_d_hburst    }),
	.src_hprot       ({  dmac_M_hprot      , proc_i_hprot      , proc_d_hprot     }),
	.src_hmastlock   ({  dmac_M_hmastlock  , proc_i_hmastlock  , proc_d_hmastlock }),
	.src_hwdata      ({  dmac_M_hwdata     , proc_i_hwdata     , proc_d_hwdata    }),
	.src_hrdata      ({  dmac_M_hrdata     , proc_i_hrdata     , proc_d_hrdata    }),

	// To slaves; function as master ports
	.dst_hready      ({  flash_hready      , ahb_0_hready      , ahb_1_hready      ,  ahb_2_hready      }),
	.dst_hready_resp ({  flash_hready_resp , ahb_0_hready_resp , ahb_1_hready_resp ,  ahb_2_hready_resp }),
	.dst_hresp       ({  flash_hresp       , ahb_0_hresp       , ahb_1_hresp       ,  ahb_2_hresp       }),
	.dst_haddr       ({  flash_haddr       , ahb_0_haddr       , ahb_1_haddr       ,  ahb_2_haddr       }),
	.dst_hwrite      ({  flash_hwrite      , ahb_0_hwrite      , ahb_1_hwrite      ,  ahb_2_hwrite      }),
	.dst_htrans      ({  flash_htrans      , ahb_0_htrans      , ahb_1_htrans      ,  ahb_2_htrans      }),
	.dst_hsize       ({  flash_hsize       , ahb_0_hsize       , ahb_1_hsize       ,  ahb_2_hsize       }),
	.dst_hburst      ({  flash_hburst      , ahb_0_hburst      , ahb_1_hburst      ,  ahb_2_hburst      }),
	.dst_hprot       ({  flash_hprot       , ahb_0_hprot       , ahb_1_hprot       ,  ahb_2_hprot       }),
	.dst_hmastlock   ({  flash_hmastlock   , ahb_0_hmastlock   , ahb_1_hmastlock   ,  ahb_2_hmastlock   }),
	.dst_hwdata      ({  flash_hwdata      , ahb_0_hwdata      , ahb_1_hwdata      ,  ahb_2_hwdata      }),
	.dst_hrdata      ({  flash_hrdata      , ahb_0_hrdata      , ahb_1_hrdata      ,  ahb_2_hrdata      })
);
//------------------------------------------------------------------------------------------------------------------------------

  // Peripherals ports
  wire [191:0] 	p_in, p_out, p_oeb;
  wire [3:0] 	NC[47:0];

  // GPIO port A 
  wire [7:0]	gpioA_io_in;
  wire [7:0]	gpioA_io_out;
  wire [7:0]	gpioA_io_oe;

  // GPIO port B 
  wire [7:0]	gpioB_io_in;
  wire [7:0]	gpioB_io_out;
  wire [7:0]	gpioB_io_oe;

  // GPIO port C
  wire [7:0]	gpioC_io_in;
  wire [7:0]	gpioC_io_out;
  wire [7:0]	gpioC_io_oe;

  // GPIO port D
  wire [7:0]	gpioD_io_in;
  wire [7:0]	gpioD_io_out;
  wire [7:0]	gpioD_io_oe;

  // GPIO port E
  wire [7:0]	gpioE_io_in;
  wire [7:0]	gpioE_io_out;
  wire [7:0]	gpioE_io_oe;

  // GPIO port F
  wire [7:0]	gpioF_io_in;
  wire [7:0]	gpioF_io_out;
  wire [7:0]	gpioF_io_oe;


 
  generate
	genvar i;
	for(i=0; i<8;i=i+1) begin
        assign gpioA_io_in[i] = p_in[4*i];
        assign p_out[4*i] = gpioA_io_out[i];
        assign p_oeb[4*i] = ~{gpioA_io_oe[i]};
	end

    for(i=8; i<16;i=i+1) begin
        assign gpioB_io_in[i-8] = p_in[4*i];
        assign p_out[4*i] = gpioB_io_out[i-8];
        assign p_oeb[4*i] = ~{gpioB_io_oe[i-8]};
	end

	for(i=16; i<24;i=i+1) begin
        assign gpioC_io_in[i-16] = p_in[4*i];
        assign p_out[4*i] = gpioC_io_out[i-16];
        assign p_oeb[4*i] = ~{gpioC_io_oe[i-16]};
	end

	for(i=24; i<32;i=i+1) begin
        assign gpioD_io_in[i-24] = p_in[4*i];
        assign p_out[4*i] = gpioD_io_out[i-24];
        assign p_oeb[4*i] = ~{gpioD_io_oe[i-24]};
	end

	for(i=32; i<40;i=i+1) begin
        assign gpioE_io_in[i-32] = p_in[4*i];
        assign p_out[4*i] = gpioE_io_out[i-32];
        assign p_oeb[4*i] = ~{gpioE_io_oe[i-32]};
	end

	for(i=40; i<48;i=i+1) begin
        assign gpioF_io_in[i-40] = p_in[4*i];
        assign p_out[4*i] = gpioF_io_out[i-40];
        assign p_oeb[4*i] = ~{gpioF_io_oe[i-40]};
	end

  endgenerate

// Function 1 

	// UART0   
	wire	uart0_tx, uart0_rx;
	// output
	assign p_out[1] = uart0_tx;
	assign p_oeb[1] = 1'b0;
	assign NC[0][1]  = p_in[0];
	//input 
	assign uart0_rx = p_in[5];
	assign p_out[5] = 1'b0;
	assign p_oeb[5] = 1'b1;

	// TMR0
	wire   tmr0_pwm0, tmr0_pwm1, tmr0_pwm_fault;
	//output 
	assign p_out[9]  = tmr0_pwm0;
	assign p_out[13] = tmr0_pwm1;
	assign {p_oeb[9], p_oeb[13]} = 2'b00;
	assign NC[2][1] = p_in[9];
	assign NC[3][1] = p_in[13];
	//input 
	assign tmr0_pwm_fault = p_in[17];
	assign p_out[17] = 1'b0;
	assign p_oeb[17] = 1'b1;

	//I2S0
	wire i2s0_ws, i2s0_sck, i2s0_sdi;
  	// output
	assign p_out[21] = i2s0_ws;
	assign p_out[25] = i2s0_sck;
	assign {p_oeb[21] , p_oeb[25]} = 2'b00;
	assign NC[5][1] = p_in[21];
	assign NC[6][1] = p_in[25];
  	// input
	assign i2s0_sdi = p_in[29];
	assign p_out[29] = 1'b0;  
	assign p_oeb[29] = 1'b1;  

	// PSRAM controller
	wire      	psram_sck;
	wire      	psram_ce_n;
	wire [3:0]	psram_din;
	wire [3:0]	psram_dout;
	wire [3:0]	psram_douten;
  	// output
	assign p_out[33] = psram_ce_n;
	assign p_out[37] = psram_sck;
	assign {p_oeb[33], p_oeb[37]} = 2'b00;
	assign NC[8][1] = p_in[33];
	assign NC[9][1] = p_in[37];
  	// inout
	assign psram_din[3] = p_in[41];
	assign psram_din[2] = p_in[45];
	assign psram_din[1] = p_in[49];
	assign psram_din[0] = p_in[53];
	assign p_out[41]    = psram_dout[3]; 
	assign p_out[45]    = psram_dout[2]; 
	assign p_out[49]    = psram_dout[1]; 
	assign p_out[53]    = psram_dout[0]; 
	assign p_oeb[41]    = ~{psram_douten[3]}; 
	assign p_oeb[45]    = ~{psram_douten[2]}; 
	assign p_oeb[49]    = ~{psram_douten[1]}; 
	assign p_oeb[53]    = ~{psram_douten[0]}; 

  	//I2C0
	wire   i2c0_scl_i, i2c0_scl_o, i2c0_scl_oen_o;
	wire   i2c0_sda_i, i2c0_sda_o, i2c0_sda_oen_o;
  	// output
	assign i2c0_sda_i = p_in[57];
	assign p_out[57]  = i2c0_sda_o;
	assign p_oeb[57]  = i2c0_sda_oen_o;
	assign i2c0_scl_i = p_in[61];
	assign p_out[61] = i2c0_scl_o;
	assign p_oeb[61] = i2c0_scl_oen_o;

	// SPI0 
	wire   spi0_MOSI, spi0_SSn, spi0_SCK;
	// output
	assign p_out[65] = spi0_SCK;
	assign p_out[69] = spi0_SSn;
	assign p_out[73] = spi0_MOSI;
	assign {p_oeb[65], p_oeb[69], p_oeb[73]} = 3'b000;
	assign NC[16][1]  = p_in[65];
	assign NC[17][1]  = p_in[69];
	assign NC[18][1] = p_in[73];
	// input
	wire   spi0_MISO;
	assign spi0_MISO = p_in[77];
	assign p_out[77] = 1'b0;
	assign p_oeb[77] = 1'b1;

	// UART1   
	wire	uart1_tx, uart1_rx;
	// output
	assign p_out[81] = uart1_tx;
	assign p_oeb[81] = 1'b0;
	assign NC[20][1]  = p_in[81];
	//input 
	assign uart1_rx = p_in[85];
	assign p_out[85] = 1'b0;
	assign p_oeb[85] = 1'b1;

	//I2C1
	wire   i2c1_scl_i, i2c1_scl_o, i2c1_scl_oen_o;
	wire   i2c1_sda_i, i2c1_sda_o, i2c1_sda_oen_o;
  	// output
	assign i2c1_sda_i = p_in[89];
	assign p_out[89]  = i2c1_sda_o;
	assign p_oeb[89]  = i2c1_sda_oen_o;
	assign i2c1_scl_i = p_in[93];
	assign p_out[93] = i2c1_scl_o;
	assign p_oeb[93] = i2c1_scl_oen_o;

	// TMR1
	wire   tmr1_pwm0, tmr1_pwm1, tmr1_pwm_fault;
	//output 
	assign p_out[97]  = tmr1_pwm0;
	assign p_out[101] = tmr1_pwm1;
	assign {p_oeb[97], p_oeb[101]} = 2'b00;
	assign NC[24][1] = p_in[97];
	assign NC[25][1] = p_in[101];
	//input 
	assign tmr1_pwm_fault = p_in[105];
	assign p_out[105] = 1'b0;
	assign p_oeb[105] = 1'b1;


	// UART2   
	wire	uart2_tx, uart2_rx;
	// output
	assign p_out[121] = uart2_tx;
	assign p_oeb[121] = 1'b0;
	assign NC[30][1]  = p_in[121];
	//input 
	assign uart2_rx = p_in[125];
	assign p_out[125] = 1'b0;
	assign p_oeb[125] = 1'b1;

	// SPI1 
	wire   spi1_MOSI, spi1_SSn, spi1_SCK;
	// output
	assign p_out[129] = spi1_SCK;
	assign p_out[133] = spi1_SSn;
	assign p_out[137] = spi1_MOSI;
	assign {p_oeb[129], p_oeb[133], p_oeb[137]} = 3'b000;
	assign NC[32][1]  = p_in[129];
	assign NC[33][1]  = p_in[133];
	assign NC[34][1]  = p_in[137];
	// input
	wire   spi1_MISO;
	assign spi1_MISO = p_in[141];
	assign p_out[141] = 1'b0;
	assign p_oeb[141] = 1'b1;

	// UART3   
	wire	uart3_tx, uart3_rx;
	// output
	assign p_out[145] = uart3_tx;
	assign p_oeb[145] = 1'b0;
	assign NC[36][1]  = p_in[145];
	//input 
	assign uart3_rx = p_in[149];
	assign p_out[149] = 1'b0;
	assign p_oeb[149] = 1'b1;

	// TMR2
	wire   tmr2_pwm0, tmr2_pwm1, tmr2_pwm_fault;
	//output 
	assign p_out[161] = tmr2_pwm0;
	assign p_out[165] = tmr2_pwm1;
	assign {p_oeb[161], p_oeb[165]} = 2'b00;
	assign NC[40][1] = p_in[161];
	assign NC[41][1] = p_in[165];
	//input 
	assign tmr2_pwm_fault = p_in[169];
	assign p_out[169] = 1'b0;
	assign p_oeb[169] = 1'b1;

	// TMR3
	wire   tmr3_pwm0, tmr3_pwm1, tmr3_pwm_fault;
	//output 
	assign p_out[173] = tmr3_pwm0;
	assign p_out[177] = tmr3_pwm1;
	assign {p_oeb[173], p_oeb[177]} = 2'b00;
	assign NC[43][1] = p_in[173];
	assign NC[44][1] = p_in[177];
	//input 
	assign tmr3_pwm_fault = p_in[181];
	assign p_out[181] = 1'b0;
	assign p_oeb[181] = 1'b1;

	// CAN0   
	wire	can0_tx, can0_rx;
	// output
	assign p_out[185] = can0_tx;
	assign p_oeb[185] = 1'b0;
	assign NC[46][1]  = p_in[185];
	//input 
	assign can0_rx = p_in[189];
	assign p_out[189] = 1'b0;
	assign p_oeb[189] = 1'b1;

// Function 2

	// clk redirect 
	wire clk_mon;
	assign p_out[2] = clk_mon;
	assign p_oeb[2] = 1'b0;
	assign NC[0][2] = p_in[2];

	// TMR4
	wire   tmr4_pwm0, tmr4_pwm1, tmr4_pwm_fault;
	//output 
	assign p_out[22] = tmr4_pwm0;
	assign p_out[26] = tmr4_pwm1;
	assign {p_oeb[22], p_oeb[26]} = 2'b00;
	assign NC[5][2] = p_in[22];
	assign NC[6][2] = p_in[26];
	//input 
	assign tmr4_pwm_fault = p_in[30];
	assign p_out[30] = 1'b0;
	assign p_oeb[30] = 1'b1;

	// TMR5
	wire   tmr5_pwm0, tmr5_pwm1, tmr5_pwm_fault;
	//output 
	assign p_out[34] = tmr5_pwm0;
	assign p_out[38] = tmr5_pwm1;
	assign {p_oeb[34], p_oeb[38]} = 2'b00;
	assign NC[8][2] = p_in[34];
	assign NC[9][2] = p_in[38];
	//input 
	assign tmr5_pwm_fault = p_in[42];
	assign p_out[42] = 1'b0;
	assign p_oeb[42] = 1'b1;


    // DAC0
    wire dac0_en, dac0_rst;
    wire [9:0] dac0_seld;

    // DAC1
    wire dac1_en, dac1_rst;
    wire [9:0] dac1_seld;


//------------------------------------------------------------------------------------------------------------------------------
// AHB 0 Bus fabric 

// - 4 kB SRAM at...                0x2000_0000
// - PSRAM at ......                0x2100_0000
// - Flash writer at .......        0x2200_0000
// - clk rst manager at .......     0x2300_0000
// - DMAC at .....                  0x2400_0000
// - PIN MUX at .....               0x2500_0000

wire               bridge2_hready_resp;
wire               bridge2_hready;
wire               bridge2_hresp;
wire [W_ADDR-1:0]  bridge2_haddr;
wire               bridge2_hwrite;
wire [1:0]         bridge2_htrans;
wire [2:0]         bridge2_hsize;
wire [2:0]         bridge2_hburst;
wire [3:0]         bridge2_hprot;
wire               bridge2_hmastlock;
wire [W_DATA-1:0]  bridge2_hwdata;
wire [W_DATA-1:0]  bridge2_hrdata;

wire        		bridge2_psel;
wire        		bridge2_penable;
wire        		bridge2_pwrite;
wire [31:0] 		bridge2_paddr;
wire [31:0] 		bridge2_pwdata;
wire [31:0] 		bridge2_prdata;
wire        		bridge2_pready;
wire        		bridge2_pslverr;

// Flash controller signals (going to housekeeping)
wire				hk_fsclk;
wire				hk_fcen;
wire [3:0]       	hk_fdin;
wire [3:0]       	hk_fdout;
wire [3:0]       	hk_fdouten;
 			
ahbl_0  #(
    .W_ADDR(W_ADDR),
    .W_DATA(W_DATA),
    .SRAM_DEPTH(SRAM_DEPTH)
) 
ahb0_sys (
	`ifdef USE_POWER_PINS
		.vdda1(vdda1),  
		.vssa1(vssa1),  
		.vccd1(vccd1),  
		.vssd1(vssd1),  
	`endif // USE_POWER_PINS
    .clk                (clk),
	.rst_n              (rst_n),

    // signals coming from crossbar 
    .hready_resp        (ahb_0_hready_resp),
	.hready             (ahb_0_hready   ),
	.hresp              (ahb_0_hresp    ),
	.haddr              (ahb_0_haddr    ),
	.hwrite             (ahb_0_hwrite   ),
	.htrans             (ahb_0_htrans   ),
	.hsize              (ahb_0_hsize    ),
	.hburst             (ahb_0_hburst   ),
	.hprot              (ahb_0_hprot    ),
	.hmastlock          (ahb_0_hmastlock),
	.hwdata             (ahb_0_hwdata   ),
	.hrdata             (ahb_0_hrdata   ),

	// signals going to ahb_to_apb bridge2 
    .bridge2_hready      (bridge2_hready),
	.bridge2_hready_resp (bridge2_hready_resp),
	.bridge2_hresp       (bridge2_hresp),
	.bridge2_haddr       (bridge2_haddr),
	.bridge2_hwrite      (bridge2_hwrite),
	.bridge2_htrans      (bridge2_htrans),
	.bridge2_hsize       (bridge2_hsize),
	.bridge2_hburst      (bridge2_hburst),
	.bridge2_hprot       (bridge2_hprot),
	.bridge2_hmastlock   (bridge2_hmastlock),
	.bridge2_hwdata      (bridge2_hwdata),
	.bridge2_hrdata      (bridge2_hrdata),

	// Flash controller interface 
	.fr_sck 			(fr_sck),
    .fr_ce_n			(fr_ce_n),
    .fr_din			    (fr_din),
    .fr_dout			(fr_dout),
    .fr_douten			(fr_douten),

    // FLASH controller interface (going to housekeeping)
    .fm_sck				(hk_fsclk),
    .fm_ce_n			(hk_fcen),
    .fm_din			    (hk_fdin),
    .fm_dout			(hk_fdout),
    .fm_douten			(hk_fdouten),


	// dmac slave signals 
    .dmac_S_hready_resp (dmac_S_hready_resp),
    .dmac_S_hready      (dmac_S_hready),   
    .dmac_S_hresp       (dmac_S_hresp),
    .dmac_S_haddr       (dmac_S_haddr),
    .dmac_S_hwrite      (dmac_S_hwrite),
    .dmac_S_htrans      (dmac_S_htrans),
    .dmac_S_hsize       (dmac_S_hsize),
    .dmac_S_hburst      (dmac_S_hburst),
    .dmac_S_hprot       (dmac_S_hprot),
    .dmac_S_hmastlock   (dmac_S_hmastlock), 
    .dmac_S_hwdata      (dmac_S_hwdata),
    .dmac_S_hrdata      (dmac_S_hrdata),

	// External Interface to Quad I/O
    .psram_sck          (psram_sck),
    .psram_ce_n         (psram_ce_n),
    .psram_din          (psram_din),
    .psram_dout         (psram_dout),
	.psram_douten		(psram_douten),

	// Pin MUX
	.pin_mux_io_in		(pin_mux_io_in),
	.pin_mux_io_out		(pin_mux_io_out),
	.pin_mux_io_oeb		(pin_mux_io_oeb),
	.p_in				(p_in),
	.p_out				(p_out),
	.p_oeb				(p_oeb),

	.xclk               (xclk),
	.rcosc_500k         (rcosc_500k),
	.rcosc_16m          (rcosc_16m),
	.hsxo               (hsxo),
	.lsxo               (lsxo),
	.xrst_n             (xrst_n),
	.por_n              (por_n),
	.hkrst_n            (~hkrst), 		// output from hk inverted 
	.pclk               (pclk),			// apb bus clock 
	.usb_clk            (usb_clk),		// usb 48 MHz
	.clk_mon            (clk_mon),		// connected to pin mux 
	.user_clk           (user_clk),		// user clock

	// will be connected to timing frontend 
	.rcosc_500k_en_tf(rcosc_500k_en_tf),
	.rcosc_16m_en_tf(rcosc_16m_en_tf),
	.hsxo_en_tf(hsxo_en_tf),
	.lsxo_en_tf(lsxo_en_tf),
	.lsxo_standby_tf(lsxo_standby_tf),
	.hsxo_standby_tf(hsxo_standby_tf),

    .SRAMRDATA_0(SRAMRDATA_0),
    .SRAMR_WB_0(SRAMR_WB_0),
    .SRAMWDATA_0(SRAMWDATA_0),
    .SRAMEN_0(SRAMEN_0),
    .SRAMADDR_0(SRAMADDR_0),
    .SRAMCLK_0(SRAMCLK_0),
    .SRAMBEN_0(SRAMBEN_0),

	// System Registers
	.vref_e_vrefgen_en(vref_e_vrefgen_en),
    .vref_w_vrefgen_en(vref_w_vrefgen_en),
    .vref_e_ref_sel(vref_e_ref_sel),
    .vref_w_ref_sel(vref_w_ref_sel),
	.muxsplit_se_switch_aa_sl(muxsplit_se_switch_aa_sl),
	.muxsplit_se_switch_aa_s0(muxsplit_se_switch_aa_s0),
	.muxsplit_se_switch_bb_s0(muxsplit_se_switch_bb_s0),
	.muxsplit_se_switch_bb_sl(muxsplit_se_switch_bb_sl),
	.muxsplit_se_switch_bb_sr(muxsplit_se_switch_bb_sr),
	.muxsplit_se_switch_aa_sr(muxsplit_se_switch_aa_sr),
	.muxsplit_sw_switch_aa_sl(muxsplit_sw_switch_aa_sl),
	.muxsplit_sw_switch_aa_s0(muxsplit_sw_switch_aa_s0),
	.muxsplit_sw_switch_bb_s0(muxsplit_sw_switch_bb_s0),
	.muxsplit_sw_switch_bb_sl(muxsplit_sw_switch_bb_sl),
	.muxsplit_sw_switch_bb_sr(muxsplit_sw_switch_bb_sr),
	.muxsplit_sw_switch_aa_sr(muxsplit_sw_switch_aa_sr),
	.muxsplit_ne_switch_aa_sl(muxsplit_ne_switch_aa_sl),
	.muxsplit_ne_switch_aa_s0(muxsplit_ne_switch_aa_s0),
	.muxsplit_ne_switch_bb_s0(muxsplit_ne_switch_bb_s0),
	.muxsplit_ne_switch_bb_sl(muxsplit_ne_switch_bb_sl),
	.muxsplit_ne_switch_bb_sr(muxsplit_ne_switch_bb_sr),
	.muxsplit_ne_switch_aa_sr(muxsplit_ne_switch_aa_sr),
	.muxsplit_nw_switch_aa_sl(muxsplit_nw_switch_aa_sl),
	.muxsplit_nw_switch_aa_s0(muxsplit_nw_switch_aa_s0),
	.muxsplit_nw_switch_bb_s0(muxsplit_nw_switch_bb_s0),
	.muxsplit_nw_switch_bb_sl(muxsplit_nw_switch_bb_sl),
	.muxsplit_nw_switch_bb_sr(muxsplit_nw_switch_bb_sr),
	.muxsplit_nw_switch_aa_sr(muxsplit_nw_switch_aa_sr),
	.user_ahb_enable(user_ahb_enable),
	.user_irqs_enable(user_irqs_enable),
	.sio_cfg(sio_cfg),
	.mgmt_select(mgmt_select)

);

wire bridge2_pclk = clk;
wire bridge2_prstn = rst_n;

ahb_to_apb #(.CLK_RATIO(1)) 

ahb_apb_bridge2 (
    .HCLK 				(clk),
    .HRESETn			(rst_n),
    .HSEL				(1'b1),
    .HADDR				(bridge2_haddr),
    .HTRANS				(bridge2_htrans),
    .HWRITE				(bridge2_hwrite),
    .HREADY				(bridge2_hready),
    .HWDATA				(bridge2_hwdata),
    .HSIZE				(bridge2_hsize),
    .HREADYOUT			(bridge2_hready_resp),
    .HRDATA				(bridge2_hrdata),

    // APB Master Port
    // .PCLK				(bridge2_pclk),
    // .PRESETn			(bridge2_prstn),
    // .PCLKIN				(clk), 		
    .PRDATA				(bridge2_prdata),
    .PREADY				(bridge2_pready),
    .PWDATA				(bridge2_pwdata),
    .PENABLE			(bridge2_penable),
    .PADDR				(bridge2_paddr),
    .PWRITE				(bridge2_pwrite)
);

assign bridge2_hresp = 0;
// assign bridge2_pslverr = 0;
assign bridge2_psel = 1'b1;

wire [3:0] hk_fdoutenb;
wire [3:0] fdoutenb;

assign hk_fdoutenb = ~hk_fdouten;

assign fdouten = ~fdoutenb;
 
apb_2 #(
    .CLK_MHZ (CLK_MHZ)      // For timer timebase
)
apb2_sys(
	`ifdef USE_POWER_PINS
     .VPWR(vccd1),
     .VGND(vssd1),
	`endif

	.clk 			(bridge2_pclk),
	.rst_n 			(bridge2_prstn),

    .paddr        	(bridge2_paddr),
	.psel         	(bridge2_psel),
	.penable      	(bridge2_penable),
	.pwrite       	(bridge2_pwrite),
	.pwdata       	(bridge2_pwdata),
	.pready       	(bridge2_pready),
	.prdata       	(bridge2_prdata),
	.pslverr      	(bridge2_pslverr),

	.porb			(por_n),
	
	// housekeeping spi (slave)
    .hk_spi_csb		(hk_spi_csb),
    .hk_spi_sck		(hk_spi_sck),
    .hk_spi_sdi		(hk_spi_sdi),
    .hk_spi_sdo		(hk_spi_sdo),


    // External (originating from SPI and pad) IRQ and reset
    .hk_spi_irq		(hk_spi_irq),
	.hkrst 			(hkrst),

	.serial_clock (serial_clock),
	.serial_load  (serial_load),
	.serial_resetn(serial_resetn),
	.serial_data_1(serial_data_1),
	.serial_data_2(serial_data_2),

	// No Changes
	.mask_rev_in(mask_rev_in),
	.prod_id(prod_id),

	// No Changes
	.spimemio_flash_csb(hk_fcen),
	.spimemio_flash_clk(hk_fsclk),
	.spimemio_flash_io0_oeb(hk_fdoutenb[0]),
	.spimemio_flash_io1_oeb(hk_fdoutenb[1]),
	.spimemio_flash_io2_oeb(hk_fdoutenb[2]),
	.spimemio_flash_io3_oeb(hk_fdoutenb[3]),
	.spimemio_flash_io0_do(hk_fdout[0]),
	.spimemio_flash_io1_do(hk_fdout[1]),
	.spimemio_flash_io2_do(hk_fdout[2]),
	.spimemio_flash_io3_do(hk_fdout[3]),
	.spimemio_flash_io0_di(hk_fdin[0]),
	.spimemio_flash_io1_di(hk_fdin[1]),
	.spimemio_flash_io2_di(hk_fdin[2]),
	.spimemio_flash_io3_di(hk_fdin[3]),

	// No Changes
	.pad_flash_csb(fcen),
	.pad_flash_csb_oeb(),
	.pad_flash_clk(fsclk),
	.pad_flash_clk_oeb(),
	.pad_flash_io0_oeb(fdoutenb[0]),
	.pad_flash_io1_oeb(fdoutenb[1]),
	.pad_flash_io0_ieb(),
	.pad_flash_io1_ieb(),
	.pad_flash_io0_do(fdout[0]),
	.pad_flash_io1_do(fdout[1]),
	.pad_flash_io0_di(fdin[0]),
	.pad_flash_io1_di(fdin[1]),

	.pad_flash_io2_oeb(fdoutenb[2]),
	.pad_flash_io3_oeb(fdoutenb[3]),
	.pad_flash_io2_do(fdout[2]),
	.pad_flash_io3_do(fdout[3]),
	.pad_flash_io2_di(fdin[2]),
	.pad_flash_io3_di(fdin[3])
);

// ---------------------------------------------------------------------------------------------------------------------------
// AHB 1 Bus fabric
// - APB0 Peripherals: 0x4000_0000   
//                     0x4000_0000  GPIO Port A
//                     0x4001_0000  GPIO Port B
//                     0x4002_0000  GPIO Port C
//                     0x4003_0000  GPIO Port D
//                     0x4004_0000  GPIO Port E
//                     0x4005_0000  GPIO Port F
//                     0x4006_0000  GPIO Port G
//                     0x4007_0000  GPIO Port H
//                     0x4008_0000  GPIO Port I
//                     0x4009_0000  I2S0
//                     0x400A_0000  I2S1
//                     0x400B_0000  ADC0
//                     0x400C_0000  DAC0
//                     0x400D_0000  hazard3_timer

// - APB1 Peripherals: 0x4200_0000   
//                     0x4200_0000  UART0
//                     0x4201_0000  UART1
//                     0x4202_0000  UART2
//                     0x4203_0000  UART3
//                     0x4204_0000  TMR0
//                     0x4205_0000  TMR1
//                     0x4206_0000  TMR2
//                     0x4207_0000  TMR3
//                     0x4208_0000  TMR4
//                     0x4209_0000  TMR5
//                     0x420A_0000  WDT
//                     0x420B_0000  SPI0
//                     0x420C_0000  SPI1
//                     0x420D_0000  I2C0
//                     0x420E_0000  I2C1



// - 4 kB SRAM at...   0x4800_0000
// - ML regs at ...    0x4900_0000
// - USB CDC at ...    0x4A00_0000


wire               bridge0_hready_resp;
wire               bridge0_hready;
wire               bridge0_hresp;
wire [W_ADDR-1:0]  bridge0_haddr;
wire               bridge0_hwrite;
wire [1:0]         bridge0_htrans;
wire [2:0]         bridge0_hsize;
wire [2:0]         bridge0_hburst;
wire [3:0]         bridge0_hprot;
wire               bridge0_hmastlock;
wire [W_DATA-1:0]  bridge0_hwdata;
wire [W_DATA-1:0]  bridge0_hrdata;

wire               bridge1_hready_resp;
wire               bridge1_hready;
wire               bridge1_hresp;
wire [W_ADDR-1:0]  bridge1_haddr;
wire               bridge1_hwrite;
wire [1:0]         bridge1_htrans;
wire [2:0]         bridge1_hsize;
wire [2:0]         bridge1_hburst;
wire [3:0]         bridge1_hprot;
wire               bridge1_hmastlock;
wire [W_DATA-1:0]  bridge1_hwdata;
wire [W_DATA-1:0]  bridge1_hrdata;

// APB0 layer
wire        		bridge0_psel;
wire        		bridge0_penable;
wire        		bridge0_pwrite;
wire [31:0] 		bridge0_paddr;
wire [31:0] 		bridge0_pwdata;
wire [31:0] 		bridge0_prdata;
wire        		bridge0_pready;
wire        		bridge0_pslverr;

wire        		bridge1_psel;
wire        		bridge1_penable;
wire        		bridge1_pwrite;
wire [31:0] 		bridge1_paddr;
wire [31:0] 		bridge1_pwdata;
wire [31:0] 		bridge1_prdata;
wire        		bridge1_pready;
wire        		bridge1_pslverr;



wire usb_sc_in, usb_sc_out;

ahbl_1  #(
    .W_ADDR(W_ADDR),
    .W_DATA(W_DATA),
    .SRAM_DEPTH(SRAM_DEPTH)
) 
ahb1_sys (

    .clk                (clk),
	.rst_n              (rst_n),

    // signals coming from crossbar 
    .hready_resp        (ahb_1_hready_resp),
	.hready             (ahb_1_hready   ),
	.hresp              (ahb_1_hresp    ),
	.haddr              (ahb_1_haddr    ),
	.hwrite             (ahb_1_hwrite   ),
	.htrans             (ahb_1_htrans   ),
	.hsize              (ahb_1_hsize    ),
	.hburst             (ahb_1_hburst   ),
	.hprot              (ahb_1_hprot    ),
	.hmastlock          (ahb_1_hmastlock),
	.hwdata             (ahb_1_hwdata   ),
	.hrdata             (ahb_1_hrdata   ),

	// signals going to ahb_to_apb bridge0 
    .bridge0_hready      (bridge0_hready),
	.bridge0_hready_resp (bridge0_hready_resp),
	.bridge0_hresp       (bridge0_hresp),
	.bridge0_haddr       (bridge0_haddr),
	.bridge0_hwrite      (bridge0_hwrite),
	.bridge0_htrans      (bridge0_htrans),
	.bridge0_hsize       (bridge0_hsize),
	.bridge0_hburst      (bridge0_hburst),
	.bridge0_hprot       (bridge0_hprot),
	.bridge0_hmastlock   (bridge0_hmastlock),
	.bridge0_hwdata      (bridge0_hwdata),
	.bridge0_hrdata      (bridge0_hrdata),

	// signals going to ahb_to_apb bridge1 
    .bridge1_hready      (bridge1_hready),
	.bridge1_hready_resp (bridge1_hready_resp),
	.bridge1_hresp       (bridge1_hresp),
	.bridge1_haddr       (bridge1_haddr),
	.bridge1_hwrite      (bridge1_hwrite),
	.bridge1_htrans      (bridge1_htrans),
	.bridge1_hsize       (bridge1_hsize),
	.bridge1_hburst      (bridge1_hburst),
	.bridge1_hprot       (bridge1_hprot),
	.bridge1_hmastlock   (bridge1_hmastlock),
	.bridge1_hwdata      (bridge1_hwdata),
	.bridge1_hrdata      (bridge1_hrdata),

	.usb_cdc_dp_rx     	(usb_dp_rx),
    .usb_cdc_dn_rx     	(usb_dn_rx),
    .usb_cdc_dp_pu     	(usb_dp_pu),
    .usb_cdc_tx_en     	(usb_tx_en),
    .usb_cdc_dp_tx     	(usb_dp_tx),
    .usb_cdc_dn_tx     	(usb_dn_tx),
	.usb_cdc_irq        (usb_irq),
	.usb_clk	        (usb_clk),

    .SRAMRDATA_1(SRAMRDATA_1),
    .SRAMR_WB_1(SRAMR_WB_1),
    .SRAMWDATA_1(SRAMWDATA_1),
    .SRAMEN_1(SRAMEN_1),
    .SRAMADDR_1(SRAMADDR_1),
    .SRAMCLK_1(SRAMCLK_1),
    .SRAMBEN_1(SRAMBEN_1)
);




wire bridge0_pclk = pclk;
wire bridge0_prstn = rst_n;

ahb_to_apb ahb_apb_bridge0 (
    .HCLK 				(clk),
    .HRESETn			(rst_n),
    .HSEL				(1'b1),
    .HADDR				(bridge0_haddr),
    .HTRANS				(bridge0_htrans),
    .HWRITE				(bridge0_hwrite),
    .HREADY				(bridge0_hready),
    .HWDATA				(bridge0_hwdata),
    .HSIZE				(bridge0_hsize),
    .HREADYOUT			(bridge0_hready_resp),
    .HRDATA				(bridge0_hrdata),

    // APB Master Port
    // .PCLK				(bridge0_pclk),
    // .PRESETn			(bridge0_prstn),
    // .PCLKIN				(gpclk0),
    .PRDATA				(bridge0_prdata),
    .PREADY				(bridge0_pready),
    .PWDATA				(bridge0_pwdata),
    .PENABLE			(bridge0_penable),
    .PADDR				(bridge0_paddr),
    .PWRITE				(bridge0_pwrite),
    .PSEL 				(bridge0_psel)
);

assign bridge0_hresp = 0;
// assign bridge0_pslverr = 0;
// assign bridge0_psel = 1'b1;


wire bridge1_pclk = pclk;
wire bridge1_prstn = rst_n;

ahb_to_apb ahb_apb_bridge1 (
    .HCLK 				(clk),
    .HRESETn			(rst_n),
    .HSEL				(1'b1),
    .HADDR				(bridge1_haddr),
    .HTRANS				(bridge1_htrans),
    .HWRITE				(bridge1_hwrite),
    .HREADY				(bridge1_hready),
    .HWDATA				(bridge1_hwdata),
    .HSIZE				(bridge1_hsize),
    .HREADYOUT			(bridge1_hready_resp),
    .HRDATA				(bridge1_hrdata),

    // APB Master Port
    // .PCLK				(bridge1_pclk),
    // .PRESETn			(bridge1_prstn),
    // .PCLKIN				(gpclk1),
    .PRDATA				(bridge1_prdata),
    .PREADY				(bridge1_pready),
    .PWDATA				(bridge1_pwdata),
    .PENABLE			(bridge1_penable),
    .PADDR				(bridge1_paddr),
    .PWRITE				(bridge1_pwrite),
    .PSEL				(bridge1_psel)
);

assign bridge1_hresp = 0;
// assign bridge1_pslverr = 0;
// assign bridge1_psel = 1'b1;

wire [6:0] gpioH_out_nc;
wire [6:0] gpioH_oe_nc;

wire [5:0] gpioI_out_nc;
wire [5:0] gpioI_oe_nc;

wire can_sc_in, can_sc_out;

apb_0 #(
    .CLK_MHZ (CLK_MHZ)      // For timer timebase
)
apb0_sys(

	`ifdef USE_POWER_PINS
		.VPWR(vccd1),
		.VGND(vssd1),
	`endif
		
	.clk 			(bridge0_pclk),
	.rst_n 			(bridge0_prstn),

    .paddr        	(bridge0_paddr),
	.psel         	(bridge0_psel),
	.penable      	(bridge0_penable),
	.pwrite       	(bridge0_pwrite),
	.pwdata       	(bridge0_pwdata),
	.pready       	(bridge0_pready),
	.prdata       	(bridge0_prdata),
	.pslverr      	(bridge0_pslverr),

    .gpioA_io_in    (gpioA_io_in),
    .gpioA_io_out   (gpioA_io_out),
    .gpioA_io_oe    (gpioA_io_oe),
	.gpioA_irq		(gpioA_irq),

	.gpioB_io_in    (gpioB_io_in),
    .gpioB_io_out   (gpioB_io_out),
    .gpioB_io_oe    (gpioB_io_oe),
	.gpioB_irq		(gpioB_irq),

	.gpioC_io_in    (gpioC_io_in),
    .gpioC_io_out   (gpioC_io_out),
    .gpioC_io_oe    (gpioC_io_oe),
	.gpioC_irq		(gpioC_irq),

	.gpioD_io_in    (gpioD_io_in),
    .gpioD_io_out   (gpioD_io_out),
    .gpioD_io_oe    (gpioD_io_oe),
	.gpioD_irq		(gpioD_irq),

	.gpioE_io_in    (gpioE_io_in),
    .gpioE_io_out   (gpioE_io_out),
    .gpioE_io_oe    (gpioE_io_oe),
	.gpioE_irq		(gpioE_irq),

	.gpioF_io_in    (gpioF_io_in),
    .gpioF_io_out   (gpioF_io_out),
    .gpioF_io_oe    (gpioF_io_oe),
	.gpioF_irq		(gpioF_irq),

	.gpioG_io_in    (gpioG_io_in),
    .gpioG_io_out   (gpioG_io_out),
    .gpioG_io_oe    (gpioG_io_oe),
	.gpioG_irq		(gpioG_irq),


	.gpioH_io_in    ({gpioH_io_in, 7'b0000000 }),
    .gpioH_io_out   ({gpioH_io_out, gpioH_out_nc}),
    .gpioH_io_oe    ({gpioH_io_oe,  gpioH_oe_nc}),

	.gpioH_irq		(gpioH_irq),

	.gpioI_io_in    ({6'b000000 , gpioI_io_in}),
    .gpioI_io_out   ({gpioI_out_nc, gpioI_io_out}),
    .gpioI_io_oe    ({gpioI_oe_nc,gpioI_io_oe}),
	.gpioI_irq		(gpioI_irq),
    
	.i2s0_ws        (i2s0_ws),
	.i2s0_sck		(i2s0_sck),
	.i2s0_sdi		(i2s0_sdi),
	.i2s0_irq      	(i2s0_irq),

    .adc0_cmp       (adc0_cmp), 
	.adc0_hold      (adc0_hold), 
	.adc0_ch_sel_out(), 
	.adc0_data      (adc0_data), 
	.adc0_en        (adc0_en),
	.adc0_dac_rst   (adc0_dac_rst),
	.adc0_irq       (adc0_irq),
	
	.adc1_cmp       (adc1_cmp), 
	.adc1_hold      (adc1_hold), 
	.adc1_ch_sel_out(), 
	.adc1_data      (adc1_data), 
	.adc1_en        (adc1_en),
	.adc1_dac_rst   (adc1_dac_rst),
	.adc1_irq       (adc1_irq),

	.ds_o			(ds_o),
	.ds_n_o			(ds_n_o),
	.audiodac0_irq  (audiodac0_irq),

	.can0_rx  		(can0_rx),
	.can0_tx     	(can0_tx),
	.can0_irq 		(can0_irq),

    .timer_irq    	(timer_irq),
	.hart_halted  	(hart_halted)

);

apb_1 #(
    .CLK_MHZ (CLK_MHZ)      // For timer timebase
)
apb1_sys(

`ifdef USE_POWER_PINS
     .VPWR(vccd1),
     .VGND(vssd1),
`endif

	.clk 			(bridge1_pclk),
	.rst_n 			(bridge1_prstn),

    .paddr        	(bridge1_paddr),
	.psel         	(bridge1_psel),
	.penable      	(bridge1_penable),
	.pwrite       	(bridge1_pwrite),
	.pwdata       	(bridge1_pwdata),
	.pready       	(bridge1_pready),
	.prdata       	(bridge1_prdata),
	.pslverr      	(bridge1_pslverr),

    .uart0_rx      	(uart0_rx),
    .uart0_tx      	(uart0_tx),
    .uart0_irq     	(uart0_irq),

	.uart1_rx      	(uart1_rx),
    .uart1_tx      	(uart1_tx),
    .uart1_irq     	(uart1_irq),

	.uart2_rx      	(uart2_rx),
    .uart2_tx      	(uart2_tx),
    .uart2_irq     	(uart2_irq),

	.uart3_rx      	(uart3_rx),
    .uart3_tx      	(uart3_tx),
    .uart3_irq     	(uart3_irq),

    .tmr0_pwm0      (tmr0_pwm0),
	.tmr0_pwm1      (tmr0_pwm1),
	.tmr0_pwm_fault (tmr0_pwm_fault),
	.tmr0_irq		(tmr0_irq),

	.tmr1_pwm0      (tmr1_pwm0),
	.tmr1_pwm1      (tmr1_pwm1),
	.tmr1_pwm_fault (tmr1_pwm_fault),
	.tmr1_irq		(tmr1_irq),

	.tmr2_pwm0      (tmr2_pwm0),
	.tmr2_pwm1      (tmr2_pwm1),
	.tmr2_pwm_fault (tmr2_pwm_fault),
	.tmr2_irq		(tmr2_irq),

	.tmr3_pwm0      (tmr3_pwm0),
	.tmr3_pwm1      (tmr3_pwm1),
	.tmr3_pwm_fault (tmr3_pwm_fault),
	.tmr3_irq		(tmr3_irq),

	.tmr4_pwm0      (tmr4_pwm0),
	.tmr4_pwm1      (tmr4_pwm1),
	.tmr4_pwm_fault (tmr4_pwm_fault),
	.tmr4_irq		(tmr4_irq),

	.tmr5_pwm0      (tmr5_pwm0),
	.tmr5_pwm1      (tmr5_pwm1),
	.tmr5_pwm_fault (tmr5_pwm_fault),
	.tmr5_irq		(tmr5_irq),

	.wdt0_irq       (wdt0_irq),

	.spi0_MSI		(spi0_MISO),
	.spi0_MSO		(spi0_MOSI),
    .spi0_SSn		(spi0_SSn),
    .spi0_SCK		(spi0_SCK),
	.spi0_irq		(spi0_irq),

	.spi1_MSI		(spi1_MISO),
	.spi1_MSO		(spi1_MOSI),
    .spi1_SSn		(spi1_SSn),
    .spi1_SCK		(spi1_SCK),
	.spi1_irq		(spi1_irq),

	.i2c0_scl_i		(i2c0_scl_i),
	.i2c0_scl_o		(i2c0_scl_o),
    .i2c0_scl_oen_o	(i2c0_scl_oen_o),
    .i2c0_sda_i		(i2c0_sda_i),
	.i2c0_sda_o		(i2c0_sda_o),
	.i2c0_sda_oen_o	(i2c0_sda_oen_o),
    .i2c0_irq		(i2c0_irq),

	.i2c1_scl_i		(i2c1_scl_i),
	.i2c1_scl_o		(i2c1_scl_o),
    .i2c1_scl_oen_o	(i2c1_scl_oen_o),
    .i2c1_sda_i		(i2c1_sda_i),
	.i2c1_sda_o		(i2c1_sda_o),
	.i2c1_sda_oen_o	(i2c1_sda_oen_o),
    .i2c1_irq		(i2c1_irq),

	.ibias_test_to_gpio1_2(ibias_test_to_gpio1_2),
	.vbg_test_to_gpio1_1(vbg_test_to_gpio1_1),
	.idac_to_gpio1_3(idac_to_gpio1_3),
	.idac_to_gpio1_2(idac_to_gpio1_2),
	.adc_refh_to_gpio6_6(adc_refh_to_gpio6_6),
	.dac_refh_to_gpio1_1(dac_refh_to_gpio1_1),
	.adc_refl_to_gpio6_7(adc_refl_to_gpio6_7),
	.dac_refl_to_gpio1_0(dac_refl_to_gpio1_0),
	.right_lp_opamp_to_ulpcomp_p(right_lp_opamp_to_ulpcomp_p),
	.right_lp_opamp_to_comp_p(right_lp_opamp_to_comp_p),
	.right_lp_opamp_to_adc0(right_lp_opamp_to_adc0),
	.right_lp_opamp_to_gpio4_7(right_lp_opamp_to_gpio4_7),
	.right_lp_opamp_to_gpio4_3(right_lp_opamp_to_gpio4_3),
	.right_lp_opamp_to_analog1(right_lp_opamp_to_analog1),
	.right_lp_opamp_to_amuxbusB(right_lp_opamp_to_amuxbusB),
	.right_lp_opamp_to_gpio3_7(right_lp_opamp_to_gpio3_7),
	.right_lp_opamp_to_gpio3_3(right_lp_opamp_to_gpio3_3),
	.right_hgbw_opamp_to_ulpcomp_n(right_hgbw_opamp_to_ulpcomp_n),
	.right_hgbw_opamp_to_comp_n(right_hgbw_opamp_to_comp_n),
	.right_hgbw_opamp_to_adc1(right_hgbw_opamp_to_adc1),
	.right_hgbw_opamp_to_gpio4_6(right_hgbw_opamp_to_gpio4_6),
	.right_hgbw_opamp_to_gpio4_2(right_hgbw_opamp_to_gpio4_2),
	.right_hgbw_opamp_to_analog0(right_hgbw_opamp_to_analog0),
	.right_hgbw_opamp_to_amuxbusA(right_hgbw_opamp_to_amuxbusA),
	.right_hgbw_opamp_to_gpio3_6(right_hgbw_opamp_to_gpio3_6),
	.right_hgbw_opamp_to_gpio3_2(right_hgbw_opamp_to_gpio3_2),
	.left_hgbw_opamp_to_ulpcomp_p(left_hgbw_opamp_to_ulpcomp_p),
	.left_hgbw_opamp_to_comp_p(left_hgbw_opamp_to_comp_p),
	.left_hgbw_opamp_to_adc0(left_hgbw_opamp_to_adc0),
	.left_hgbw_opamp_to_gpio4_5(left_hgbw_opamp_to_gpio4_5),
	.left_hgbw_opamp_to_gpio4_1(left_hgbw_opamp_to_gpio4_1),
	.left_hgbw_opamp_to_analog1(left_hgbw_opamp_to_analog1),
	.left_hgbw_opamp_to_amuxbusB(left_hgbw_opamp_to_amuxbusB),
	.left_hgbw_opamp_to_gpio3_5(left_hgbw_opamp_to_gpio3_5),
	.left_hgbw_opamp_to_gpio3_1(left_hgbw_opamp_to_gpio3_1),
	.left_lp_opamp_to_ulpcomp_n(left_lp_opamp_to_ulpcomp_n),
	.left_lp_opamp_to_comp_n(left_lp_opamp_to_comp_n),
	.left_lp_opamp_to_adc1(left_lp_opamp_to_adc1),
	.left_lp_opamp_to_gpio4_0(left_lp_opamp_to_gpio4_0),
	.left_lp_opamp_to_analog0(left_lp_opamp_to_analog0),
	.left_lp_opamp_to_amuxbusA(left_lp_opamp_to_amuxbusA),
	.left_lp_opamp_to_gpio3_4(left_lp_opamp_to_gpio3_4),
	.right_lp_opamp_p_to_dac0(right_lp_opamp_p_to_dac0),
	.right_lp_opamp_p_to_analog0(right_lp_opamp_p_to_analog0),
	.right_lp_opamp_p_to_amuxbusA(right_lp_opamp_p_to_amuxbusA),
	.right_lp_opamp_p_to_rheostat_out(right_lp_opamp_p_to_rheostat_out),
	.right_lp_opamp_p_to_sio0(right_lp_opamp_p_to_sio0),
	.right_lp_opamp_p_to_tempsense(right_lp_opamp_p_to_tempsense),
	.right_lp_opamp_p_to_left_vref(right_lp_opamp_p_to_left_vref),
	.right_lp_opamp_p_to_voutref(right_lp_opamp_p_to_voutref),
	.right_lp_opamp_p_to_gpio2_5(right_lp_opamp_p_to_gpio2_5),
	.right_lp_opamp_n_to_dac1(right_lp_opamp_n_to_dac1),
	.right_lp_opamp_n_to_analog1(right_lp_opamp_n_to_analog1),
	.right_lp_opamp_n_to_amuxbusB(right_lp_opamp_n_to_amuxbusB),
	.right_lp_opamp_n_to_rheostat_out(right_lp_opamp_n_to_rheostat_out),
	.right_lp_opamp_n_to_rheostat_tap(right_lp_opamp_n_to_rheostat_tap),
	.right_lp_opamp_n_to_sio1(right_lp_opamp_n_to_sio1),
	.right_lp_opamp_n_to_vbgtc(right_lp_opamp_n_to_vbgtc),
	.right_lp_opamp_n_to_right_vref(right_lp_opamp_n_to_right_vref),
	.right_lp_opamp_n_to_vinref(right_lp_opamp_n_to_vinref),
	.right_lp_opamp_n_to_gpio2_4(right_lp_opamp_n_to_gpio2_4),
	.right_hgbw_opamp_p_to_gpio5_0(right_hgbw_opamp_p_to_gpio5_0),
	.right_hgbw_opamp_p_to_dac0(right_hgbw_opamp_p_to_dac0),
	.right_hgbw_opamp_p_to_analog0(right_hgbw_opamp_p_to_analog0),
	.right_hgbw_opamp_p_to_amuxbusA(right_hgbw_opamp_p_to_amuxbusA),
	.right_hgbw_opamp_p_to_rheostat_out(right_hgbw_opamp_p_to_rheostat_out),
	.right_hgbw_opamp_p_to_sio0(right_hgbw_opamp_p_to_sio0),
	.right_hgbw_opamp_p_to_left_vref(right_hgbw_opamp_p_to_left_vref),
	.right_hgbw_opamp_p_to_voutref(right_hgbw_opamp_p_to_voutref),
	.right_hgbw_opamp_p_to_gpio2_3(right_hgbw_opamp_p_to_gpio2_3),
	.right_hgbw_opamp_n_to_gpio5_1(right_hgbw_opamp_n_to_gpio5_1),
	.right_hgbw_opamp_n_to_dac1(right_hgbw_opamp_n_to_dac1),
	.right_hgbw_opamp_n_to_analog1(right_hgbw_opamp_n_to_analog1),
	.right_hgbw_opamp_n_to_amuxbusB(right_hgbw_opamp_n_to_amuxbusB),
	.right_hgbw_opamp_n_to_rheostat_out(right_hgbw_opamp_n_to_rheostat_out),
	.right_hgbw_opamp_n_to_rheostat_tap(right_hgbw_opamp_n_to_rheostat_tap),
	.right_hgbw_opamp_n_to_sio1(right_hgbw_opamp_n_to_sio1),
	.right_hgbw_opamp_n_to_vbgsc(right_hgbw_opamp_n_to_vbgsc),
	.right_hgbw_opamp_n_to_right_vref(right_hgbw_opamp_n_to_right_vref),
	.right_hgbw_opamp_n_to_vinref(right_hgbw_opamp_n_to_vinref),
	.right_hgbw_opamp_n_to_gpio2_2(right_hgbw_opamp_n_to_gpio2_2),
	.left_hgbw_opamp_p_to_gpio5_2(left_hgbw_opamp_p_to_gpio5_2),
	.left_hgbw_opamp_p_to_dac0(left_hgbw_opamp_p_to_dac0),
	.left_hgbw_opamp_p_to_analog0(left_hgbw_opamp_p_to_analog0),
	.left_hgbw_opamp_p_to_amuxbusA(left_hgbw_opamp_p_to_amuxbusA),
	.left_hgbw_opamp_p_to_rheostat_out(left_hgbw_opamp_p_to_rheostat_out),
	.left_hgbw_opamp_p_to_sio0(left_hgbw_opamp_p_to_sio0),
	.left_hgbw_opamp_p_to_tempsense(left_hgbw_opamp_p_to_tempsense),
	.left_hgbw_opamp_p_to_left_vref(left_hgbw_opamp_p_to_left_vref),
	.left_hgbw_opamp_p_to_voutref(left_hgbw_opamp_p_to_voutref),
	.left_hgbw_opamp_p_to_gpio2_1(left_hgbw_opamp_p_to_gpio2_1),
	.left_hgbw_opamp_n_to_gpio5_3(left_hgbw_opamp_n_to_gpio5_3),
	.left_hgbw_opamp_n_to_dac1(left_hgbw_opamp_n_to_dac1),
	.left_hgbw_opamp_n_to_analog1(left_hgbw_opamp_n_to_analog1),
	.left_hgbw_opamp_n_to_amuxbusB(left_hgbw_opamp_n_to_amuxbusB),
	.left_hgbw_opamp_n_to_rheostat_out(left_hgbw_opamp_n_to_rheostat_out),
	.left_hgbw_opamp_n_to_rheostat_tap(left_hgbw_opamp_n_to_rheostat_tap),
	.left_hgbw_opamp_n_to_sio1(left_hgbw_opamp_n_to_sio1),
	.left_hgbw_opamp_n_to_vbgtc(left_hgbw_opamp_n_to_vbgtc),
	.left_hgbw_opamp_n_to_right_vref(left_hgbw_opamp_n_to_right_vref),
	.left_hgbw_opamp_n_to_vinref(left_hgbw_opamp_n_to_vinref),
	.left_hgbw_opamp_n_to_gpio2_0(left_hgbw_opamp_n_to_gpio2_0),
	.left_lp_opamp_p_to_gpio5_4(left_lp_opamp_p_to_gpio5_4),
	.left_lp_opamp_p_to_dac0(left_lp_opamp_p_to_dac0),
	.left_lp_opamp_p_to_analog0(left_lp_opamp_p_to_analog0),
	.left_lp_opamp_p_to_amuxbusA(left_lp_opamp_p_to_amuxbusA),
	.left_lp_opamp_p_to_rheostat_out(left_lp_opamp_p_to_rheostat_out),
	.left_lp_opamp_p_to_sio0(left_lp_opamp_p_to_sio0),
	.left_lp_opamp_p_to_left_vref(left_lp_opamp_p_to_left_vref),
	.left_lp_opamp_p_to_voutref(left_lp_opamp_p_to_voutref),
	.left_lp_opamp_n_to_gpio5_5(left_lp_opamp_n_to_gpio5_5),
	.left_lp_opamp_n_to_dac1(left_lp_opamp_n_to_dac1),
	.left_lp_opamp_n_to_analog1(left_lp_opamp_n_to_analog1),
	.left_lp_opamp_n_to_amuxbusB(left_lp_opamp_n_to_amuxbusB),
	.left_lp_opamp_n_to_rheostat_out(left_lp_opamp_n_to_rheostat_out),
	.left_lp_opamp_n_to_rheostat_tap(left_lp_opamp_n_to_rheostat_tap),
	.left_lp_opamp_n_to_sio1(left_lp_opamp_n_to_sio1),
	.left_lp_opamp_n_to_vbgsc(left_lp_opamp_n_to_vbgsc),
	.left_lp_opamp_n_to_right_vref(left_lp_opamp_n_to_right_vref),
	.left_lp_opamp_n_to_vinref(left_lp_opamp_n_to_vinref),
	.left_instramp_to_ulpcomp_p(left_instramp_to_ulpcomp_p),
	.left_instramp_to_comp_p(left_instramp_to_comp_p),
	.left_instramp_to_adc0(left_instramp_to_adc0),
	.left_instramp_to_gpio4_4(left_instramp_to_gpio4_4),
	.left_instramp_to_analog1(left_instramp_to_analog1),
	.left_instramp_to_amuxbusB(left_instramp_to_amuxbusB),
	.right_instramp_to_ulpcomp_n(right_instramp_to_ulpcomp_n),
	.right_instramp_to_comp_n(right_instramp_to_comp_n),
	.right_instramp_to_adc1(right_instramp_to_adc1),
	.right_instramp_to_analog0(right_instramp_to_analog0),
	.right_instramp_to_amuxbusA(right_instramp_to_amuxbusA),
	.right_instramp_to_gpio3_0(right_instramp_to_gpio3_0),
	.left_instramp_n_to_gpio5_7(left_instramp_n_to_gpio5_7),
	.left_instramp_n_to_analog1(left_instramp_n_to_analog1),
	.left_instramp_n_to_amuxbusB(left_instramp_n_to_amuxbusB),
	.left_instramp_n_to_sio1(left_instramp_n_to_sio1),
	.left_instramp_n_to_right_vref(left_instramp_n_to_right_vref),
	.left_instramp_n_to_vinref(left_instramp_n_to_vinref),
	.left_instramp_p_to_gpio5_6(left_instramp_p_to_gpio5_6),
	.left_instramp_p_to_analog0(left_instramp_p_to_analog0),
	.left_instramp_p_to_amuxbusA(left_instramp_p_to_amuxbusA),
	.left_instramp_p_to_sio0(left_instramp_p_to_sio0),
	.left_instramp_p_to_tempsense(left_instramp_p_to_tempsense),
	.left_instramp_p_to_left_vref(left_instramp_p_to_left_vref),
	.left_instramp_p_to_voutref(left_instramp_p_to_voutref),
	.right_instramp_n_to_analog1(right_instramp_n_to_analog1),
	.right_instramp_n_to_amuxbusB(right_instramp_n_to_amuxbusB),
	.right_instramp_n_to_sio1(right_instramp_n_to_sio1),
	.right_instramp_n_to_right_vref(right_instramp_n_to_right_vref),
	.right_instramp_n_to_vinref(right_instramp_n_to_vinref),
	.right_instramp_n_to_gpio2_6(right_instramp_n_to_gpio2_6),
	.right_instramp_p_to_analog0(right_instramp_p_to_analog0),
	.right_instramp_p_to_amuxbusA(right_instramp_p_to_amuxbusA),
	.right_instramp_p_to_sio0(right_instramp_p_to_sio0),
	.right_instramp_p_to_tempsense(right_instramp_p_to_tempsense),
	.right_instramp_p_to_left_vref(right_instramp_p_to_left_vref),
	.right_instramp_p_to_voutref(right_instramp_p_to_voutref),
	.right_instramp_p_to_gpio2_7(right_instramp_p_to_gpio2_7),
	.ulpcomp_p_to_dac0(ulpcomp_p_to_dac0),
	.ulpcomp_p_to_analog1(ulpcomp_p_to_analog1),
	.ulpcomp_p_to_sio0(ulpcomp_p_to_sio0),
	.ulpcomp_p_to_vbgtc(ulpcomp_p_to_vbgtc),
	.ulpcomp_p_to_tempsense(ulpcomp_p_to_tempsense),
	.ulpcomp_p_to_left_vref(ulpcomp_p_to_left_vref),
	.ulpcomp_p_to_voutref(ulpcomp_p_to_voutref),
	.ulpcomp_p_to_gpio6_0(ulpcomp_p_to_gpio6_0),
	.ulpcomp_p_to_gpio1_7(ulpcomp_p_to_gpio1_7),
	.ulpcomp_n_to_dac1(ulpcomp_n_to_dac1),
	.ulpcomp_n_to_analog0(ulpcomp_n_to_analog0),
	.ulpcomp_n_to_sio1(ulpcomp_n_to_sio1),
	.ulpcomp_n_to_vbgsc(ulpcomp_n_to_vbgsc),
	.ulpcomp_n_to_right_vref(ulpcomp_n_to_right_vref),
	.ulpcomp_n_to_vinref(ulpcomp_n_to_vinref),
	.ulpcomp_n_to_gpio6_1(ulpcomp_n_to_gpio6_1),
	.ulpcomp_n_to_gpio1_6(ulpcomp_n_to_gpio1_6),
	.comp_p_to_dac0(comp_p_to_dac0),
	.comp_p_to_analog1(comp_p_to_analog1),
	.comp_p_to_sio0(comp_p_to_sio0),
	.comp_p_to_vbgtc(comp_p_to_vbgtc),
	.comp_p_to_tempsense(comp_p_to_tempsense),
	.comp_p_to_left_vref(comp_p_to_left_vref),
	.comp_p_to_voutref(comp_p_to_voutref),
	.comp_p_to_gpio6_2(comp_p_to_gpio6_2),
	.comp_p_to_gpio1_5(comp_p_to_gpio1_5),
	.comp_n_to_dac1(comp_n_to_dac1),
	.comp_n_to_analog0(comp_n_to_analog0),
	.comp_n_to_sio1(comp_n_to_sio1),
	.comp_n_to_vbgsc(comp_n_to_vbgsc),
	.comp_n_to_right_vref(comp_n_to_right_vref),
	.comp_n_to_vinref(comp_n_to_vinref),
	.comp_n_to_gpio6_3(comp_n_to_gpio6_3),
	.comp_n_to_gpio1_4(comp_n_to_gpio1_4),
	.adc0_to_dac0(adc0_to_dac0),
	.adc0_to_analog1(adc0_to_analog1),
	.adc0_to_vbgtc(adc0_to_vbgtc),
	.adc0_to_tempsense(adc0_to_tempsense),
	.adc0_to_left_vref(adc0_to_left_vref),
	.adc0_to_voutref(adc0_to_voutref),
	.adc0_to_gpio6_4(adc0_to_gpio6_4),
	.adc0_to_gpio1_3(adc0_to_gpio1_3),
	.adc1_to_dac1(adc1_to_dac1),
	.adc1_to_analog0(adc1_to_analog0),
	.adc1_to_vbgsc(adc1_to_vbgsc),
	.adc1_to_right_vref(adc1_to_right_vref),
	.adc1_to_vinref(adc1_to_vinref),
	.adc1_to_gpio6_5(adc1_to_gpio6_5),
	.adc1_to_gpio1_2(adc1_to_gpio1_2),
	.sio0_connect(sio0_connect),
	.sio1_connect(sio1_connect),
	.analog0_connect(analog0_connect),
	.analog1_connect(analog1_connect),
	.vbgtc_to_user(vbgtc_to_user),
	.vbgsc_to_user(vbgsc_to_user),
	.user_to_comp_n(user_to_comp_n),
	.user_to_comp_p(user_to_comp_p),
	.user_to_ulpcomp_n(user_to_ulpcomp_n),
	.user_to_ulpcomp_p(user_to_ulpcomp_p),
	.user_to_adc0(user_to_adc0),
	.user_to_adc1(user_to_adc1),
	.dac0_to_user(dac0_to_user),
	.dac1_to_user(dac1_to_user),
	.tempsense_to_user(tempsense_to_user),
	.right_vref_to_user(right_vref_to_user),
	.left_vref_to_user(left_vref_to_user),
	.vinref_to_user(vinref_to_user),
	.voutref_to_user(voutref_to_user),
	.dac0_to_analog1(dac0_to_analog1),
	.dac1_to_analog0(dac1_to_analog0),
	.audiodac_out_to_analog1(audiodac_out_to_analog1),
	.audiodac_outb_to_analog0(audiodac_outb_to_analog0),

	.left_instramp_ena(left_instramp_ena),
	.left_instramp_G1(left_instramp_G1),
	.left_instramp_G2(left_instramp_G2),
	.left_hgbw_opamp_ena(left_hgbw_opamp_ena),
	.left_lp_opamp_ena(left_lp_opamp_ena),
	.left_rheostat1_b(left_rheostat1_b),
	.left_rheostat2_b(left_rheostat2_b),
	.right_instramp_ena(right_instramp_ena),
	.right_instramp_G1(right_instramp_G1),
	.right_instramp_G2(right_instramp_G2),
	.right_hgbw_opamp_ena(right_hgbw_opamp_ena),
	.right_lp_opamp_ena(right_lp_opamp_ena),
	.right_rheostat1_b(right_rheostat1_b),
	.right_rheostat2_b(right_rheostat2_b),
	.comp_ena(comp_ena),
	.comp_trim(comp_trim),
	.comp_hyst(comp_hyst),
	.ulpcomp_ena(ulpcomp_ena),
	.ulpcomp_clk(ulpcomp_clk),
	.bandgap_ena(bandgap_ena),
	.bandgap_trim(bandgap_trim),
	.bandgap_sel(bandgap_sel),
	.ldo_ena(ldo_ena),
	.overvoltage_ena(overvoltage_ena),
	.overvoltage_trim(overvoltage_trim),
	.ldo_ref_sel(ldo_ref_sel),
	.ibias_ena(ibias_ena),
	.ibias_src_ena(ibias_src_ena),
	.ibias_snk_ena(ibias_snk_ena),
	.ibias_ref_select(ibias_ref_select),
	.idac_value(idac_value),
	.idac_ena(idac_ena),
	.tempsense_ena(tempsense_ena),
	.tempsense_sel(tempsense_sel),
	.rdac0_ena(rdac0_ena),
	.rdac0_value(rdac0_value),
	.rdac1_ena(rdac1_ena),
	.rdac1_value(rdac1_value),
	.brownout_ena(brownout_ena),
	.brownout_vtrip(brownout_vtrip),
	.brownout_otrip(brownout_otrip),
	.brownout_isrc_sel(brownout_isrc_sel),
	.brownout_oneshot(brownout_oneshot),
	.brownout_rc_ena(brownout_rc_ena),
	.brownout_rc_dis(brownout_rc_dis),
	.brownout_vunder(brownout_vunder),
	.brownout_timeout(brownout_timeout),
	.brownout_filt(brownout_filt),
	.brownout_unfilt(brownout_unfilt),
	.comp_out(comp_out),
	.ulpcomp_out(ulpcomp_out),
	.overvoltage_out(overvoltage_out),
	.vdda1_pwr_good(vdda1_pwr_good),
	.vccd1_pwr_good(vccd1_pwr_good),
	.vdda2_pwr_good(vdda2_pwr_good),
	.vccd2_pwr_good(vccd2_pwr_good)

);

// Flash controller reset cycles: Set to 999 for proper initialization.
// Note: This may slow down gate-level simulations but is required for correct
// flash controller operation. For faster RTL simulations, consider using a
// smaller value (e.g., 10-50) if flash initialization timing is not critical.
wire flash_sc_in, flash_sc_out;

EF_QSPI_XIP_CTRL_AHBL#( .NUM_LINES(16),.LINE_SIZE(32), .RESET_CYCLES(999) ) 
	flash_ctrl (
		.HCLK(clk),
		.HRESETn(rst_n),


		.HSEL(1'b1),
		.HADDR(flash_haddr),
		.HTRANS(flash_htrans),
		.HWRITE(flash_hwrite),
		.HREADY(flash_hready),
		.HREADYOUT(flash_hready_resp),
		.HRDATA(flash_hrdata),

		.sck(fr_sck),
		.ce_n(fr_ce_n),
		.din (fr_din),
		.dout(fr_dout),
		.douten(fr_douten)
	);
	// Flash controller always responds with OK (no error response)
	// Error handling is managed internally by the flash controller
	assign flash_hresp = 0;

endmodule


