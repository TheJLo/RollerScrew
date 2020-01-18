# Roller assembly

# Import the part class
from parts import RSGL_Part

# Import Solid Python
from solid import *
from solid.utils import *  # Not required, but the utils module is useful

# Planetary Rollers
# Will consist of the threads, gears, and stubs
class RSGL_Screw(RSGL_Part):
    
    # Constructor
    def __init__(self, ref_diameter, height, thread_spec):
        self.__ref_diameter = ref_diameter
        self.__height       = height
        self.__thread_spec  = thread_spec # Object containing information about the threads
        
    # Override generate_geometry()
    def generate_geometry(self, fn):
        g =  cylinder(d = self.__ref_diameter, h = self.__height, center=True)
        return g
    
    # Getter and Setter Methods
    # Getter values can be used on private, calculated values
    # Setters can only be used on specification (constant) values
    # For later - jmloss 01/17/2020
    
def test():
    print('Testing Roller Part')
    nut = RSGL_Screw(15, 50, None)
    
    g = nut.render_to_file('test_output/Screw_Test.scad', 100)
    
    if g:
        print('Successfully Rendered')
    else:
        print('Failed to render to file')

# Debug
if __name__ == '__main__':
    test()

