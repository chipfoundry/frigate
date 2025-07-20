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
# set_user_id.py ---
#
# Manipulate the magic database and verilog source files for the
# project_id_rom_32bit block to set the user ID number.
#
# The user ID number is a 32-bit value that is passed to this routine
# as an 8-digit hex number.  If not given as an option, then the script
# will look for the value of the key "project_id" in the info.yaml file
# in the project top level directory.  If in "-report" mode, it will
# check the RTL top-level verilog to see if set_user_id.py has already
# been applied, and pull the value from there.
#
# project_id_rom_32bit layout map:
# Positions marked (in microns) for value = 0.  For value = 1, move
# the via 0.69um to the left.
#
# Signal             Via position (um)
# name		         X       Y
#-------------------------------------------------------------------
# gpio_defaults[0]   2.785   3.825
# gpio_defaults[1]   2.785   9.345
# gpio_defaults[2]	 4.165   3.825
# gpio_defaults[3]	 4.165   9.345
# gpio_defaults[4]	 5.545   3.825
# gpio_defaults[5]	 5.545   9.345
# gpio_defaults[6]	 6.925   3.825
# gpio_defaults[7]	 6.925   9.345
# gpio_defaults[8]   8.305   3.825
# gpio_defaults[9]   8.305   9.345
# gpio_defaults[10]	 9.685   3.825
# gpio_defaults[11]	 9.685   9.345
# gpio_defaults[12]	 11.985  3.825
# gpio_defaults[13]	 11.985  9.345
# gpio_defaults[14]	 13.365  3.825
# gpio_defaults[15]	 13.365  9.345
# gpio_defaults[16]  14.745  3.825
# gpio_defaults[17]  14.745  9.345
# gpio_defaults[18]	 16.585  3.825
# gpio_defaults[19]	 16.585  9.345
# gpio_defaults[20]	 17.965  3.825
# gpio_defaults[21]	 17.965  9.345
# gpio_defaults[22]	 19.345  3.825
# gpio_defaults[23]	 19.345  9.345
# gpio_defaults[24]  20.725  3.825
# gpio_defaults[25]  20.725  9.345
# gpio_defaults[26]	 22.105  3.825
# gpio_defaults[27]	 22.105  9.345
# gpio_defaults[28]	 23.945  3.825
# gpio_defaults[29]	 23.945  9.345
# gpio_defaults[30]	 25.325  3.825
# gpio_defaults[31]	 25.325  9.345
#----------------------------------------------------------------------
import os
import sys
import re
import subprocess

def usage():
    print("Usage:")
    print("set_user_id.py [<user_id_value>] [<path_to_project>]")
    print("")
    print("where:")
    print("    <user_id_value>   is a character string of eight hex digits, and")
    print("    <path_to_project> is the path to the project top level directory.")
    print("")
    print("  If <user_id_value> is not given, then it must exist in the info.yaml file.")
    print("  If <path_to_project> is not given, then it is assumed to be the cwd.")
    return 0

if __name__ == '__main__':

    # Coordinate pairs in microns for the zero position on each bit
    via_pos = [
        [2.785,  3.825], [2.785,  9.345], [4.165,  3.825], [4.165,  9.345],
        [5.545,  3.825], [5.545,  9.345], [6.925,  3.825], [6.925,  9.345],
        [8.305,  3.825], [8.305,  9.345], [9.685,  3.825], [9.685,  9.345], 
        [11.985, 3.825], [11.985, 9.345], [13.365, 3.825], [13.365, 9.345],
        [14.745, 3.825], [14.745, 9.345], [16.585, 3.825], [16.585, 9.345],
        [17.965, 3.825], [17.965, 9.345], [19.345, 3.825], [19.345, 9.345],
        [20.725, 3.825], [20.725, 9.345], [22.105, 3.825], [22.105, 9.345],
        [23.945, 3.825], [23.945, 9.345], [25.325, 3.825], [25.325, 9.345],
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
        print("Wrong number of arguments given to set_user_id.py.")
        usage()
        sys.exit(0)

    if '-debug' in optionlist:
        debugmode = True
    if '-report' in optionlist:
        reportmode = True

    user_id_value = None
    user_project_path = None

    if len(arguments) > 0:
        user_id_value = arguments[0]
        print(user_id_value)

        # Convert to binary
        try:
            user_id_int = int('0x' + user_id_value, 0)
            user_id_bits = '{0:032b}'.format(user_id_int)[::-1]
        except:
            user_project_path = arguments[0]

    if len(arguments) == 0:
        user_project_path = os.getcwd()
    elif len(arguments) == 2:
        user_project_path = arguments[1]
    elif user_project_path == None:
        user_project_path = arguments[0]
    else:
        user_project_path = os.getcwd()

    if not os.path.isdir(user_project_path):
        print('Error:  Project path "' + user_project_path + '" does not exist or is not readable.')
        sys.exit(1)

    # Check for valid directories

    if not user_id_value:
        if os.path.isfile(user_project_path + '/info.yaml'):
            with open(user_project_path + '/info.yaml', 'r') as ifile:
                infolines = ifile.read().splitlines()
                for line in infolines:
                    kvpair = line.split(':')
                    if len(kvpair) == 2:
                        key = kvpair[0].strip()
                        value = kvpair[1].strip()
                        if key == 'project_id':
                            user_id_value = value.strip('"\'')
                            break

            if not user_id_value:
                print('Error:  No project_id key:value pair found in project info.yaml.')
                sys.exit(1)

            try:
                user_id_int = int('0x' + user_id_value, 0)
                user_id_bits = '{0:032b}'.format(user_id_int)[::-1]
            except:
                print('Error:  Cannot parse user ID "' + user_id_value + '" as an 8-digit hex number.')
                sys.exit(1)

        elif reportmode:
            found = False
            idrex = re.compile("parameter USER_PROJECT_ID = 32'h([0-9A-F]+);")

            # Check if USER_PROJECT_ID has a non-zero value in frigate_core.v
            rtl_top_path = user_project_path + '/verilog/rtl/frigate_core.v'
            if os.path.isfile(rtl_top_path):
                with open(rtl_top_path, 'r') as ifile:
                    vlines = ifile.read().splitlines()
                    outlines = []
                    for line in vlines:
                        imatch = idrex.search(line)
                        if imatch:
                            user_id_int = int('0x' + imatch.group(1), 0)
                            found = True
                            break
            else:
                print('Error:  Cannot find top-level RTL ' + rtl_top_path + '.  Is this script being run in the project directory?')
            if not found:
                if reportmode:
                    user_id_int = 0
                else:
                    print('Error:  No USER_PROJECT_ID found in frigate core top level verilog.')
                    sys.exit(1)
        else:
            print('Error:  No info.yaml file and no user ID argument given.')
            sys.exit(1)

    if reportmode:
        print(str(user_id_int))
        sys.exit(0)

    if user_id_int == 0:
        print('Value zero is an invalid user ID.  Exiting.')
        sys.exit(1)

    print('Setting project user ID to: ' + user_id_value)

    magpath = user_project_path + '/mag'
    vpath = user_project_path + '/verilog'
    errors = 0 

    if not os.path.isdir(vpath):
        print('No directory ' + vpath + ' found (path to verilog).')
        sys.exit(1)

    if not os.path.isdir(magpath):
        print('No directory ' + magpath + ' found (path to magic databases).')
        sys.exit(1)

    print('Step 1:  Modify layout of the project_id_rom_32bit subcell')

    # Read the ID programming layout.  If a backup was made of the
    # zero-value program, then use it.

    magbak = magpath + '/project_id_rom_32bit_zero.mag'
    magfile = magpath + '/project_id_rom_32bit.mag'

    if os.path.isfile(magbak):
        with open(magbak, 'r') as ifile:
            magdata = ifile.read()
    else:
        with open(magfile, 'r') as ifile:
            magdata = ifile.read()

    for i in range(0,32):
        # Ignore any zero bits.
        if user_id_bits[i] == '0':
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

    print('Step 2:  Add user project ID parameter to source verilog.')

    changed = False
    rtl_done = False
    with open(vpath + '/rtl/frigate_core.v', 'r') as ifile:
        vlines = ifile.read().splitlines()
        outlines = []
        rtl_update = "parameter USER_PROJECT_ID = 32'h" + user_id_value + ";"
        for line in vlines:
            if rtl_update in line:
                rtl_done = True
                print("USER PROJECT ID = 32'h" + user_id_value + ' exists in verilog/rtl/frigate_core.v.')
                break
            oline = re.sub("parameter USER_PROJECT_ID = 32'h[0-9A-F]+;",rtl_update,line)
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

    print('Step 3:  Add user project ID parameter to gate-level verilog.')

    changed = False
    with open(vpath + '/gl/project_id_rom_32bit.v', 'r') as ifile:
        vdata = ifile.read()

    for i in range(0,32):
        # Ignore any zero bits.
        if user_id_bits[i] == '0':
            continue

        if len(str(i)) == 1:
            vdata = vdata.replace('assign gpio_defaults[' + str(i) + ']  = \\gpio_defaults_low', 
                                  'assign gpio_defaults[' + str(i) + ']  = \\gpio_defaults_high')
        elif len(str(i)) == 2:
            vdata = vdata.replace('assign gpio_defaults[' + str(i) + '] = \\gpio_defaults_low', 
                                  'assign gpio_defaults[' + str(i) + '] = \\gpio_defaults_high')

        changed = True

    if changed:
        with open(vpath + '/gl/project_id_rom_32bit.v', 'w') as ofile:
            ofile.write(vdata)
            print('Done!')
    else:
        print('Error:  No substitutions done on verilog/gl/project_id_rom_32bit.v.')
        print('Ending process.')
        sys.exit(1)

    print('Step 4:  Add user project ID text to top level layout.')

    with open(magpath + '/user_id_textblock.mag', 'r') as ifile:
        maglines = ifile.read().splitlines()
        outlines = []
        digit = 0
        wasseen = {}
        for line in maglines:
            if 'alphaX_' in line:
                dchar = user_id_value[7 - digit].upper()
                oline = re.sub('alpha_[0-9A-F]', 'alpha_' + dchar, line)
                # Add path reference if cell was not previously found in the file
                if dchar not in wasseen:
                    if 'hexdigits' not in oline:
                        oline += ' hexdigits'
                outlines.append(oline)
                wasseen[dchar] = True
                digit += 1
            else:
                outlines.append(line)

    if digit == 8:
        with open(magpath + '/user_id_textblock.mag', 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
        print('Done!')
    elif digit == 0:
        print('Error:  No digits were replaced in the layout.')
    else:
        print('Error:  Only ' + str(digit) + ' digits were replaced in the layout.')

    sys.exit(0)
