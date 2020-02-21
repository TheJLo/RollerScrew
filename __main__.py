#! /usr/bin/env python3

# Author: Jacob Loss
# Main run file for Roller Screw Program
# | Will switch into virtual env and run program
# | Install scripts will install the virtual enviroment and packages

import platform
import subprocess

# First, check that install was run

# Next, get path to python enviroment

plat = platform.system()    # Could get these from a install file

entry = './src/test.py'

if plat == 'Linux' or plat == 'Darwin':
    # *nix system
    path = "./.venv/bin/python3"
elif plat == 'Windows':
    path = "./.venv/Scripts/python"

subprocess.call([path, entry])
