# Nut assembly

# Needs to use Python >=3.6 to work properly with imports

# Import the part class
from . import RSGL_Part

# Import Solid Python
from solid import *
from solid.utils import *  # Not required, but the utils module is useful

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
    
def test():
    print('Testing Nut Part')
    nut = RSGL_Nut(30, 25, 60, None)
    
    g = nut.render_to_file('test_output/Nut_Test.scad', 100)
    
    if g:
        print('Successfully Rendered')
    else:
        print('Failed to render to file')

# Debug
if __name__ == '__main__':
    test()
