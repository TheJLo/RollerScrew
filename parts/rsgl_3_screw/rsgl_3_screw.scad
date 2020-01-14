// Center Screw Module

module center_screw(ref_dia = 15, height = 50, lead = 10, starts = 5){
    
    cylinder(d = ref_dia, h = height, center = true);
    
}