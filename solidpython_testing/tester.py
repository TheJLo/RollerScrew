# This is a testing file for Solid Python
# Use this file to learn the ropes of Solid Python

from solid import *
from solid.utils import *  # Not required, but the utils module is useful

d = difference()(
    cube(10),  # Note the comma between each element!
    sphere(15)
)

scad_render_to_file(d, 'Test.scad')