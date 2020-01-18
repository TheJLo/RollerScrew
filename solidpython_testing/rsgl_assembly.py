# Assembly file for the Screw Roller
# Currently a mockup for architecture - jmloss 01/15/2020

# Import SolidPython
from solid import *
from solid.utils import *   # Not required, but the utils module is useful
                            # During optimization ( if needed ), change the * to a list of only the required functions

from parts import *

import math

# Main Running Program

# ---- Argument Setup (POSIX/Linux) ----
# May want to move this to a 'builder' script - jmloss 01/16/2020

# Output OpenSCAD File        (required to run, prompt if not given)

# Output STL File             (optional, maybe prompt if not given?)
 
# Use file defaults flag      (optional, tells program to use default values rather than prompt)
#                              | All values with a '*' next to them will use defaults if this flag is present
#                              | During operation, program will report that the default was used and its value

# Nut Housing File*           (optional w/ default, do not prompt if not given.)
#                              | Either .scad or .py
#                              | Parse which then is either a class or .scad file
#                              | Both should have standard functions/values 
#                              | Is it possible to use the .py class? (I think so? - jmloss 01/15/2020)

# Central Screw Diameter*     (required to run, prompt if not given)

# Central Screw Lead*         (required to run, prompt if not given)

# Central Screw Starts*       (required to run, prompt if not given)

# Other misc. values as needed

# ---- Conversion Factors ----
# Everything must be converted into mm for usage by OpenSCAD
# | These values allow conversion into mm for input parameters
# | Include units on every constant like so: 'n * mm' where n is the value and mm is your unit choice

# Metric
mm = 1.0                                    # Default Unit for OpenSCAD
cm = 10.0                                   # Centimeter
dm = 100.0                                  # Decimeter (rarely used)
m  = 1000.0                                 # Meter (for big bois)

# Imperial
inches = 25.4               

# ---- Default Vaues ----
# All diameters for threads or gears is for the reference (or pitch) diameter  
# Compare to a Rexroth Planetary Screw Assembly
# D25 x P10 x S4 (Cannot verify if it is a 4 start or 5 start)
# These should be in a class or struct or something - jmloss 01/16/2020

rsgl_central_screw_diameter = 25 * mm       # Diameter of central screw (Part 3)
print('Center Screw Diameter set to %fmm' % rsgl_central_screw_diameter)

rsgl_central_screw_lead     = 10 * mm       # Lead of central screw (Part 3)
print('Central Screw Lead set to %fmm' % rsgl_central_screw_lead)

rsgl_central_screw_starts   = 4             # Number of starts on central screw (Part 3)
print('Central Screw Starts set to %d starts' % rsgl_central_screw_starts)

rsgl_nut_housing            = None          # Default Nut Housing (once made... probably a cylindrical/hexagonal one)
print('Nut housing set to %s' % str(rsgl_nut_housing))

rsgl_total_height           = 40 * mm
print('Total assembly height set to %fmm' % rsgl_total_height)

# Other Default values as needed

# Caclulate Common Values 

# Inner reference diameter of nut
rsgl_nut_inner_diameter      = (rsgl_central_screw_diameter * rsgl_central_screw_starts) / (rsgl_central_screw_starts - 2)
print('Nut Inner diameter set to %fmm' % rsgl_nut_inner_diameter)

# Roller reference diameter
rsgl_roller_diameter         = rsgl_nut_inner_diameter / rsgl_central_screw_starts
print('Roller Outer diameter set to %fmm' % rsgl_roller_diameter)

rsgl_roller_center_distance = (rsgl_roller_diameter + rsgl_central_screw_diameter) / 2
print('Roller Placement distance from center set to %fmm' % rsgl_roller_center_distance)

rsgl_max_num_rollers        = math.floor((math.tau * rsgl_roller_center_distance) / (rsgl_roller_diameter * 1.05)) # This 1.05 can be a definable tolerance
print('Maximum Number of Rollers calculated to be %d rollers' % rsgl_max_num_rollers)
                        
rsgl_central_screw_height   = 100 * mm      # Not critical for creation of the actual screw
print('Central Screw height set to %fmm' % rsgl_central_screw_height)

rsgl_desired_num_rollers    = 30            # Some ridiculous number for testing

# ---- Parsing Argument ----
#print('Parsing Arguments...')
SEGMENTS = 100

nut = RSGL_Nut(rsgl_nut_inner_diameter + 5, rsgl_nut_inner_diameter, rsgl_total_height, rsgl_nut_housing)






