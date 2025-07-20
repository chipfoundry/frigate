import os
import re
import click


@click.command(
    help="""
    generate def template from a template gds that includes only pins
    """
)
@click.option(
    "--gds",
    required=True,
    type=click.Path(exists=True, dir_okay=False),
    help="Template gds path",
)
@click.option(
    "--pdk_root",
    required=True,
    type=click.Path(exists=True, file_okay=False),
    help="PDK root path",
)
@click.option(
    "--out_def",
    "-o",
    type=str,
    help="output def path. Default:./frigate_core.def",
    default="frigate_core.def"
)
@click.option(
    "--power",
    "-p",
    type=str,
    multiple=True,
    help="Power pins"
)
@click.option(
    "--ground",
    "-g",
    type=str,
    multiple=True,
    help="Ground pins"
)
def main(
    gds, pdk_root, out_def, power, ground
):
    def_tcl = "def.tcl"
    cell_name = gds.split("/")[-1].split(".gds")[0]
    tmp_def = "tmp.def"
    write_tcl(def_tcl, cell_name, gds, tmp_def, power, ground, pdk_root)

    # check if .ext exists in cwd
    if os.path.exists(f"{cell_name}.ext"):
        print("Extracted netlist for the same cell exists in CWD. This will result in incorrect template def as it will include nets. Please remove it and run again")
        exit(1) 
    cmd = f"magic -rcfile {pdk_root}/sky130A/libs.tech/magic/sky130A.magicrc -noconsole -dnull {def_tcl}"
    os.system(cmd)

    print("\nParsing output DEF to bundle pins of multiple shapes in one pin definition.\n")

    with open(tmp_def, "r") as infile:
        def_lines = infile.readlines()

    cmd = f"rm -rf {tmp_def}"
    os.system(cmd)

    end_found = True
    pin_map = dict()
    pins_start_regex = re.compile("PINS ([0-9]+) ;")
    for i, line in enumerate(def_lines):
        words = line.split()
        if not words:
            continue
        if pins_start_regex.match(line):
            pins_start = i
        if "END PINS" in line:
            pins_end = i
        if words[0] == "-":
            end_found = False
            k = words[1]
            start_idx = i
        elif not end_found and ";" in line:
            end_found = True
            end_idx = i    
            if k in pin_map.keys():
                pin_map[k].append((start_idx, end_idx))
            else:
                pin_map[k] = [(start_idx, end_idx), ]

    filtered_pin_map = {k: v for k, v in pin_map.items() if len(v) >= 2}
    
    pin_metadata = dict()

    for k, v in pin_map.items():
        if k in filtered_pin_map:
            pin_shape = list()
            use = list()
            for i, j in v:
                line = def_lines[i+1]
                if "USE" in line: 
                    if line not in use:
                        use.append(def_lines[i+1])
                pin_shape.append("     + PORT\n" + def_lines[j].split(";")[0] + "\n")
            pin_shape[-1] = pin_shape[-1][:-2]
            pin_metadata[k] = [def_lines[v[0][0]]] + use + pin_shape + [" ;\n",]
        else:
            pin_metadata[k] = def_lines[v[0][0]:v[0][1]+1]

    print(f"\nUpdating pins section in output DEF: {out_def}\n")
    pin_section = []
    for k, v in pin_metadata.items():
        pin_section.extend(v)
        
    out_def_lines = def_lines[:pins_start+1] + pin_section + def_lines[pins_end:]

    with open(out_def, "w") as outfile:
        outfile.writelines(out_def_lines)



def write_tcl(tcl_path, cell_name, gds, out_def, power, ground, pdk_root):
    lines = []
    lines.append(f"lef read {pdk_root}/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef\n")
    lines.append(f"gds read {gds}\n")
    lines.append(f"load {cell_name}\n")
    lines.append(f"select top cell\n")
    for pin in power:
        lines.append(f"port {pin} use power\n")
    for pin in ground:
        lines.append(f"port {pin} use ground\n")
    out_def = out_def.split(".def")[0]
    lines.append(f"def write {out_def}\n")
    lines.append(f"quit\n")
    with open(tcl_path, "w") as f:
        f.writelines(lines)
        f.close()

if __name__ == "__main__":
    main()