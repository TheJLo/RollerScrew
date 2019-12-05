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
    translate([0, 0, (l_rollers_len - 10) / 2])
    difference(){
        union(){
            
            cylinder(d = (l_nut_wall + d_screw_eff ) / cos(30), h = l_rollers_len - 10, center = true, $fn=6);
        }
    cylinder(d = d_screw_eff, h = l_rollers_len, center = true);
}}

difference(){
    
union(){
translate([0, 0, -3])
cylinder(d = 72, h = 6, center = true);
thread_shell()
shell_housing();
}
translate([0, 0, -5])
{
rotate([0, 0, 30])
for(i = [0:6]){
    inc_a = 360 / 6;
    rotate([0, 0, inc_a * i])
    translate([23, 0, 0])
    cylinder(d = 4, h = 10, center = true);
}
rotate([0, 0, 0])
for(i = [0:6]){
    inc_a = 360 / 6;
    rotate([0, 0, inc_a * i])
    translate([26, 0, 0])
    cylinder(d = 4, h = 10, center = true);
}

rotate([0, 0, 15])
for(i = [0:6]){
    inc_a = 360 / 6;
    rotate([0, 0, inc_a * i])
    translate([30, 0, 0])
    cylinder(d = 4, h = 10, center = true);
}

rotate([0, 0, -15])
for(i = [0:6]){
    inc_a = 360 / 6;
    rotate([0, 0, inc_a * i])
    translate([30, 0, 0])
    cylinder(d = 4, h = 10, center = true);
}}
}
