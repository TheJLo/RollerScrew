from rsgl_parts import *

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
 
