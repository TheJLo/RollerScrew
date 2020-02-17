#!/usr/bin/env python3

# Generic Part Class

# Import SolidPython
from solid import *
from solid.utils import *

# .scad library folder
lib = "./libs"

# .scad files
thread_file = "thread.scad"
gear_file   = "Getriebe.scad"

threads = import_scad('./libs/threads.scad')
gears   = import_scad('./libs/Getriebe.scad')

class RSGL_thread_spec:
    # https://dkprojects.net/openscad-threads/
    def __init__(self, pitch, starts):
        self._pitch = pitch
        self._starts = starts
        print('Creating Thread Spec')

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

class RSGL_Thread(RSGL_Part):
    __fuck_you = 3
    def __init__(self, ref_dia = 10):
        print('FUCK YOU')
        

    #def __init__(self, ref_diameter, lead, starts, length):
        
        #self.__ref_dia      = ref_diameter
        #self.__lead         = lead
        #self.__starts       = starts
        #self.__length       = length
        #self.__taper        = taper
        #self.__ends         = end_taper
        #self.__lead_angle   = lead_angle
        #self.__groove       = groove

    #def generate_geometry(self):
    #    return self.generate_geometry(False)

    #def generate_geometry(self, internal):
     #   g = metric_thread(
      #      diameter    = self.__ref_diameter, 
       #     pitch       = self.__lead / self.__starts,
        #    length      = self.__length,
         #   n_starts    = self.__starts,
          #  taper       = self.__taper,
           # leadin      = self.__ends,
           # angle       = self.__lead_angle,
           # groove      = self.__groove,
           # internal    = internal)
        #return g

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
        g = threads.metric_thread(
                diameter = self.__ref_diameter,
                pitch    = self.__thread_spec._pitch,
                length   = self.__height,
                n_starts = self.__thread_spec._starts
                )
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
    # For later - jmloss 01/17/2020
