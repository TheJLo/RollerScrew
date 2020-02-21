from rsgl_parts import *
from rsgl_tools import *

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
        
        g += gears.stirnrad (modul=0.5, zahnzahl=30, breite=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=False);
        
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
    # For later - jmloss 01/17/2020 
