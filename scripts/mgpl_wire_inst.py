import re
import json
import click

@click.command(
    help="""
    Identifies buffer instance names for certain nets that are passed to manual global placement step due to their awful initial placement.
    In Frigate for example, we use the script to get `soc.apb1_sys_ana_regs_prdata` bus nets wire buffers that are placed on the other side of the chip
    """
)
@click.option(
    "--gl",
    required=True,
    type=click.Path(exists=True, dir_okay=False),
    help="gate-level netlist after GPL path",
)
@click.option(
    "--out_json",
    "-o",
    type=str,
    help="output JSON file path that includes the instances with their locations. Default:./mgpl.json",
    default="mgpl.json"
)
def main(
    gl, out_json
):
    print ("Identifying wire buffers")
    nets = []
    #####
    # Specific to frigate core analog regs prdata
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 2200
    location_l = [min_x_l, start_y_l]
    nets.append(('\\soc.apb1_sys_ana_regs_prdata',32,0,"+", max_x_l, min_x_l, location_l,20,10))
    #####
    #####
    # Specific to frigate core analog regs pwrite
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 2300
    location_l = [min_x_l, start_y_l]
    nets.append(('\\soc.apb1_sys_ana_regs_pwrite',1,0,"", max_x_l, min_x_l, location_l,20,10))
    #####
    #####
    # Specific to frigate core analog regs penable
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 2350
    location_l = [min_x_l, start_y_l]
    nets.append(('\\soc.apb1_sys_ana_regs_penable',1,0,"", max_x_l, min_x_l, location_l,20,10))
    #####
    #####
    # Specific to frigate core gpio control blocks
    max_x_l = 3025
    min_x_l = 2945
    start_y_l = 3260
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_in',8,23,"-", max_x_l, min_x_l, location_l,20,-10))
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 3260
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_in',8,31,"-", max_x_l, min_x_l, location_l,20,-10))
    max_x_l = 3025
    min_x_l = 2945
    start_y_l = 1620
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_oeb',8,23,"-", max_x_l, min_x_l, location_l,20,10))
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 1620
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_oeb',8,31,"-", max_x_l, min_x_l, location_l,20,10))
    max_x_l = 3025
    min_x_l = 2945
    start_y_l = 1700
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_out',8,23,"-", max_x_l, min_x_l, location_l,20,10))
    max_x_l = 151.5
    min_x_l = 71.5
    start_y_l = 1700
    location_l = [min_x_l, start_y_l]
    nets.append(('\\pin_mux_io_out',8,31,"-", max_x_l, min_x_l, location_l,20,10))
    #####
    with open(gl, "r") as in_file:
        gl_lines = in_file.readlines()
    
    wire_map = {}
    for i, line in enumerate(gl_lines):
        if re.search(fr"sky130.*wire|max_cap", line):
            inst_name = line.split()[1]
            in_net = line.split("(")[-1].split(")")[0]
            #remove verilog terminating space if there's a \
            if in_net.startswith("\\"):
                in_net = in_net[:-1]
            out_net = gl_lines[i+1].split("(")[-1].split(")")[0]
            wire_map[in_net] = (inst_name, out_net)
            i+=1
    
    inst = {}
    for v in nets:
        net = v[0]
        size = v[1]
        strt_idx = v[2]
        dir = v[3]
        rng = range(strt_idx, strt_idx + size) if dir == '+' else range(strt_idx, strt_idx - size, -1)
        max_x = v[4]
        min_x = v[5]
        location = v[6]
        delta_x = v[7]
        delta_y = v[8]
        for bit in rng:
            if size > 1: 
                full_net = net + "[" + str(bit) + "]"
            else: 
                full_net = net
            inst_name, next_net = wire_map[full_net]
            inst[inst_name] = {"location" : (location[0], location[1]), "orientation" : "N"}            
            location[0] += delta_x
            if location[0] > max_x:
                location[0] = min_x
                location[1] += delta_y
            while(next_net in wire_map):
                inst_name, next_net = wire_map[next_net]
                inst[inst_name] = {"location" : (location[0], location[1]), "orientation" : "N"}            
                location[0] += delta_x
                if location[0] > max_x:
                    location[0] = min_x
                    location[1] += delta_y

    # por_n ECO buf cell placement
    inst["eco_cell"] = {"location" : (2950, 3850), "orientation" : "N"}
    out_dict = {"MANUAL_GLOBAL_PLACEMENTS": inst}
    json_obj = json.dumps(out_dict, indent=4)

    with open(out_json, "w") as out:
        out.write(json_obj)
    print(f"Instances written to: {out_json}")
if __name__ == "__main__":
    main()