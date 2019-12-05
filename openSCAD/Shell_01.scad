include <01_pressScrew.scad>

include <_spec_pressScrew.scad>
include <libs/tsmthread4.scad>
use <libs/Getriebe.scad>

module thread_shell(){
difference(){
    children();
    
    //translate([0, 0, l_rollers_len / 2])
    //cylinder(d = l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring, h = l_rollers_len, center=true);

    tsmthread(DMAJ=d_screw_eff+$ID_COMP + 1     // Major diameter
                , L=l_rollers_len + 15,                 // Length of thread in mm.  Accuracy depends on pitch.
                , PITCH=l_screw_pitch,              // Scale of the thread itself.
                , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
                , STARTS=n_screw_threads,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
                , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
                , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
                , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
                );
}
}

module shell_housing(){
    translate([0, 0, l_rollers_len / 2 + 14])
    difference(){
        union(){
            translate([0, 0, -l_rollers_len / 2 - 7])
            cylinder(d = 90 * 1.2, h = 14, center = true, $fn=6);
            cylinder(d = (l_nut_wall + d_screw_eff ) / cos(30) , h = l_rollers_len, center = true, $fn=6);
        }
    cylinder(d = d_screw_eff, h = l_rollers_len, center = true);
}}

difference(){
union(){
thread_shell()
difference(){
shell_housing();
    tsmthread(DMAJ=90+$ID_COMP+1     // Major diameter
                , L=12,                 // Length of thread in mm.  Accuracy depends on pitch.
                , PITCH=5.3,              // Scale of the thread itself.
                , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
                , STARTS=1,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
                , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
                , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
                , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
                );
    
translate([-32, 0, 20])
cylinder(d = 8, h = 20, center = true);
}
//press_screw();
translate([-32, 0, 24])
spiget();
}
//translate([50, 0, 0])
//cube([100, 100, 100], center=true);
}

module spiget(){
rotate([0, -30, 0])
difference(){
rotate([0, 30, 0])
difference(){
cylinder(d = 10, h = 20, center = true);
cylinder(d = 8, h = 20, center = true);
}
translate([50, 0, 0])
cube([100, 100, 100], center = true);
}}