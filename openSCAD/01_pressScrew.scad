/*//-------------------------------------//
Authors: Marcello Guadagno, Jacob Loss
Project: Cider press
Part:    01 Press Screw
Rev:     A
Desc:    Center press screw driven by 
         roller screws
//-------------------------------------//*/

//include
//use <Getriebe.scad>; //german gear lib
//translate([0,0,0]) //move screw to see axis tick marks
//schnecke(modul=2.3, gangzahl=1, laenge=50, bohrung=0, eingriffswinkel = 30, steigungswinkel=5, zusammen_gebaut=true);

//test part added on for stable printing
//translate([0,0,50]) cube([35,35,5], center = true);

include <libs/tsmthread4.scad>
use <libs/Sprocket_Generator.scad>

//--------------------------------------//
//              Threads                 //
//--------------------------------------//
d_screw_eff     = 35;   // Effective Diameter
l_screw_lead    = 20;   // Screw Lead
n_screw_threads = 3;    // Screw Thread Starts
l_screw_length  = 180;  // Screw Length

l_screw_pitch   = l_screw_lead / n_screw_threads;

//--------------------------------------//
//              Top Cap                 //
//--------------------------------------//
d_cap_outer     = 70;   // Outer Diameter of Cap
d_cap_cut_temp  = 30;   // Diamater of Cut Circles
l_cap_thickness = 10;   // Thickness of cap
n_cap_cuts      = 4;    // Number of Arms
d_angle_change  =       // Degrees between each cut circle
                360 / n_cap_cuts;

d_cap_limit     =       // Maximum Limit of d_cap_cut_temp
    ((d_cap_outer / 2) * sin(d_angle_change)) 
                / 
    sin((180 - d_angle_change) / 2);

echo(d_cap_limit);

assert(d_cap_cut_temp <= d_cap_limit);

module cap(){
    difference(){
        cylinder(d=d_cap_outer, h=l_cap_thickness, center=true);
        for(i = [0:n_cap_cuts]){
            rotate([0, 0, i * d_angle_change])
            translate([d_cap_outer/2, 0, 0])
            cylinder(d=d_cap_cut_temp, h=l_cap_thickness, center=true);
        }
    }
}

module screw(){
    difference(){
        tsmthread(DMAJ=d_screw_eff + $ID_COMP    // Major diameter
            , L=l_screw_length,                 // Length of thread in mm.  Accuracy depends on pitch.
            , PITCH=l_screw_pitch,              // Scale of the thread itself.
            , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
            , STARTS=n_screw_threads,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
            , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
            , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
            , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
            );
    
        translate([0, 0, l_screw_pitch/2])
        cylinder(d=6, h=l_screw_pitch, center=true);
    }
}

module press_screw(){
screw();
translate([0, 0, l_screw_length + l_cap_thickness/2])
cap();
}
//sprocket(teeth=4, roller=20, pitch=40, thickness=10, tolerance=0.2);