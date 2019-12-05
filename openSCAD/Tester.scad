include <03_rollScrew.scad>

//====== Central Screw Parameters ====//
// Note: These are used to define the entire gear system
d_screw_eff     = 10;   // Effective Diameter
l_screw_lead    = 20;   // Screw Lead (Larger = Larger Threads)
n_screw_threads = 4;    // Screw Thread Starts >= 3 
                        // (Larger = Smaller Threads, Smaller Rollers)
l_screw_length  = 180;  // Screw Length

n_rollers       = 8;    // Number of Roller Screws
l_rollers_len   = 20;   // Length of Rollers
d_roller_axels  = 10;   // Diameter of Roller Axels
l_spacer_h      = 2.5;  // Roller Space Height

l_nut_ring_h    = 5;    // Height of Ring Gears
t_nut_ring_h    = 0.5;  // Toleance Adjust for Ring Gears