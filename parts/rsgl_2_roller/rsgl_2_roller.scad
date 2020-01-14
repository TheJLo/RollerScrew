// Roller Screw Module

// Requires MCAD to be installed for usage. Follow instructions for installation in Manual
include <MCAD/units.scad>   // Allows units to be used for specification of values

// Install Instructions for Getriebe (and all OpenSCAD libs) included in Manual
// Linux: Copy file to /usr/share/openscad/libraries
// Must have unique name in ssdfsdfaf
use <Getriebe.scad>

module roller(ref_dia = 10, height = 20, lead = 10, starts = 5){

    //union(){
    cylinder(d = ref_dia, h = height, center = true);
    // (Temporary to test some assembly stuff - jmloss 01/13/2020)
    //cube([2 * ref_dia, ref_dia, ref_dia], center = true); 
    //}
}