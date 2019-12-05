
include <03_rollScrew.scad>

//translate([0, 0, -0.25*(l_rollers_len + 2 * l_nut_ring_h) / 2])
difference(){
cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *1.1, h = 0.25*(l_rollers_len + 2 * l_nut_ring_h), center = true, $fn=6);
cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *0.8, h = 0.25*(l_rollers_len + 2 * l_nut_ring_h), center = true, $fn=6);
translate([0, 0, 0.25*(l_rollers_len + 2 * l_nut_ring_h)/2])
cylinder(d= (d_nut_ring_ref - d_rollers_eff) + d_nut_roller_ref + 0.5, h=0.25*(l_rollers_len + 2 * l_nut_ring_h), center=true);
}

//spacer();