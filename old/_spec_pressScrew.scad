//----------------------------------------//
//      Press Screw Specification         //
//----------------------------------------//

// This file defines default values for every
// aspect of the Press Screw. The values here 
// should not be changed directly but should 
// be overrided within the assmebly file.
// Please open the file:
//      openSCAD/00_pressAssembly.scad
// For more details.

// This file also contains a number of 
// error checking on each parameter

//====== Central Screw Parameters ======//
// Note: These are used to define the entire gear system
d_screw_eff     = 35;   // Effective Diameter
l_screw_lead    = 10;   // Screw Lead (Larger = Larger Threads)
n_screw_threads = 4;    // Screw Thread Starts >= 3 
                        // (Larger = Smaller Threads, Smaller Rollers)
l_screw_length  = 180;  // Screw Length

    //==== Cap Parameters ====//
    d_cap_outer     = 70;   // Outer Diameter of Cap
    d_cap_cut_temp  = 30;   // Diamater of Cut Circles
    l_cap_thickness = 10;   // Thickness of cap
    n_cap_cuts      = 4;    // Number of Arms
    d_angle_change  =       // Degrees between each cut circle
                      360 / n_cap_cuts;

    d_cap_limit     =       // Maximum Limit of d_cap_cut_temp
                      ((d_cap_outer / 2) * sin(d_angle_change)) / 
                      sin((180 - d_angle_change) / 2);

//====== Roller Parameters ======//
n_rollers       = 8;    // Number of Roller Screws
l_rollers_len   = 20;   // Length of Rollers
d_roller_axels  = 10;   // Diameter of Roller Axels

//====== Spacer Parameters =====//
l_spacer_h      = 2.5;  // Roller Space Height

//====== Ring Gear Parameters ======//
l_nut_ring_h    = 5;    // Height of Ring Gears
t_nut_ring_h    = 0.5;  // Toleance Adjust for Ring Gears
m_nut_ring      = 2;

//----------------------------------------//
//         Derived Paramaters             //
//----------------------------------------//

l_screw_pitch   = l_screw_lead / n_screw_threads;   // Thread Pitch of screw system

d_nut_eff       = (d_screw_eff * n_screw_threads) / (n_screw_threads - 2);
d_rollers_eff   = (d_nut_eff - d_screw_eff) / 2;
l_rollers_pitch = l_screw_lead / n_screw_threads;
l_nut_wall      = 5;    // Nut Wall thickness


d_nut_ring_ref  = d_nut_eff - 2 * m_nut_ring;
n_nut_ring_teeth= floor(d_nut_ring_ref / m_nut_ring) - 2;

d_nut_roller_ref= d_rollers_eff - 2 * m_nut_ring;
n_nut_roller_teeth= floor(d_nut_roller_ref / m_nut_ring) - 1;
