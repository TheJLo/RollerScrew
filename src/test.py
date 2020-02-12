#! /usr/bin/env python3

#from solid import *

#f = open("myTest.txt", 'w')

#f.write('It worked!!')

#f.close()

from rsgl_parts import *

class test(RSGL_Part):
    
    def __init__(self):
        print('Can do stuff!')
        
    def generate_geometry(self):
        print('Generating!!!!')
        a = union()
        b = union()
        c = a + b
        print('Done!')

    
n_t = test()

n_t.generate_geometry()
