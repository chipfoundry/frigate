To update frigate core template def, do the modification to [frigate_core.gds](frigate_core.gds) and then generate the def by running in this directory:
```
python3 ../../../scripts/gen_def_template.py -p "vdda0" -p "vdda1" -p "vdda2" -p "vdda3" -p "vddio" -p "vccd0" -p "vccd1" -p "vccd2" -g "vssd0" -g "vssd1" -g "vssd2" -g "vssa0" -g "vssa1" -g "vssa2" -g "vssa3" -g "vssio" --gds frigate_core.gds -o frigate_core.def --pdk_root $PDK_ROOT
```

`PDK_ROOT` should be set to the PDK root directory path