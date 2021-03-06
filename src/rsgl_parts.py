#!/usr/bin/env python3
# Generic Part Class
# Import SolidPython
from solid import *
from solid.utils import *

from rsgl_tools import *

# This class acts more as a specification and generator for the geometry than as a representation of the actual objects.
# Each part needs to be self-contained and run without information from the other parts (directly)
# This will allow more flexibility in design as we can change each part individually without affecting the others
class RSGL_Part:
    
    # Needs to be overrided by other classes to be used
    # Create a new instance of this object and return it to the user
    def generate_geometry(self):
        print('Generating Part Geometry')
        return None
    
    def render_to_file(self, path, fn):
        
        if not path.endswith('.scad'):
            raise ValueError('File is not an OpenSCAD file')
            return None
        
        g = self.generate_geometry()
        print('Rendering to %s' % path)
        
        try:
            scad_render_to_file(g, filepath = path, file_header=f'$fn = {fn};')
        except Exception as e:
            print(e)
            return None
        
        return g
    
    def render_to_stl(self, path, fn):
        self.render_to_file(path + 'scad')
        raise NotImplementedError('Rendering to STL file has not been implemented yet.')
        #print('Rendering to %s' % path)
