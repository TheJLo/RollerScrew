from rsgl_parts import *

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
