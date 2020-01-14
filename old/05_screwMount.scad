// Screw Mount

include <03_rollScrew.scad>

d_mount_holes = 6;  // Mounting Hole Size

difference(){
    union(){
    for(i = [0:2]){
        rotate([0, 0, i * 180])
        translate([45, 0, 0])
        cube([90, 20, 0.3*(l_rollers_len + 2 * l_nut_ring_h)], center = true);
    }
    cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *1.3, h = (l_rollers_len + 2 * l_nut_ring_h) * 0.3, center = true);
}
cylinder(d = ((l_nut_wall + d_nut_ring_ref + 2.5 * m_nut_ring) / cos(30)) *1.2 + 0.2, h = (l_rollers_len + 2 * l_nut_ring_h) * 0.3, center = true);

translate([90 - d_mount_holes, 5, -0.15*(l_rollers_len + 2 * l_nut_ring_h)])
cylinder(d = d_mount_holes, h = 0.3*(l_rollers_len + 2 * l_nut_ring_h));

translate([80 - d_mount_holes, -5, -0.15*(l_rollers_len + 2 * l_nut_ring_h)])
cylinder(d = d_mount_holes, h = 0.3*(l_rollers_len + 2 * l_nut_ring_h));

translate([-90 + d_mount_holes, -5, -0.15*(l_rollers_len + 2 * l_nut_ring_h)])
cylinder(d = d_mount_holes, h = 0.3*(l_rollers_len + 2 * l_nut_ring_h));

translate([-80 + d_mount_holes, 5, -0.15*(l_rollers_len + 2 * l_nut_ring_h)])
cylinder(d = d_mount_holes, h = 0.3*(l_rollers_len + 2 * l_nut_ring_h));


}