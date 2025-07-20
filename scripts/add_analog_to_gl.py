import re
import click

@click.command(
    help="""
    Add analog signals and analog power nets defined in the RTL to the GL to get LVS clean.
    
    Examples:
    For Frigate V4 (mid flow):
    python3 scripts/add_analog_to_gl.py --analog-ports -v PnR --gl verilog/gl/frigate_core.v --rtl verilog/rtl/frigate_core.v -m "user_project_wrapper" -m "timing_frontend" -m "analog_sys" -c "timing_frontend" -c "analog_sys" -o verilog/gl/frigate_core.v
    
    For Frigate V4 (end flow):
    python3 scripts/add_analog_to_gl.py -v PnR --gl verilog/gl/frigate_core.v --rtl verilog/rtl/frigate_core.v -m "user_project_wrapper" -m "timing_frontend" -m "analog_sys" -c "timing_frontend" -c "analog_sys" -o verilog/gl/frigate_core.v
    """
)
@click.option(
    "--v_macro", "-v",
    required=True, type=str,
    help="Name of the macro guarding the analog signals in the RTL"
)
@click.option(
    "--gl",
    required=True, type=click.Path(exists=True, dir_okay=False),
    help="Gate-level netlist path"
)
@click.option(
    "--rtl",
    required=True, type=click.Path(exists=True, dir_okay=False),
    help="RTL path"
)
@click.option(
    "--out_gl", "-o",
    type=str, default="frigate_core_eco.v",
    help="Output GL path. Default: ./frigate_core_eco.v"
)
@click.option(
    "--macros", "-m",
    type=str, multiple=True, required=True,
    help="Macros that have analog connections"
)
@click.option(
    "--pwr-dig", "-p",
    type=str, multiple=True, default=["vssd", "vccd"],
    help="Digital power nets to ignore as they are defined by PDN"
)
@click.option(
    "--analog-ports",
    is_flag=True, default=False,
    help="Add port definitions of analog power nets"
)
@click.option(
    "--macros-connect-pwr", "-c",
    type=str, multiple=True, required=True,
    help="Macros requiring connections to digital power nets not connected by PDN"
)
def main(v_macro, rtl, gl, out_gl, macros, pwr_dig, analog_ports, macros_connect_pwr):
    # Read the RTL and GL netlist files
    with open(rtl, "r") as in_file:
        og_rtl = in_file.readlines()
    with open(gl, "r") as in_file:
        og_gl = in_file.readlines()
    
    gl_lines = og_gl  # Gate-level netlist lines
    rtl_lines = og_rtl  # RTL lines
    wires = []  # List of wires to be added
    analog_pwr = []  # List of analog power nets

    # Process each macro for connections and signals
    for macro in macros:
        analog_signals_lst = []  # List of signals for the current macro
        
        # Locate the macro in the GL netlist
        for i, line in enumerate(gl_lines):
            if f"{macro} " in line:
                macro_idx = i
                break
        
        # Locate and process the macro in the RTL
        for i, line in enumerate(rtl_lines):
            if macro in line:
                j = 1
                while True:
                    line = rtl_lines[i + j]
                    if ");" in line:  # End of macro definition
                        break
                    
                    # Process power nets within "ifdef USE_POWER_PINS"
                    if "ifdef USE_POWER_PINS" in line:
                        l = 1
                        while True:
                            signal_line = rtl_lines[i + j + l]
                            if "endif" in signal_line:
                                break
                            if "//" in signal_line.strip()[:2] or signal_line.strip() == "":
                                l += 1
                                continue
                            skip = False
                            for pwr in pwr_dig:
                                if pwr in signal_line:
                                    skip = True
                                    break
                            if not skip:
                                pwr_net = signal_line.split("(")[1].split("),")[0]
                                if pwr_net not in analog_pwr:
                                    analog_pwr.append(pwr_net)
                            if skip and macro not in macros_connect_pwr:
                                l += 1
                                continue
                            analog_signals_lst.append("    " + signal_line.strip().split(",")[0] + ",\n")
                            l += 1
                        j += l - 1
                    
                    # Process signals within "ifndef"
                    if f"ifndef {v_macro}" in line:
                        k = 1
                        while True:
                            signal_line = rtl_lines[i + j + k]
                            if "endif" in signal_line:
                                break
                            if "//" in signal_line.strip()[:2] or signal_line.strip() == "":
                                k += 1
                                continue
                            wire = signal_line.split("(")[1].split("),")[0]
                            if wire not in wires:
                                if "[" in wire:
                                    wire = "\\" + wire + " "  # Escape special characters
                                wires.append(wire)
                            analog_signals_lst.append("    " + signal_line.strip().split(",")[0] + ",\n")
                            k += 1
                        j += k - 1
                    j += 1
                break
        
        # Remove processed macro from RTL and update GL
        rtl_lines = rtl_lines[:i] + rtl_lines[i + j:]
        gl_lines = gl_lines[:macro_idx + 1] + analog_signals_lst + gl_lines[macro_idx + 1:]

    # Add wire declarations and ports to GL
    for i, line in enumerate(og_gl):
        if ");" in line:
            module_end = i
        if "wire" in line:
            wire_idx = i + 1
            break
    
    lst = []  # Additional wires and ports
    ports = []  # Ports for analog power nets
    if analog_ports:
        for port in analog_pwr:
            lst.append(f" inout {port};\n")
            ports.append(f"    {port},\n")
    for wire in wires:
        lst.append(f" wire {wire};\n")
    gl_lines = gl_lines[:wire_idx - 1] + lst + gl_lines[wire_idx - 1:]
    if analog_ports:
        gl_lines = gl_lines[:module_end] + ports + gl_lines[module_end:]

    # Add signal assignments to GL
    assign_lst = []
    for i, line in enumerate(rtl_lines):
        if f"ifndef {v_macro}" in line:
            k = 1
            while True:
                signal_line = rtl_lines[i + k]
                if "endif" in signal_line:
                    break
                if "//" in signal_line.strip()[:2] or signal_line.strip() == "" or "wire" in signal_line:
                    k += 1
                    continue
                assign_lst.append(" " + signal_line.strip() + "\n")
                k += 1
    gl_lines = gl_lines[:-1] + assign_lst + gl_lines[-1:]
    
    # The RAM Workaround
    ram_power_rx = re.compile(r"([\s\t]*)\.(vpwr[ap]c)\((.+?)\)\s*,")
    tracker = 0
    while tracker < len(gl_lines):
        line = gl_lines[tracker]
        if m := ram_power_rx.search(line):
            gl_lines[tracker] = f"`ifdef COCOTB_SIM\n{m[1]}.{m[2]}(1'b1),\n`else\n{m[1]}.{m[2]}({m[3]}),\n`endif\n"
        tracker += 1

    # Write the updated GL file
    with open(out_gl, "w") as gl:
        for line in gl_lines:
            gl.write(line)

if __name__ == "__main__":
    main()
