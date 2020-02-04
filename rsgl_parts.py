# Generic Part Class

# Import SolidPython
from solid import *
from solid.utils import *

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
        print('Rendering to %s' % path)
        
# Putting all other extension classes in here because holy crap does importing stuff suck

# The outer nut assembly* containing the rollers
# Forms the raceway for the planetary rollers and acts as the primary body of the screw
# Is, programmically, the most complex part due to the custom housing
# This class forms the actual raceway into the housing provided
class RSGL_Nut(RSGL_Part):
    
    # Constructor
    # Pass in the needed values here
    def __init__(self, outer_diameter, inner_ref_diameter, height, housing):
        print('Constructing specification for the Nut')
        self.__outer_diameter = outer_diameter
        self.__inner_ref_diameter = inner_ref_diameter
        self.__height = height
        self.__housing = housing # This is going to be a specific RSGL_Part class
                                 # | ie. an RSGL_Nut_Housing class which specifies 
                                 # | the needed methods and variables in a housing class
                                 # | This allows the nut to be generated with custom housings
    
    # Override generate_geometry()
    def generate_geometry(self):
        # - and -= is a difference operator
        g =  cylinder(d = self.__outer_diameter, h = self.__height, center=True)
        g -= cylinder(d = self.__inner_ref_diameter, h = self.__height, center=True)
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
        # For later - jmloss 01/17/2020
        
# Planetary Rollers
# Will consist of the threads, gears, and stubs
class RSGL_Roller(RSGL_Part):
    
    # Constructor
    def __init__(self, ref_diameter, height, thread_spec, gear_spec):
        self.__ref_diameter = ref_diameter
        self.__height       = height
        self.__thread_spec  = thread_spec # Object containing information about the threads
        self.__gear_spec    = gear_spec   # Object containing information about the gears
        
    # Override generate_geometry()
    def generate_geometry(self):
        # - and -= is a difference operator
        g =  cylinder(d = self.__ref_diameter, h = self.__height, center=True)
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
    # For later - jmloss 01/17/2020
    
# Planetary Rollers
# Will consist of the threads, gears, and stubs
class RSGL_Screw(RSGL_Part):
    
    # Constructor
    def __init__(self, ref_diameter, height, thread_spec):
        self.__ref_diameter = ref_diameter
        self.__height       = height
        self.__thread_spec  = thread_spec # Object containing information about the threads
        
    # Override generate_geometry()
    def generate_geometry(self):
        g =  cylinder(d = self.__ref_diameter, h = self.__height, center=True)
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
    # For later - jmloss 01/17/2020
