# Assembly file for the Screw Roller
# Currently a mockup for architecture - jmloss 01/15/2020

# Import SolidPython
from solid import *
from solid.utils import *   # Not required, but the utils module is useful
                            # During optimization ( if needed ), change the * to a list of only the required functions

#from rsgl_parts import *

from rsgl_nut import *
from rsgl_screw import *
from rsgl_roller import *

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
dm = 10.0                                   # Decimeter (rarely used)
cm = 100.0                                  # Centimeter
m  = 1000.0                                 # Meter (for big bois)

# Imperial
inches = 25.4               

# ---- Render Modes ----
RENDER_ASM                  = 0b00000001
RENDER_SCREW                = 0b00000010
RENDER_NUT                  = 0b00000100
RENDER_ROLLER               = 0b00001000
RENDER_SPACER               = 0b00010000
RENDER_HOUSING              = 0b00100000
RENDER_GEAR                 = 0b01000000
RENDER_THREAD               = 0b10000000
RENDER_NONE                 = 0b00000000    # In Case of issues?
RENDER_ALL                  = 0b11111111

RENDER_COMPS                = RENDER_SCREW ^ RENDER_NUT ^ RENDER_ROLLER ^ RENDER_SPACER
RENDER_TESTS                = RENDER_HOUSING ^ RENDER_GEAR ^ RENDER_THREAD


# ---- Default Vaues ----
# All diameters for threads or gears is for the reference (or pitch) diameter  
# Compare to a Rexroth Planetary Screw Assembly
# D25 x P10 x S4 (Cannot verify if it is a 4 start or 5 start)

output_dir                  = "./output"    # Output directory

render_mode                 = RENDER_TESTS

SEGMENTS                    = 25            # Quality [10 - 100] WARNING: Do NOT go past 100, already takes a long time at 100

rsgl_central_screw_diameter = 25 * mm       # Diameter of central screw (Part 3)

rsgl_central_screw_lead     = 10 * mm       # Lead of central screw (Part 3)

rsgl_central_screw_starts   = 4             # Number of starts on central screw (Part 3)

rsgl_nut_housing            = None          # Default Nut Housing (once made... probably a cylindrical/hexagonal one)

rsgl_total_height           = 40 * mm

rsgl_central_screw_height   = 100 * mm      # Not critical for creation of the actual screw

rsgl_desired_num_rollers    = 30            # Some ridiculous number for testing

# ---- Render Paths ----

asm_path                    = "%s/%s" % (output_dir, "Assembly.scad")
screw_path                  = "%s/%s" % (output_dir, "Screw.scad")
nut_path                    = "%s/%s" % (output_dir, "Nut.scad")
roller_path                 = "%s/%s" % (output_dir, "Roller.scad")
spacer_path                 = "%s/%s" % (output_dir, "Spacer.scad")
housing_path                = "%s/%s" % (output_dir, "test_Housing.scad")
test_gears_path             = "%s/%s" % (output_dir, "test_Gears.scad")
test_threads_path           = "%s/%s" % (output_dir, "test_Threads.scad")

# Other Default values as needed

# ---- Parsing Argument ----

# ==== Caclulate Common Values ==== 
# Inner reference diameter of nut
rsgl_nut_inner_diameter     = (rsgl_central_screw_diameter * rsgl_central_screw_starts) / (rsgl_central_screw_starts - 2)
# Roller reference diameter
rsgl_roller_diameter        = rsgl_nut_inner_diameter / rsgl_central_screw_starts

rsgl_roller_center_distance = (rsgl_roller_diameter + rsgl_central_screw_diameter) / 2

rsgl_max_num_rollers        = math.floor((math.tau * rsgl_roller_center_distance) / (rsgl_roller_diameter * 1.05)) # This 1.05 can be a definable tolerance

rsgl_num_rollers            = min(rsgl_desired_num_rollers, rsgl_max_num_rollers)

# ==== Report all values ====
print('==========   Output Settings    ==========')
print('Render Assembly              : %s'          % bool(render_mode & RENDER_ASM))
print('Render Screw                 : %s'          % bool(render_mode & RENDER_SCREW))
print('Render Nut                   : %s'          % bool(render_mode & RENDER_NUT))
print('Render Roller                : %s'          % bool(render_mode & RENDER_ROLLER))
print('Render Spacer                : %s'          % bool(render_mode & RENDER_SPACER))
print('Render Test Housing          : %s'          % bool(render_mode & RENDER_HOUSING))
print('Render Test Gears            : %s'          % bool(render_mode & RENDER_GEAR))
print('Render Test Threads          : %s'          % bool(render_mode & RENDER_THREAD))
print('==========  Critical Settings   ==========')
print('Center Screw Diameter        = %fmm'        % rsgl_central_screw_diameter)
print('Central Screw Lead           = %fmm'        % rsgl_central_screw_lead)
print('Central Screw Starts         = %d starts'   % rsgl_central_screw_starts)
print('Nut housing                  = %s'          % str(rsgl_nut_housing))
print('==========    Design Settings   ==========')
print('Total assembly height        = %fmm'        % rsgl_total_height)
print('Central Screw height         = %fmm'        % rsgl_central_screw_height)
print('Desired Number of Rollers    = %d rollers'  % rsgl_desired_num_rollers)
print('Maximum Number of Rollers    = %d rollers'  % rsgl_max_num_rollers)
print('Set number of Rollers        = %d rollers'  % rsgl_num_rollers)
# Roller Bore Setting
# Outer Diameter
# Minimum Wall Thickness (Either this OR Outer Diameter)
#                         If Outer Diamter is set and valid, use that
#                         Else use Minimum Wall Thickness
print('==========  Internal Settings   ==========')
print('Nut Inner diameter           = %fmm'        % rsgl_nut_inner_diameter)
print('Roller Outer diameter        = %fmm'        % rsgl_roller_diameter)
print('Roller Placement diameter    = %fmm'        % rsgl_roller_center_distance)



#print('Parsing Arguments...')


nut_spec = None # RSGL_Nut(rsgl_nut_inner_diameter + 5, rsgl_nut_inner_diameter, rsgl_total_height, rsgl_nut_housing)

center_screw_spec = None
#RSGL_Screw(
#    rsgl_central_screw_diameter,
#    rsgl_central_screw_height,
#    RSGL_thread_spec(
#        pitch = rsgl_central_screw_lead / rsgl_central_screw_starts,
#        starts = rsgl_central_screw_starts)
#    )

roller_spec = None # RSGL_Roller(rsgl_roller_diameter, rsgl_total_height, None, None)

# ---- Rendering ----
print('========== Preparing SCAD Files ==========')

# Renders to the following files:
#   ./output/Nut.scad
#   ./output/Screw.scad         
#   ./output/Roller.scad
#   ./output/Spacer.scad
#   ./output/test_Gears.scad
#   ./output/test_Threads.scad
#   ./output/Assembly.scad

if bool(render_mode & RENDER_ASM):      # Make its own function to use so that we can keep this section cleaner
    print('Rendering Assembly to          %s'          % asm_path)
    
if bool(render_mode & RENDER_SCREW):
    print('Rendering Screw to             %s'          % screw_path)
    
    
if bool(render_mode & RENDER_NUT):
    print('Rendering Nut to               %s'          % nut_path)
    
if bool(render_mode & RENDER_ROLLER):
    print('Rendering Roller to            %s'          % roller_path)
    
if bool(render_mode & RENDER_SPACER):
    print('Rendering Spacer to            %s'          % spacer_path)
    
if bool(render_mode & RENDER_HOUSING):
    print('Rendering Test Housing to      %s'          % housing_path)
    
if bool(render_mode & RENDER_GEAR):
    print('Rendering Test Gears to        %s'          % test_gears_path)
    
if bool(render_mode & RENDER_THREAD):
    print('Rendering Test Threads to      %s'          % test_threads_path)
