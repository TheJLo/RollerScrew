/*/-------------------------------------//
        Roller Screw Assembly Script
//--------------------------------------//
Authors:        Marcello Guadagno, Jacob Loss
Project:        Roller Screw
Script Type:    Assembly File
Revision:       A
Date:           01/13/2020
Description:    Assembly of complete gears system. Includes rendering of 
                complete assembly as well as printable runs of the components.
//-------------------------------------/*/

// Some Instructions for how to change specs
// Paths to any references (contained in ./docs)

/*/-------------------------------------//
                Includes
//-------------------------------------/*/
include <MCAD/units.scad>

include <parts/rsgl_1_shell/rsgl_1_shell.scad>
include <parts/rsgl_2_roller/rsgl_2_roller.scad>
include <parts/rsgl_3_screw/rsgl_3_screw.scad>

/*/-------------------------------------//
                Constants
//--------------------------------------/*/
tau = 6.2831853071795864;

/*/-------------------------------------//
                Parameters (Temporary)
//--------------------------------------//
Parameters Classes:
    Part                -  Use the prefix 'p<n>_'
    where <n> is the part reference number.
    | Part parameters are used by a part and can be determined by
    | calculations on the System parameters. These can exist in other files
    | but actions on the should only be used within the part files. 
    | Other files should only take the parameters and pass them to the part
    | modules as necessary. If a part parameter is used in an action when it
    | is not in the part file, than it is actually a system parameter.
    System              - Use the prefix 'rsgl' (Roller-Screw-Guadagno-Loss)
    | These parameters are used by the assembly or parts to determine their
    | local parameters as needed. These should be put into a "Spec" file 
    | to keep centralized (For future maybe? - jmloss 01/13/2020)
    Temporary/Internal  - Use the prefix '_'
    | Temporary/Internal Parameters are used in cases where a paramter is
    | only going to be used within one file and does not classify as a
    | typical paramter. Variable-like parameters, such as loop coutners, 
    | would fall under this classification.
    
(This should eventually fall into a coding standards document 
    - jmloss 01/13/2020)

(These probably aren't very clear. Need to be reworked
    - jmloss 01/13/2020)

Notes:  (Most of this... if not all, should end up in the manual Eventually 
            - jmloss 01/13/2020)

    == Diameters ==
    All diameters related to gears/threads are reference diameters unless 
    otherwise specified.
    
    == Units ==
    If a number does not have a unit on it, it is in mm. All numbers should
    be labeled with units with a multipication sign and the unit suffix.
    These parameters are scaled if the unit is used so can be used directly
    without further conversions.
    
    Calculations should not have units attached to them unless purposely
    scaling that entire calculation. 
//-------------------------------------/*/

rsgl_lead = 10 * mm;                // The Lead of the screw system.
                                    // | Lead is the distance the center  
                                    // | screw traverses per full rotation 
                                    // | of the center screw.
                    
rsgl_center_diameter = 20 * mm;     // Reference Diameter of the center 
                                    // screw.
                                    // | The Interface (Reference) diameter
                                    // | of the center screw (Part 3).
                                
rsgl_center_thread_start = 4;       // Number of center screw thread starts.
                                    // | The number of thread starts, along
                                    // | with the lead, determines the 
                                    // | pitch of the center screw and 


    
rsgl_shell_inner_diameter =         // Reference inner diameter for shell.
     (rsgl_center_diameter          // | Inner reference diameter carved
    * rsgl_center_thread_start)     // | Into the shell. Shell has truncated
    /(rsgl_center_thread_start - 2);// | Thread crests for tolerance.           

rsgl_roller_diameter =              // Reference Diameter of rollers.
      rsgl_shell_inner_diameter     // | The diameter of the planetary
    / rsgl_center_thread_start;     // | rollers (Part 2) inside the shell.

rsgl_roller_screw_height = 40 * mm; // Height of roller screw assembly.
                                    // | Total height of the assembly.
                                    // | Proportions of the individual
                                    // | components is determined by 
                                    // | the other values.
                                    
rsgl_number_rollers_desired = 30;   // Number of rollers wanted in design.
                                    // | If this number is larger than 
                                    // | rsgl_number_rollers_max, than 
                                    // | it will be reassigned to be the
                                    // | calculated max amount of rollers.

rsgl_roller_center_distance =       // Distance rollers are placed from 
    ( rsgl_roller_diameter          // center line.
    + rsgl_center_diameter) 
    / 2;
    
rsgl_number_rollers_max = floor(    // Calculated max number of rollers.
    (tau                            // | Value calculated from effective
    * rsgl_roller_center_distance)  // | diameter with some wiggle
    / (rsgl_roller_diameter * 1.05) // | set to 5% of the effective
    );                              // | diameter. 
            
p3_center_screw_height = 100 * mm;  // Center screw height.
                                    // | Not strickly necessary for the 
                                    // | assembly so is not a system 
                                    // | parameter. Someone could easily
                                    // | create their own central custom
                                    // | center screw which can interface
                                    // | without having to use this script.

// ==== This is all playing around with assembly ====
// This should be a child drill into a component which the user defines. 
// ie. the interface of the overall screw should be user determined.
color("Cyan")
shell(
    outer_dia = rsgl_shell_inner_diameter + 10, 
    ref_dia = rsgl_shell_inner_diameter,
    height = rsgl_roller_screw_height);

$fn=100;

// Place Center Screw
center_screw(ref_dia = rsgl_center_diameter, height = p3_center_screw_height);

// Place Rollers around Center Screw

// Ensure proper number of rollers
_num_rollers = rsgl_number_rollers_desired > rsgl_number_rollers_max ? 
                rsgl_number_rollers_max :
                rsgl_number_rollers_desired;
_roller_inc = 360 / _num_rollers;
for(_angle = [0 : _roller_inc : 360]){
    rotate([0, 0, _angle])
    translate([rsgl_roller_center_distance, 0, 0])
    color("DarkGreen")
    rotate([0, 0, -_angle]) // Might be necessary for the print in place 
                            // to align threads...
                            // - jmloss 01/13/2020
    roller(ref_dia = rsgl_roller_diameter, height = rsgl_roller_screw_height);
}
