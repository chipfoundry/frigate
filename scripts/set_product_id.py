#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

#----------------------------------------------------------------------
#
# set_product_id.py ---
#
# Manipulate the magic database and verilog source files for the
# product_id_rom_8bit block to set the product ID number.
#
# product_id_rom_8bit layout map:
# Positions marked (in microns) for value = 0.  For value = 1, move
# the via 0.69um to the left. The given position is the lower left
# corner position of the via. The via itself is 0.17um x 0.17um.
# The values below are for the file product_id_rom_8bit.
#
# Signal            Via position (um)
# name		        X       Y
#-------------------------------------------------------------------
# gpio_defaults[0]  2.785   3.825
# gpio_defaults[1]	4.165   3.825
# gpio_defaults[2]	5.545   3.825
# gpio_defaults[3]	6.925   3.825
# gpio_defaults[4]	8.305   3.825
# gpio_defaults[5]	9.685   3.825
# gpio_defaults[6]	11.985  3.825
# gpio_defaults[7]  13.365  3.825
#----------------------------------------------------------------------

import os
import sys
import re
import subprocess

def usage():
    print("Usage:")
    print("set_product_id.py [<product_id_value>] [<path_to_project>]")
    print("")
    print("where:")
    print("    <product_id_value>   is a character string of two hex digits, and")
    print("    <path_to_project> is the path to the project top level directory.")
    print("")
    print("  If <product_id_value> is not given, then it must exist in the info.yaml file.")
    print("  If <path_to_project> is not given, then it is assumed to be the cwd.")
    return 0

if __name__ == '__main__':

    # Coordinate pairs in microns for the zero position on each bit
    via_pos = [
        [2.785,  3.825], [4.165,  3.825], [5.545,  3.825], [6.925,  3.825],
        [8.305,  3.825], [9.685,  3.825], [11.985, 3.825], [13.365, 3.825]
    ]
    magic_scale = 200
    via_delta = -0.69
    via_len = 0.17
    optionlist = []
    arguments = []

    debugmode = False
    reportmode = False

    for option in sys.argv[1:]:
        if option.find('-', 0) == 0:
            optionlist.append(option)
        else:
            arguments.append(option)

    if len(arguments) > 2:
        print("Wrong number of arguments given to set_product_id.py.")
        usage()
        sys.exit(0)

    if '-debug' in optionlist:
        debugmode = True
    if '-report' in optionlist:
        reportmode = True

    product_id_value = None
    product_path = None

    if len(arguments) > 0:
        product_id_value = arguments[0]
        print(product_id_value)

        # Convert to binary
        try:
            product_id_int = int('0x' + product_id_value, 0)
            product_id_bits = '{0:08b}'.format(product_id_int)[::-1]
        except:
            product_path = arguments[0]

    if len(arguments) == 0:
        product_path = os.getcwd()
    elif len(arguments) == 2:
        product_path = arguments[1]
    elif product_path == None:
        product_path = arguments[0]
    else:
        product_path = os.getcwd()

    if not os.path.isdir(product_path):
        print('Error:  Project path "' + product_path + '" does not exist or is not readable.')
        sys.exit(1)

    # Check for valid directories

    if not product_id_value:
        if os.path.isfile(product_path + '/info.yaml'):
            with open(product_path + '/info.yaml', 'r') as ifile:
                infolines = ifile.read().splitlines()
                for line in infolines:
                    kvpair = line.split(':')
                    if len(kvpair) == 2:
                        key = kvpair[0].strip()
                        value = kvpair[1].strip()
                        if key == 'project_id':
                            product_id_value = value.strip('"\'')
                            break

            if not product_id_value:
                print('Error:  No project_id key:value pair found in project info.yaml.')
                sys.exit(1)

            try:
                product_id_int = int('0x' + product_id_value, 0)
                product_id_bits = '{0:08b}'.format(product_id_int)[::-1]
            except:
                print('Error:  Cannot parse product ID "' + product_id_value + '" as an 2-digit hex number.')
                sys.exit(1)

        elif reportmode:
            found = False
            idrex = re.compile("parameter PRODUCT_ID = 8'h([0-9A-F]+);")

            # Check if PRODUCT_ID has a non-zero value in frigate_core.v
            rtl_top_path = product_path + '/verilog/rtl/frigate_core.v'
            if os.path.isfile(rtl_top_path):
                with open(rtl_top_path, 'r') as ifile:
                    vlines = ifile.read().splitlines()
                    outlines = []
                    for line in vlines:
                        imatch = idrex.search(line)
                        if imatch:
                            product_id_int = int('0x' + imatch.group(1), 0)
                            found = True
                            break
            else:
                print('Error:  Cannot find top-level RTL ' + rtl_top_path + '.  Is this script being run in the project directory?')
            if not found:
                if reportmode:
                    product_id_int = 0
                else:
                    print('Error:  No PRODUCT_ID found in frigate core top level verilog.')
                    sys.exit(1)
        else:
            print('Error:  No info.yaml file and no product ID argument given.')
            sys.exit(1)

    if reportmode:
        print(str(product_id_int))
        sys.exit(0)

    if product_id_int == 0:
        print('Value zero is an invalid product ID.  Exiting.')
        sys.exit(1)

    print('Setting project product ID to: ' + product_id_value)

    magpath = product_path + '/mag'
    vpath = product_path + '/verilog'
    errors = 0 

    if not os.path.isdir(vpath):
        print('No directory ' + vpath + ' found (path to verilog).')
        sys.exit(1)

    if not os.path.isdir(magpath):
        print('No directory ' + magpath + ' found (path to magic databases).')
        sys.exit(1)

    print('Step 1:  Modify layout of the product_id_rom_8bit subcell')

    # Read the ID programming layout.  If a backup was made of the
    # zero-value program, then use it.

    magbak = magpath + '/product_id_rom_8bit_zero.mag'
    magfile = magpath + '/product_id_rom_8bit.mag'

    if os.path.isfile(magbak):
        with open(magbak, 'r') as ifile:
            magdata = ifile.read()
    else:
        with open(magfile, 'r') as ifile:
            magdata = ifile.read()

    for i in range(0,8):
        # Ignore any zero bits.
        if product_id_bits[i] == '0':
            continue
 
        # Get the values for the corner coordinates in magic internal units
        llx_zero = round(via_pos[i][0] * magic_scale)
        lly_zero = round(via_pos[i][1] * magic_scale)
        urx_zero = llx_zero + int(via_len * magic_scale)
        ury_zero = lly_zero + int(via_len * magic_scale)

        viaoldposdata = f"rect {llx_zero} {lly_zero} {urx_zero} {ury_zero}"

        # For "one" bits, the X position is moved via delta microns to the left
        llx_one = llx_zero + int(via_delta * magic_scale)
        lly_one = lly_zero
        urx_one = urx_zero + int(via_delta * magic_scale)
        ury_one = ury_zero

        vianewposdata = f"rect {llx_one} {lly_one} {urx_one} {ury_one}"

        # Diagnostic
        if debugmode:
            print('Bit ' + str(i) + ':')
            print('Old string = "' + viaoldposdata + '"')
            print('New string = "' + vianewposdata + '"')

        # Replace the old data with the new
        if viaoldposdata not in magdata:
            print('Error: via not found for bit position ' + str(i))
            errors += 1 
        else:
            magdata = magdata.replace(viaoldposdata, vianewposdata)

    if errors == 0:
        # Keep a copy of the original 
        if not os.path.isfile(magbak):
            os.rename(magfile, magbak)

        with open(magfile, 'w') as ofile:
            ofile.write(magdata)

        print('Done!')
            
    else:
        print('There were errors in processing.  No file written.')
        print('Ending process.')
        sys.exit(1)

    print('Step 2:  Add product project ID parameter to source verilog.')

    changed = False
    rtl_done = False
    with open(vpath + '/rtl/frigate_core.v', 'r') as ifile:
        vlines = ifile.read().splitlines()
        outlines = []
        rtl_update = "parameter PRODUCT_ID = 8'h" + product_id_value + ";"
        for line in vlines:
            if rtl_update in line:
                rtl_done = True
                print("PRODUCT ID = 8'h" + product_id_value + ' exists in verilog/rtl/frigate_core.v.')
                break
            oline = re.sub("parameter PRODUCT_ID = 8'h[0-9A-F]+;",rtl_update,line)
            if oline != line:
                changed = True
            outlines.append(oline)

    if not rtl_done:
        if changed:
            with open(vpath + '/rtl/frigate_core.v', 'w') as ofile:
                for line in outlines:
                    print(line, file=ofile)
                print('Done!')
        else:
            print('Error:  No substitutions done on verilog/rtl/frigate_core.v.')
            print('Ending process.')
            sys.exit(1)

    print('Step 3:  Add product project ID parameter to gate-level verilog.')

    changed = False
    with open(vpath + '/gl/product_id_rom_8bit.v', 'r') as ifile:
        vdata = ifile.read()

    for i in range(0,8):
        # Ignore any zero bits.
        if product_id_bits[i] == '0':
            continue

        vdata = vdata.replace('assign gpio_defaults[' + str(i) + '] = \\gpio_defaults_low', 
                              'assign gpio_defaults[' + str(i) + '] = \\gpio_defaults_high')
        changed = True

    if changed:
        with open(vpath + '/gl/product_id_rom_8bit.v', 'w') as ofile:
            ofile.write(vdata)
            print('Done!')
    else:
        print('Error:  No substitutions done on verilog/gl/product_id_rom_8bit.v.')
        print('Ending process.')
        sys.exit(1)

    sys.exit(0)
