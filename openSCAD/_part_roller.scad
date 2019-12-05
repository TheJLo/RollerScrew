include <_spec_pressScrew.scad>
include <libs/tsmthread4.scad>
use <libs/Getriebe.scad>

// Test
d_rollers_eff = 40;

d_nut_roller_ref = d_rollers_eff - 2 * m_nut_ring;       // Reference Diameter (one to use for meshing)
n_nut_roller_teeth= floor(d_nut_roller_ref / m_nut_ring) - 1;
d_roller_th_maj = d_nut_roller_ref + 0.649519 * l_rollers_pitch;        // Major Diameter (Overall outer dia)
t_roller_th_comp = 0;        // Roller Thread Diamater Comp
l_nut_gear_mesh_h = 5;
a_nut_gear_lead = 0;
a_nut_gear_pres = 20;

module roller_screw(){

    // Input Processing
   echo(l_rollers_pitch);

    union(){
        stirnrad (
            modul=m_nut_ring, 
            zahnzahl=n_nut_roller_teeth, 
            breite=l_nut_gear_mesh_h, 
            bohrung=0, 
            eingriffswinkel=a_nut_gear_pres, 
            schraegungswinkel=a_nut_gear_lead, 
            optimiert=false
        );

        translate([0, 0, 5])
        tsmthread(
            DMAJ=d_roller_th_maj + t_roller_th_comp,    // Major diameter
            L=l_rollers_len,                  // Length of thread in mm.  Accuracy depends on pitch.
            PITCH=l_rollers_pitch,            // Scale of the thread itself.
            PR=THREAD_UTS,                    // Thread profile, i.e. ACME, UTS, other
            STARTS=1,                         // Want a crazy 37-start thread?  You're crazy.  but I'll try.
            TAPER=0,                          // Adds an offset of [1,tan(TAPER)] per thread.
            STUB=0,                           // Extends a cylinder below the thread.  In pitch units.
            STUB_OFF=0                        // Reduces the diameter of stub.  In pitch units.
         );

        translate([0, 0, 5 + l_rollers_len])
        stirnrad (
            modul=m_nut_ring,
            zahnzahl=n_nut_roller_teeth, 
            breite=l_nut_gear_mesh_h, 
            bohrung=0, 
            eingriffswinkel=a_nut_gear_pres, 
            schraegungswinkel=a_nut_gear_lead, 
            optimiert=false
        );
        
        echo(d_nut_roller_ref - 2 * m_nut_ring)
        assert(d_nut_roller_ref - 2 * m_nut_ring <= d_roller_axels);
    
        translate([0, 0, ((l_rollers_len + 2 * (l_spacer_h + l_nut_ring_h))) / 2 - l_spacer_h])
        cylinder(d = d_roller_axels, h = (l_rollers_len + 2 * (l_spacer_h + l_nut_ring_h)), center=true);
    
    }
}

roller_screw();