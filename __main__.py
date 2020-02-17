#! /usr/bin/env python3

# Author: Jacob Loss
# Main run file for Roller Screw Program
# | Will switch into virtual env and run program
# | Install scripts will install the virtual enviroment and packages

import platform
import subprocess
import configparser

# First, check that install was run

# Next, get path to python enviroment

plat = platform.system()    # Could get these from a install file

entry = './src/rsgl_assembly.py'

config_file = './config.ini'

config = configparser.ConfigParser()
config.read(config_file)

path = config['VENV']['Executable']

subprocess.call([path, entry])
