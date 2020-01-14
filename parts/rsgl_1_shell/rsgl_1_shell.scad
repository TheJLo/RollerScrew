// Shell Module

// Requires MCAD to be installed for usage. Follow instructions for installation in Manual
include <MCAD/units.scad>   // Allows units to be used for specification of values

module shell(
    outer_dia = 30, 
    ref_dia = 25,
    height = 60, 
    lead = 10, 
    starts = 5){
        
    difference(){
        cylinder(d = outer_dia, h = height, center = true);
        cylinder(d = ref_dia, h = height, center = true);
    }
}