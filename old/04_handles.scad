// Handle Bars

include <03_rollScrew.scad>

difference(){
    
    minkowski(){
    union(){
    cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *1.1, h = 0.25*(l_rollers_len + 2 * l_nut_ring_h), center = true, $fn=6);
    for(i = [0:4]){
        rotate([0, 0, i * 90])
        translate([35, 0, 0])
        cube([90, 20, 0.25*(l_rollers_len + 2 * l_nut_ring_h)], center = true);
    }
    }
        cylinder(d = 20, h = 0.5*(l_rollers_len + 2 * l_nut_ring_h), center=true);
        
    }
    cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) + 0.2, h = (l_rollers_len + 2 * l_nut_ring_h), center = true, $fn=6);
}

