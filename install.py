#! /usr/bin/env python3

# Setup file for Roller Screws
# Use this file to build the virtual envrioment
# and to create the install file which tells the 
# main program where to put everything

import venv
import platform
import subprocess
import configparser
import os

venv_dir = "./.venv" # Default, can change this to be argument later

# Get the python3 executable based on OS
plat = platform.system()

if plat == 'Linux' or plat == 'Darwin':
    exe = "./.venv/bin/python3"
elif plat == 'Windows': 
    exe = "./.venv/Scripts/python"

# First create virtual envrioment
print('==== Creating Virtual Enviroment ====')
venv.create(venv_dir, False, True, False, True, None)

# Install necessary packages from requirements.txt
print('==== Installing packages ====')
subprocess.call([exe, '-m', 'pip', 'install', '-r', 'requirements.txt'])

print('==== Making Output Directory ====')
if not os.path.exists("./output"):
    os.mkdir("./output")

# create install.config
print('==== Creating Configuration files ====')
#config_dir = "./config"
#f = open("%s/install.config" % config_dir, "w")

#f.write('# Install Config\n')
#f.write('venv=%s\n' % venv_dir)
#f.write('exe=%s\n' % exe)

#f.close()
# Using Config parser
config = configparser.ConfigParser()
config['VENV'] = {
    'Directory' : venv_dir,
    'Executable' : exe}

with open('config.ini', 'w') as conf:
    config.write(conf)

print('==== Install Complete ====')

