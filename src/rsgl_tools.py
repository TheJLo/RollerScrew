#! /usr/bin/env python3

from solid import * 
from solid.utils import *

lib_path = "./libs"

gears_name = "Getriebe.scad"
gears_path = '%s/%s' % (lib_path, gears_name)
gears = import_scad(gears_path)

threads_name = "threads.scad"
threads_path = "%s/%s" % (lib_path, threads_name)
threads = import_scad(threads_path)
