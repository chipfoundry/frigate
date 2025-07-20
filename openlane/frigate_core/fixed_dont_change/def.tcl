lef read /home/passant/.ciel/ciel/sky130/versions/823ec23c421cfb1d6aec06b8140cbde11cbc95a0//sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
gds read frigate_core.gds
load frigate_core
select top cell
port vdda0 use power
port vdda1 use power
port vdda2 use power
port vdda3 use power
port vddio use power
port vccd0 use power
port vccd1 use power
port vccd2 use power
port vssd0 use ground
port vssd1 use ground
port vssd2 use ground
port vssa0 use ground
port vssa1 use ground
port vssa2 use ground
port vssa3 use ground
port vssio use ground
def write tmp
quit
