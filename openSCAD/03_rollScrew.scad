/*//----------------------------------------//
Authors: Marcello Guadagno, Jacob Loss
Project: Cider press
Part:    03 Roller Screw
Rev:     A
Desc:    roller screw to drive center screw. 
         Driven by screw housing. 4X Aligned 
         radially about center screw.
//----------------------------------------//*/

include <01_pressScrew.scad>
use <libs/Getriebe.scad>

//----------------------------------------//
//          Input Paramaters              //
//----------------------------------------//

//====== Central Screw Parameters ====//
// Note: These are used to define the entire gear system
d_screw_eff     = 35;   // Effective Diameter
l_screw_lead    = 10;   // Screw Lead (Larger = Larger Threads)
n_screw_threads = 4;    // Screw Thread Starts >= 3 
                        // (Larger = Smaller Threads, Smaller Rollers)
l_screw_length  = 180;  // Screw Length

n_rollers       = 8;    // Number of Roller Screws
l_rollers_len   = 20;   // Length of Rollers
d_roller_axels  = 10;   // Diameter of Roller Axels
l_spacer_h      = 2.5;  // Roller Space Height

l_nut_ring_h    = 5;    // Height of Ring Gears
t_nut_ring_h    = 0.5;  // Toleance Adjust for Ring Gears

//----------------------------------------//
//         Derived Paramaters             //
//----------------------------------------//

// l_screw_pitch (Pitch Derived in Press Screw)

d_nut_eff       = (d_screw_eff * n_screw_threads) / (n_screw_threads - 2);
d_rollers_eff   = (d_nut_eff - d_screw_eff) / 2;
l_rollers_pitch = l_screw_lead / n_screw_threads;
l_nut_wall      = 5;    // Nut Wall thickness

m_nut_ring      = 1;
d_nut_ring_ref  = d_nut_eff - 2 * m_nut_ring;
n_nut_ring_teeth= floor(d_nut_ring_ref / m_nut_ring) - 2;

d_nut_roller_ref= d_rollers_eff - 2 * m_nut_ring;
n_nut_roller_teeth= floor(d_nut_roller_ref / m_nut_ring) - 1;

module thread_shell(){
difference(){
    translate([0, 0, l_rollers_len / 2])
    cylinder(d = l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring, h = l_rollers_len, center=true);

    tsmthread(DMAJ=d_nut_eff+$OD_COMP     // Major diameter
                , L=l_rollers_len,                 // Length of thread in mm.  Accuracy depends on pitch.
                , PITCH=l_screw_pitch,              // Scale of the thread itself.
                , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
                , STARTS=n_screw_threads,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
                , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
                , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
                , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
                );
}
}

module shell_workings(){
    union(){
        translate([0, 0, 5])
        thread_shell();
        translate([0, 0, 5 + l_rollers_len + t_nut_ring_h])
        hohlrad (modul=m_nut_ring, zahnzahl=n_nut_ring_teeth, breite=l_nut_ring_h - t_nut_ring_h, randbreite=l_nut_wall - 2.5 * m_nut_ring, eingriffswinkel=20, schraegungswinkel=0);
        hohlrad (modul=m_nut_ring, zahnzahl=n_nut_ring_teeth, breite=l_nut_ring_h - t_nut_ring_h, randbreite=l_nut_wall - 2.5 * m_nut_ring, eingriffswinkel=20, schraegungswinkel=0);
    }
}

module shell_housing(){
    translate([0, 0, (l_rollers_len + 2 * l_nut_ring_h) / 2])
    difference(){
        union(){
            translate([0, 0, -(l_rollers_len + 2 * l_nut_ring_h)/2 + 0.1*(l_rollers_len + 2 * l_nut_ring_h)/2])
            cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *1.2, h = 0.1*(l_rollers_len + 2 * l_nut_ring_h), center = true, $fn=6);
            cylinder(d = (l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30) , h = l_rollers_len + 2 * l_nut_ring_h, center = true, $fn=6);
        }
    cylinder(d = d_nut_ring_ref + 2.5 * m_nut_ring, h = l_rollers_len + 2 * l_nut_ring_h, center = true);
}}

module gear_teeth_support(){
difference(){   // Support for Gear Teeth
    hohlrad (modul=m_nut_ring, zahnzahl=n_nut_ring_teeth, breite=l_nut_ring_h - t_nut_ring_h, randbreite=l_nut_wall - 2.5 * m_nut_ring, eingriffswinkel=20, schraegungswinkel=0);
    difference(){
    cylinder(d = d_nut_ring_ref + 3 * m_nut_ring + l_nut_wall, h = l_rollers_len + 2 * l_nut_ring_h, center = true);
    cylinder(d = d_nut_ring_ref - 2 * m_nut_ring + 0.8, h = l_rollers_len + 2 * l_nut_ring_h, center = true);
}
}
}

module roller_screw(){

union(){
stirnrad (modul=m_nut_ring, zahnzahl=n_nut_roller_teeth, breite=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=false);

translate([0, 0, 5])
tsmthread(DMAJ=d_rollers_eff + $ID_COMP     // Major diameter
            , L=l_rollers_len,                 // Length of thread in mm.  Accuracy depends on pitch.
            , PITCH=l_rollers_pitch,              // Scale of the thread itself.
            , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
            , STARTS=1,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
            , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
            , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
            , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
            );

translate([0, 0, 5 + l_rollers_len])
stirnrad (modul=m_nut_ring, zahnzahl=n_nut_roller_teeth, breite=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=false);
echo(d_nut_roller_ref - 2 * m_nut_ring)
assert(d_nut_roller_ref - 2 * m_nut_ring <= d_roller_axels);
    
translate([0, 0, ((l_rollers_len + 2 * (l_spacer_h + l_nut_ring_h))) / 2 - l_spacer_h])
cylinder(d = d_roller_axels, h = (l_rollers_len + 2 * (l_spacer_h + l_nut_ring_h)), center=true);

/*
translate([0, 0, - l_spacer_h])
difference(){
stirnrad (modul=m_nut_ring, zahnzahl=n_nut_roller_teeth, breite=5, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=false);
cylinder(d = d_nut_roller_ref - 2 * m_nut_ring + 0.8, h = l_spacer_h, center = true);
}*/
}
}

module shell_test(){
union(){
shell_workings();
    /*
translate([0, 0, l_rollers_pitch])
gear_teeth_support();
translate([0, 0, 5 + l_rollers_len - l_rollers_pitch])
gear_teeth_support();*/
shell_housing();
}}



module spacer(){
    
echo(d_nut_roller_ref - 2 * m_nut_ring)
assert(d_nut_roller_ref - 2 * m_nut_ring <= d_roller_axels);
    
difference(){
cylinder(d = (d_nut_ring_ref - d_rollers_eff) + d_nut_roller_ref - 1 , h = l_spacer_h, center = true);
cylinder(d = ((d_nut_eff - d_rollers_eff) - (d_nut_roller_ref - 2 * m_nut_ring)) * 0.95, h = l_spacer_h, center = true);
for(i = [0:n_rollers]){
    let(inc = 360 / n_rollers)
    rotate([0, 0, i * inc])
    translate([((d_nut_eff - d_rollers_eff) / 2) * 0.95, 0, 0])
    cylinder(d = d_roller_axels + 0.2, h = l_rollers_len + 2 * (l_spacer_h + l_nut_ring_h), center=true);
}
}
}

echo(((d_nut_eff - d_rollers_eff) / 2)  * 0.95);
 
module roller_screw_asm(){
    
color("DarkBlue")
shell_test();


for(i = [0:n_rollers]){
    let(inc = 360 / n_rollers)
    rotate([0, 0, i * inc])
    translate([(d_nut_eff - d_rollers_eff) / 2, 0, 0])
    roller_screw();
}
color("Black")
spacer();
translate([0, 0, (l_rollers_len + 2 * l_nut_ring_h)])
color("Black")
spacer();
}

//roller_screw_asm();
spacer();
//roller_screw();
//shell_test();
/*
translate([40, 0, 0])

translate([-40, 0, 0])
spacer(); */