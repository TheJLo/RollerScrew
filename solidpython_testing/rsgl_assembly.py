# Assembly file for the Screw Roller
# Currently a mockup for architecture - jmloss 01/15/2020

# Main Running Program

# ---- Argument Setup (POSIX/Linux) ----

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
mm = 1                                      # Default Unit for OpenSCAD
cm = 10                                     # Centimeter
dm = 100                                    # Decimeter (rarely used)
m  = 1000                                   # Meter (for big bois)

# Imperial
inches = 25.4               

# ---- Default Vaues ----
# Compare to a Rexroth Planetary Screw Assembly
# D25 x P10 x S5

rsgl_central_screw_diameter = 25 * mm       # Diameter of central screw (Part 3)

rsgl_central_screw_lead     = 10 * mm       # Lead of central screw (Part 3)

rsgl_central_screw_starts   = 5             # Number of starts on central screw (Part 3)

rsgl_nut_housing            = None          # Default Nut Housing (once made... probably a cylindrical/hexagonal one)

# Other Default values as needed

# ---- Parsing Argument ----

