drc off
crashbackups stop
gds readonly true
gds rescale false

gds read ./gds/analog_routes.gds
load analog_routes

property LEFclass COVER
select top cell
expand
lef write lef/analog_routes2.lef
exit
