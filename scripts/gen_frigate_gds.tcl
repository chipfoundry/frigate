drc off

gds readonly true
gds rescale false

shell cp ./mag/user_id_textblock.mag ./dependencies/panamax/mag
shell cp ./mag/copyright_block_frigate.mag ./dependencies/panamax/mag
addpath ./dependencies/panamax/mag

load panamax -dereference
select top cell

cif *hier write disable
cif *array write disable

gds nodatestamp yes

gds write gds/panamax.gds

addpath ./mag

load ./dependencies/frigate_analog/mag/cv3_via_3cut.mag
load ./dependencies/frigate_analog/mag/cv3_via_30cut.mag
load ./dependencies/frigate_analog/mag/cv3_via2_3cut.mag
load ./dependencies/frigate_analog/mag/cv3_via2_6cut.mag
load ./dependencies/frigate_analog/mag/cv3_via2_8cut.mag
load ./dependencies/frigate_analog/mag/cv3_via2_9cut.mag
load ./dependencies/frigate_analog/mag/cv3_via2_36cut.mag
load ./dependencies/frigate_analog/mag/cv3_via3_10cut.mag
load ./dependencies/frigate_analog/mag/cv3_via3_30cut.mag
load ./dependencies/frigate_analog/mag/cv3_via4_2cut.mag
load ./dependencies/frigate_analog/mag/analog_routes_bottom.mag
load ./dependencies/frigate_analog/mag/analog_routes_left.mag
load ./dependencies/frigate_analog/mag/analog_routes_right.mag
load ./dependencies/frigate_analog/mag/analog_routes_top.mag
load ./dependencies/frigate_analog/mag/analog_routes_user.mag
load ./dependencies/frigate_analog/mag/analog_textblock.mag
load ./dependencies/frigate_analog/mag/analog_to_gpio_route_top.mag
load ./dependencies/frigate_analog/mag/analog_to_gpio_route.mag
load ./dependencies/frigate_analog/mag/analog_to_gpio_top_right.mag

load panamax
property LEFview true
property GDS_FILE ./gds/panamax.gds
property GDS_START 0

load frigate_analog
property LEFview true
property GDS_FILE ./dependencies/frigate_analog/gds/frigate_analog.gds.gz
property GDS_START 0

load frigate_timing_frontend
property LEFview true
property GDS_FILE ./dependencies/frigate_analog/gds/frigate_timing_frontend.gds.gz
property GDS_START 0

load EF_SRAM_1024x32
property LEFview true
property GDS_FILE ./ip/EF_SRAM_1024x32/gds/EF_SRAM_1024x32.gds
property GDS_START 0

# load user_project_wrapper -dereference
# select top cell
# paint isosub

# load gpio_logic_high -dereference
# select top cell
# paint isosub

load frigate -dereference
select top cell

cif *hier write disable
cif *array write disable

gds nodatestamp yes

gds write gds/frigate.gds

exit
