// Roller Screw Module

// Requires MCAD to be installed for usage. Follow instructions for installation in Manual
include <MCAD/units.scad>   // Allows units to be used for specification of values

// Install Instructions for Getriebe (and all OpenSCAD libs) included in Manual
// Linux: Copy file to /usr/share/openscad/libraries
// Must have unique name in ssdfsdfaf
include <tsmthread4.scad>
use <Getriebe.scad>

module roller_test(ref_dia = 10, height = 20, lead = 10, starts = 5){

    //union(){
    cylinder(d = ref_dia, h = height, center = true);
    // (Temporary to test some assembly stuff - jmloss 01/13/2020)
    //cube([2 * ref_dia, ref_dia, ref_dia], center = true); 
    //}
}

// Function to get proper major diameter from reference diamters
// Needed for ALL Thread profiles
// May want to put these in a utility file (Jmloss - 01/15/2020)
function getUTSMajDia(ref_dia, pitch) = ref_dia + 0.649519 * pitch;

module roller(
    ref_dia=10,                         // Reference Dia for threads
    height = 20,                        // Detemines the height of the entire roller
    lead = 10,                          // Used in calculations
    starts = 5,                         // Used in calculations
    stud_dia = 8,                       // Needs to be smaller than Minor Dia
    mod = 1,                            // Module for timing gears ( from asm )
    thread_std = 0,                     // Thread Standard
                                        // | 0 = UTS
                                        // | 1 = ACME
                                        // | 2 = TRAP
                                        // | 3 = NH
                                        // | 4 = Custom
    thread_prof = THREAD_UTS,           // Thread Profile
                                        // | Only used for custom
                                        // | Reference tsmthread4.scad for profile creation
    thread_maj_func = getUTSMajDia      // FACK
    ){
    
    major_dia = 
        
    // Roller Gear Cap 
    tsmthread(DMAJ=10     // Major diameter
            , L=10,                 // Length of thread in mm.  Accuracy depends on pitch.
            , PITCH=1,              // Scale of the thread itself.
            , PR=THREAD_UTS                     // Thread profile, i.e. ACME, UTS, other
            , STARTS=1,           // Want a crazy 37-start thread?  You're crazy.  but I'll try.
            , TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
            , STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
            , STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
            );
    
    
    
}

module roller_cap(

    ){
    
}

roller();