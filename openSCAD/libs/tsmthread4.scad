/**
 *  TSM Generic Thread Generator 0.0.4, Tyler Montbriand, 2019
 *
 * Fast and flexible threaded profile generator producing
 * frugal and consistent meshes.  It can use arbitrary
 * profiles, i.e. UTS or ACME, and can do NPT-style
 * tapering.
 *
 * Public functions:
 * tsmthread(DMAJ, L, PITCH, PR, STARTS, POINTS, OFF, TAPER);
 *      Generates an arbitrary thread.
 *      DMAJ    diameter.  Threads all cut below this diameter.
 *      L       Length.
 *      PITCH   Distance between threads.
 *      PR      Point profile.
 *                  THREAD_UTS     All normal screws.
 *                  THREAD_ACME    ACME leadscrews.
 *                  THREAD_TRAP    Metric leadscrews
 *                  THREAD_NH      North American Garden Hose
 *                  ...or any other profile following the form
 *                      [ [x1,y1], ..., [xn,yn] ] xn+1 > xn, 0 <= y <= 1
 *                      Both X and Y in units of pitch.
 *      STARTS      >1 are multi-start threads, like some leadscrews or bottles
 *      OFF         Small increase or decrease to radius for tolerances
 *      TAPER       Adds offset of [1,tan(TAPER)] per thread.  This tapers
 *                  in a manner which preserves pitch and pitch depth.  Thread
 *                  angles change but can be compensated for.  See prof_npt()
 *                  and add_npt() and visual_test() for how that was done.
 *
 * thread_npt(DMAJ,L,PITCH,POINTS,OFF);
 *      Generates an NPT thread of 1 degree 47 second taper.
 *
 * X=prof(A,MIN,MAX)
 *      Generates a truncated thread profile.  A is angle in degrees, 
 *      MIN and MAX are positive numbers denoting distance above and
 *      below centerline in pitch units.  i.e. prof(29,0.25, 0.25) is ACME.
 *
 * comp_thread(DMAJ=11, L=20, PITCH=2, A=30, H1=0.5/2, H2=0.5/2, STARTS=1, in=false)
 *      Generates a thread profile with teeth thinned an amount configurable by $PE.
 *      DMAJ, L, PITCH, STARTS all as for tsmthread.
 *      A, H1, H2   See prof().
 */

//print_test();       /* Generate some objects to test against things I have */
//print_acme();       /* Print some leadscrew flanges */
//print_npt();        /* Generate some objects with North-American Pipe Threads */
//visual_test();      /* Look for any glaring errors and compare to other people's STL's */
/*
tsmthread(DMAJ=35    // Major diameter
    , L=180,                 // Length of thread in mm.  Accuracy depends on pitch.
    , PITCH=6.667,            // Scale of the thread itself.
    , PR=THREAD_UTS// Thread profile, i.e. ACME, UTS, other
    , STARTS=3,             // Want a crazy 37-start thread?  You're crazy.  but I'll try.
    , TAPER=0,              // Adds an offset of [1,tan(TAPER)] per thread.
    , STUB=0,               // Extends a cylinder below the thread.  In pitch units.
    , STUB_OFF=0            // Reduces the diameter of stub.  In pitch units.
    );
*/

//comp_thread(DMAJ=11, L=20, PITCH=2, A=10, H1=0.5/2, H2=0.5/2, STARTS=1, in=false);
/*
imperial(){
    union(){
        translate([0, 0, 1/4])
        thread_npt(DMAJ=0.54 + $OD_COMP,L = 1/2,PITCH = 0.05556);
        cylinder(d=1, h=1/4, $fn=6);
    }
}
*/
/**
 * Corrections for inside and outside diameters in mm.  Only comp_thread
 * and the test platters care, not raw tsmthread.  They are $metavariables
 * so imperial() can scale them.
 *
 * Basically, tsmthread(DMAJ=X+$OD_COMP) for outside diameters and
 * tsmthread(DMAJ=X+$ID_COMP) for insides is good enough for wide-angled
 * like the ordinary UTS bolts used everywhere internationally.
 *
 * Leadscrews OTOH are very steep and print horribly.  comp_thread will
 * generate them with narrower teeth to compensate.
 */
$OD_COMP=-0.25; // Add this to outside diameters, in mm
$ID_COMP=1;     // Add this to inside diameters, in mm
$PE=0.35;       // Pitch Error.  Adjusts tooth thickness.

module print_acme() {
    // Tested on ground metal 3/8-10 ACME rod
    // Flange for 3/8"-10 ACME
    // Flange dimensions:
    // https://www.helixlinear.com/Product/PowerAC-38-2-RA-wBronze-Nut/
    translate([40,0]) imperial() difference() {
        taper(d=3/8, h=0.41+0.62, off=1/16, in=true)
            flange(B=0.62, C=0.85,G=0.41,H=1.606+$OD_COMP, F=1.25, F2=.266, off=1/16, open=true);

        comp_thread(DMAJ=3/8, L=2, PITCH=1/10, A=29, H1=0.5/2, H2=0.5/2, in=true);
    }

    // Tested on ground metal TR11x2 rod.
    // TR11x2 flange
    // https://www.omc-stepperonline.com/download/23LS22-2004E-300T.pdf
    difference() {
        intersection() {
            flange(B=17, G=8, F=23, F2=5, C=15+$OD_COMP, H=30+$OD_COMP, holes=[0,180], off=1,open=1);
            taper(d=11, h=25, off=1, in=true)
            translate([30-25-$OD_COMP,0,0]/2) cube([25,40,50],center=true);
        }

        // Compensated thread, otherwise leadscrews need to be oversized a disgusting amount
        comp_thread(11, 30, 2, 30, 0.5/2, 0.5/2, in=true);
    }
}

module print_npt() {
    /* https://mdmetric.com/tech/thddat19.htm */

    imperial() {
        /* 1/2" NPT.  Tested. */
        
        difference() {
            union() {
                translate([0,0,15/64]) 
                thread_npt(DMAJ=0.840+$OD_COMP, PITCH=0.07143, L=0.07143*8);
                cylinder(d=flat(), h=1/4, $fn=6);
            }
            
            translate([0,0,1/4-1/64]) cylinder(d=5/8, h=2);
        }
        

        /**
         * A 3/8" compression fitting thread.  That is to say, 3/8"
         * is the tube OD, not the thread.  Tested.
         */
        
        translate([0,2.5]) {
            translate([0,0,1/4-1/16]) difference() {
                tsmthread(DMAJ=9/16+$OD_COMP, PITCH=1/18, L=9/18);
                cylinder(d=3/8+$ID_COMP, h=1);
            }

            cylinder(d=(5/8)*flat(),h=1/4, $fn=6);
        }
    

        /* Nut for 1 1/2" NPT fitting.  Tested. */
        difference() {
            cylinder(d=flat()*(2+1/16), h=1/4, $fn=6);
            translate([0,0,-1/64]) thread_npt(DMAJ=1.900+$ID_COMP, PITCH=1/11.5, L=8/11.5);
        }


        /* 1 1/4" NPT pipe.  Tested. */
        translate([0,2.5]) difference() {
            union() {
                cylinder(d=flat()*(1+3/4), h=1/4, $fn=6);
                translate([0,0,15/64])
                thread_npt(DMAJ=1.660+$OD_COMP, PITCH=1/11.5, L=8/11.5);
            }
            translate([0,0,-1/4]) cylinder(d=1+3/8+$ID_COMP, h=2);
        }

        /* NPT 1 1/2 external - 1 1/4 internal adapter.  Tested. */
        translate([0,-2.5]) difference() {
            union() {
                cylinder(d=flat()*(2+1/16), h=1/4, $fn=6);
                translate([0,0,15/64]) thread_npt(DMAJ=1.900+$OD_COMP, PITCH=1/11.5, L=8/11.5);
            }
            
            translate([0,0,-1/64]) thread_npt(DMAJ=1.660+$ID_COMP, PITCH=1/11.5, L=8/11.5);
            translate([0,0,7.5/11.5]) cylinder(d=1.660-(1/16)*(8/11.5), h=1);
        }
    }
}
//print_npt();

 /* 1 1/4" NPT pipe.  Tested. */


module print_test() {
    // tsmthread obeys $fs, $fn, $fa
    $fs=1;
    $fa=1.5;

    // 1/2" NPT
    imperial() difference() {
        union() {
            translate([0,0,15/64]) 
            thread_npt(DMAJ=0.840+$OD_COMP, PITCH=0.07143, L=0.07143*8);
            cylinder(d=flat()*1, h=1/4, $fn=6);
        }
        
        cylinder(d=5/8, h=2, center=true);
    }

    /* coax F-connector. 3/8"-32  Tested. */
    translate([-15,15]) imperial() {
        difference() {
            translate([0,0,1/16]) tsmthread(DMAJ=3/8+$OD_COMP, L=3/8, PITCH=1/32);
            cylinder(d=(3/16)+$ID_COMP, h=2, center=true);
        }
        
        cylinder(d=(1/2)*flat()+$OD_COMP, h=(1/8), $fn=6);
    }

    // Garden hose, 1 1/16-11.5.  1/4" hex.  Tested.
    translate([0,30]) imperial() difference() {
        taper(d=1+1/16, h=3/8, off=1/8)
        tsmthread((1+1/16)+$OD_COMP, 3/8, 1/11.5, PR=THREAD_NH);
        // 1/4" hex key
        cylinder(d=flat()*(1/4)+$ID_COMP, h=2, $fn=6, center=true);
    }

    // Test 3:  1/4" camera screw.  Tested.
    translate([15,15]) imperial()  {
        translate([0,0,1/8]) tsmtread(1/4+$OD_COMP, 1/4, 1/20, STUB=20*(1/4), STUB_OFF=1);
        difference() {
            // pretty, oh, so pretty
            taper(d=(1/2)*flat(), h=1/8, off=(1/2)*(3/16))
                cylinder(d=flat()*(1/2)+$OD_COMP, $fn=6, h=1/8 );
            // Cut slot for screwdriver
            cube([(1/16),1,2/16],center=true);
        }
    }
}

module visual_test() {
    $fs=1;
    $fa=1.5;
    

    /* Visual test 1, compare thread profiles to cross-section of thread */
    translate([10,0]) for(X=[  ["ACME",[0,0],THREAD_ACME,2 ],
            ["UTS", [8,0],THREAD_UTS,1 ],
            ["BUTT",[8,-5],THREAD_BUTT,1],
    ]) translate(X[1]) show_profile(X[2], X[0]);

    translate([10,-5]) show_profile(V=prof_npt(10), TAPER=10,title="NPT");

    /* Visual test 2, demonstration of NPT profile angles */
    translate([-10,-25]) scale([5,5,1]) color("lightblue") npt_profile_test();

    /* Visual test 3, meshing with ACME thread of thingiverse object */
    translate([0,8])
    {
        /* https://www.thingiverse.com/thing:1954719/files */
        /**
         *  3d-printed thread design which has a nominal DMAJ of 8mm
         *  but is actually 9mm when you measure the STL file.
         */
        color("lightgreen") projection(cut=true) rotate([90,0]) import("nut_8mm4start2mm.stl");
        
        /**
         * An 8mm thread fitting in that object.  It "fits right", but
         * notice how only the tips are touching.
         */
        color("green") difference() {
            projection(cut=true) rotate([90,0]) 
                translate([0,0,2+0.25])
                    tsmthread(DMAJ=8, L=5, PITCH=2, PR=THREAD_TRAP, STARTS=4);
            translate([-1.5,-3.5]) text("8mm",1);
            translate([-3,-5]) text("UNCOMP",1);
        }

        /**
         *  Pitch-compensated 9mm.
         *  A perfect match for the "8mm" thread!
         */
        color("cyan") difference() {
            projection(cut=true) rotate([90,0])
            translate([0,0,10+0.40])
                comp_thread(DMAJ=9+$OD_COMP, L=5, PITCH=2, STARTS=4,
                A=30, H1=0.25, H2=0.25);
            translate([-1.5,-11.5]) text("9mm",1);
            translate([-2,-13]) text("COMP",1);
        }
                
        
    }

    /* Visual test 4:  UTS metric threads, 20mm. */
    /* https://www.thingiverse.com/thing:25705 */
    translate([-30,8]) {
        color("lightblue") 
            projection(cut=true) rotate([90,0]) import("Teil_1.stl");

        projection(cut=true) rotate([90,0]) 
            translate([0,0,-2.5]) rotate([0,0,-80]) tsmthread(20,20,2.5,STARTS=1);
    }
    // Visual test 5:  Torture test using all features at once.
    // If I break anything, it usually shows up here.
/*    translate([10,25])
    tsmthread(DMAJ=18, L=20, PITCH=6, STARTS=6, PR=THREAD_BALL, TAPER=-30);*/
}

//visual_test();

module show_profile(V=THREAD_ACME, title="ACME", l=4, s=1, TAPER=0) {
    ADD=(TAPER>0)?add_npt(TAPER):[1,0];
    
    POLY=concat([[0,-1]],
        [for(N=[0:(len(V)*l)])
            [wrap(V,N,ADD)[0], 1+4*ADD[1]-wrap(V,N,ADD)[1]] ],
            [[l,-1]]);
    color("lightblue") difference() {
        polygon(POLY);
        translate([0.5,-0.75]) text(title,0.75);
    }

    translate([4,-1]) /*projection(cut=true)*/ 
        rotate([0,90]) tsmthread(4,3,1,PR=V, STARTS=s, TAPER=TAPER, $fn=64);
}

 
 /**
 * Generates truncated, symmetrical thread profiles like UTS or ACME
 * A is pitch angle
 * MIN is distance below centerline in pitch units
 * MAX is distance above centerline in pitch units
 * TOL makes tooth narrower/wider and deeper/shallower than perfect by TOL amount,
 * again in units of pitch
 *
 * Resuls biased to zero and inverted -- just like tsmthread() likes them.
 */
function prof(A,MIN,MAX)=let(
        M=tan(90-(A/2)), // Slope of tooth
        X1=((M/2)-(MIN*2))/M, // Given a Y of MIN, calculate X
        X2=((M/2)+(MAX*2))/M, // Given a Y of MAX, calculate X
    OFF=-X1*M) [
    [0, OFF + M*X1], // Starting point, always
    [X1+X1,OFF + M*X1],
    [X1+X2,OFF+M*X2],
    [X1+2-X2,OFF+M*X2],
    // Profile wraps here
]/2;

/**
 * Profile Interpolation
 *
 * prof() generates, and tsmthread expects, a profile of [X,Y] values like
 * [ [0,0.25], [0.25, 1], [0.5,0.25] ]
 * The first X must be 0.  The last X cannot be 1.  All values are in pitch units.
 *
 * Get a value out with interpolate(PR, X).
 *      interpolate(PR, 0.25) would return 1,
 *      interpolate(PR, 0) would give 0.25,
 *      interpolate(PR, 0.125) would  give someting between.
 *      interpolate(PR, 0.5) would give 0.25.
 *      interpolate(PR,0.75) would wrap, interpolating between P[2]-p[0].
 *
 * Should wrap cleanly for any positive or negative value.
 */

/**
 * Helper function for interpolate().  Allows
 * a thread profile to repeat cleanly for increasing
 * values of N, with growing X accordingly.
 *
 * P=[ [0,0], [0.5,0.5] ];
 * echo(wrap(P,0)); // should be [0,0]
 * echo(wrap(P,1)); // should be [0.5,0.5]
 * echo(wrap(P,2)); // should be [0,0]+[1,0]
 * echo(wrap(P,3)); // should be [0.5,0.5]+[1,0]
 * echo(wrap(P,4)); // should be [0,0]+[2,0]
 * etc.
 */
function wrap(V, N, ACC=[1,0])=let(M=floor(N/len(V))) V[N%len(V)] + M*ACC;

/* Very basic interpolation.  mix(A,B,0)=A, mix(A,B,1)=B, 0 <= X <= 1 */
function mix(A,B,X)=(A*(1-X)) + B*X;

/**
 * Line-matching.  V1-V2 are a pair of XY coordinates describing a line.
 * Returns [X,Y] along that line for the given X.
 */
function mixv(V1,V2,X)=let(XP=X-V1[0]) mix(V1,V2,XP/(V2[0]-V1[0]));
/* Same, but X for given Y */
function mixvy(V1,V2,Y)=let(OUT=mixv([ V1[1],V1[0] ], [V2[1],V2[0]], Y)) [ OUT[1],OUT[0] ];

/**
 * Returns Y for given X along an interpolated Y.
 * V must be a set of points [ [0,Y1], [X2,Y2], ..., [XN,YN] ] X<1
 * X can be any value, even negative.
 */
function interpolate(V, X, ACC=[1,0], N=0)=
//  Speedup that doesn't help much
    (X>1) ? interpolate(V, (X%1),ACC,N)+floor(X)*ACC[1]:
//      Unneeded case
//    (X<0) ? interpolate(V, 1+(X%1),ACC,N)+floor(X)*ACC[1] :
    (X>wrap(V,N+1)[0]) ?
    interpolate(V,X,ACC,N+1)
:   mixv(wrap(V,N,ACC),wrap(V,N+1,ACC),X)[1];

/**
 *  V = [ [X0,Y0], [X1,Y1], ..., [XN,YN] ] where X0 < X1 < X2 ... < XN
 *
 *  Finds N where XN > X.
 */
function binsearch(PR,X,MIN=0,IMAX=-1)=let(MAX=(IMAX<0)?len(PR):IMAX,
    N=floor((MIN+MAX)/2))
    ((MAX-MIN) <= 1) ? N
    :   X < PR[N][0] ?
        binsearch(PR,X,MIN,ceil((MIN+MAX)/2))
    :   binsearch(PR,X,floor((MIN+MAX)/2),MAX);

/**
 *  V = [ [X0,Y0], [X1,Y1], .., [XN,YN] ] where X0 < X1 < ... < XN and XN < 1
 *
 *  Returns N for given XN like binsearch(), except it wraps X > 1 to 0-1
 *  and returns correspondingly higher N.
 */
function binsearch2(PR,X)=binsearch(PR,X%1)+floor(X)*len(PR);

/**
 * Faster lookup for interpolate().  log(N)
 */
function interpolate2(V,X,ADD=[1,0])=V[binsearch(V,(X%1))][1]+floor(X)*ADD[1];

function interpolaten(V,X,ADD=[1,0])=binsearch(V,(X%1))+floor(X);

module tsmthread(DMAJ=20    // Major diameter
    , L=50,                 // Length of thread in mm.  Accuracy depends on pitch.
    , PITCH=2.5,            // Scale of the thread itself.
    , PR=THREAD_UTS// Thread profile, i.e. ACME, UTS, other
    , STARTS=1,             // Want a crazy 37-start thread?  You're crazy.  but I'll try.
    , TAPER=0,              // Adds an offset of [1,tan(TAPER)] per thread.
    , STUB=0,               // Extends a cylinder below the thread.  In pitch units.
    , STUB_OFF=0            // Reduces the diameter of stub.  In pitch units.
    ) {

    /* Minimum number of radial points required to match thread profile */
    POINTS_MIN=len(PR)*STARTS*2;

    // OpenSCAD-style fragment generation via $fa and $fs.
    // See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
    function points_r(r)=ceil(max(min(360.0 / $fa, (r*2)*3.14159 / $fs), 5));

    // Rounds X up to a nonzero multiple of Y.
    function roundup(X,Y) = Y*max(1,floor(X/Y) + (((X%Y)>0)?1:0));

    // Points can be forced with $fn
    POINTS=($fn>0) ? $fn :
        // Otherwise, it decides via $fs and $fa, with a minimum of
        // 16, rounded up to POINTS_MIN
        max(roundup(16,POINTS_MIN), roundup(points_r(DMAJ/2),POINTS_MIN));

    if(POINTS % POINTS_MIN )
    {
        echo("WARNING:  DMAJ",DMAJ,"PITCH",PITCH,"STARTS",STARTS, "POINTS", POINTS);
        echo("WARNING:  POINTS should be a multiple of",POINTS_MIN);
        echo("WARNING:  Top and bottom geometry may look ugly");
    }

    ADD=add_npt(TAPER); /* How much radius to add to pitch each rotation */

    // 1*STARTS rows of thread tapper happens which isn't drawn
    // Add this to radius to compensate for it
    TAPER_COMP=STARTS*ADD[1]*PITCH;


    // [X,Y,Z] point along a circle of radius R, angle A, at position Z.
    function traj(R,A,Z)=R*[sin(A),cos(A),0]+[0,0,Z];

    /**
     * The top and bottom are cut off so more height than 0 is needed
     * to generate a thread.
     */
    RING_MIN=(STARTS+1)*len(PR);

    // Find the closest PR[N] for a given X, to estimate thread length
    function minx(PR,X,N=0)=(X>wrap(PR,N+1,ADD)[0])?minx(PR,X,N+1):max(0,N);

    // Calculated number of rings per height.
    RINGS=let(SEG=floor(L/PITCH), X=(L%PITCH)/PITCH) max(RING_MIN+1,
        RING_MIN+SEG*len(PR) + minx(PR,X));

    SHOW=0;     // Debug value.  Offsets top and bottom to highlight any mesh flaws
    
    /**
     * How this works:  Take PR to be the outside edge of a cylinder of radius DMAJ.
     * Generate points for 360 degrees.  N is angle along this circle, RING is height.
     *
     * Now, to turn this circle into a spiral, a little Z is added for each value of N.
     * The join between the first and last vertex of each circle must jump to meet.
     */
    function zoff(RING,N)=(wrap(PR, RING,ADD)[0] + STARTS*(N/POINTS));
    FLAT_B=zoff(len(PR)*STARTS,0);  // Z coordinates of bottom flat
    FLAT_T=zoff(RINGS-len(PR),0);   // Z coordinates of top flat
   
    /**
     * Deliminate what spiral coordinates exist between the top and bottom flats.
     * Used for loops, so that only those polygons are joined and nothing outside it.
     */
    // function ringmin(N)=binsearch2(PR,FLAT_B - (N/POINTS)*STARTS)+1;
    // function ringmax(N)=binsearch2(PR,FLAT_T - (N/POINTS)*STARTS);

    // Fast-lookup arrays
    MIN=[for(N=[0:POINTS-1]) binsearch2(PR,FLAT_B - (N/POINTS)*STARTS)+1 ];
    MAX=[for(N=[0:POINTS-1]) binsearch2(PR,FLAT_T - (N/POINTS)*STARTS) ];
        
    // Array-lookup wrappers which speed up ringmax/ringmin manyfold.
    // binsearch makes them fast enough to be tolerable, but still much better
    function ringmax(N)=MAX[N%POINTS];
    function ringmin(N)=MIN[N%POINTS];
    
    /**
     * Difficult difficult lemon difficult.
     * Interpolate along the profile to find the points it cuts through
     * the main spiral.
     *
     * Some difficulty is RING coordinates increase P, while N decreases
     * it as it crosses the spiral!
     *
     * Taper must be accounted for as well.
     */
    function radius_flat(RING,N)=
        TAPER_COMP+
        (DMAJ/2)-PITCH*interpolate(PR,wrap(PR,len(PR)*STARTS+RING,ADD)[0] - 
            // Modulous because this is all the same taper
            (STARTS*(N/POINTS))%1 - STARTS,ADD)
            // Of course we have to un-taper too, sigh
            -ADD[1]*STARTS*(((N/POINTS)*STARTS)%1);
    /**
     * Radius is generated differently for the top&bottom faces than the spiral because 
     * they exist in different coordinate spaces.  Also, the top&bottom faces must be
     * interpolated to fit.
     */
    function cap(RING,ZOFF=0,ROFF=0)=[
        for(N=[0:POINTS-1])
        let(P=N/POINTS, A=-360*P,R=radius_flat(RING,N)+ROFF)
            traj(R,A,zoff(RING,0)+ZOFF) 
        ];

    /**
     * Debug function.
     * Draws little outlines at every ring height to compare spiral generation
     * to face generation.
     */
    module test() {
        for(RING=[0:RINGS-1]) {
            POLY=cap(RING, ROFF=0.1);
            LIST=[ [ for(N=[0:POINTS-1]) N ] ];

            polyhedron(POLY,LIST);
        }
    }

    /**
     * Helper array for generating polygon points.
     * DATA[0]+N, N=[0:POINTS-1] for a point on the bottom face
     * DATA[1]+N, N=[0:POINTS-1] for a point on the top face
     * DATA[2]+N + (M*POINTS), N=[0:POINTS-1], M=[0:RINGS-1] for
     * a point on the main spiral.
     */
    DATA=[ 0,                          // 0 = bottom face
           POINTS,                     // 1 = top face
           4*POINTS,                   // 2 = main spiral
           2*POINTS,                   // 3 = stub top
           3*POINTS,                   // 4 = stub bottom
           2*POINTS+POINTS*len(PR),    
           2*POINTS+POINTS*len(PR) + 
                RINGS*POINTS
        ];
    
    /**
     * This is it, this is where the magic happens.
     * Given a point in RING,N spiral coordinates, this decides whether it
     * ends up in the top, the spiral, or the bottom so I don't have to.
     *
     * TODO:  Optimize this.  This is a pinch point.
     */
    function point(RING,N)=
        (RING<ringmin(N)) ? DATA[0]+(N%POINTS) // Bottom flat
       :(RING>ringmax(N))? DATA[1]+(N%POINTS)  // Top flat
       :DATA[2]+RING*POINTS + (N%POINTS);       // Inbetween

    // Like above but takes a vector to transform into a triangle
    function pointv(V)=[ for(N=V) point(N[0],N[1]) ];

    
    /**
     * List of points, organized in sections.
     * 0 - RINGS-1          Bottom cap
     * RINGS - (2*RINGS)-1  Top cap
     * RINGS - (3*RINGS)-1  Stub
     * (2*RINGS) - end      Spiral
     * Do not change this arrangement without updating DATA to match!
     */
    POLY=concat(
        // Bottom cap, top cap
        cap(len(PR)*STARTS,-SHOW),cap(RINGS-len(PR),SHOW),
        // Stub top
        [ for(N=[0:POINTS-1]) let(R=(DMAJ/2)-(STUB_OFF*PITCH)) traj(R,-360*(N/POINTS), 1) ],
        // Stub bottom
        [ for(N=[0:POINTS-1]) let(R=(DMAJ/2)-(STUB_OFF*PITCH)) traj(R,-360*(N/POINTS),
           -STUB) ],
        //cap(len(PR)*STARTS, -STUB),
    
        // Main spiral
        [ for(RING=[0:RINGS-1], N=[0:POINTS-1])
            let(A=-360*(N/POINTS),
                P1=wrap(PR,RING,ADD),
                P2=wrap(PR,RING+len(PR)*STARTS,ADD),
                UV=mix(P1,P2,N/POINTS),
                R=TAPER_COMP+(DMAJ/2)-PITCH*UV[1], Z=UV[0])
                traj(R, A, Z)
        ]);


    /**
     * Remove redundant points from polygons.
     * collapse([0,1,1,2,3,4,0]) == [0,1,2,3,4]
     */
    function collapse(V)=[ for(N=[0:len(V)-1]) if(V[(N+1)%len(V)] != V[N]) V[N] ];

    // Should we use quads here?  Will fewer loops be faster?
    // Probably shouldn't alter the hard-won mesh maker, but
    // can we do more per loops somehow?
    PLIST=concat(
        // Main spiral A
        [   for(N=[0:POINTS-2], RING=[ringmin(N)-1:ringmax(N)])
            pointv([ [RING,N+1],[RING,N],[RING+1,N] ])
        ],
        // Main spiral B
        [   for(N=[0:POINTS-2], RING=[ringmin(N+1)-1:ringmax(N+1)])
            pointv([[RING+1,N+1],[RING,N+1],[RING+1,N]])
        ],
        // stitch A
        [   for(N=POINTS-1, RING=[ringmin(N)-1:ringmax(0)])
            let(P=pointv([ [RING,N],[RING+1,N],[RING+len(PR)*STARTS,0] ]))
            if((P[0] != P[1]) && (P[0] != P[2]) && (P[1] != P[2])) P
        ],
        // Stitch B
        [
            for(N=0, RING=[ringmin(N)-1:ringmax(N)])
            let(P=pointv([[RING+1,N],[RING,N],[RING+1-len(PR)*STARTS,POINTS-1]]))
            if((P[0] != P[1]) && (P[0] != P[2]) && (P[1] != P[2])) P
        ],

        // Bottom extension
        [ if(STUB) for(WELD=[[0,3],[3,4]], N=[0:POINTS-1])
            [ DATA[WELD[0]]+N, DATA[WELD[0]]+(N+1)%POINTS, DATA[WELD[1]]+(N+1)%POINTS ] ],
        [ if(STUB) for(WELD=[[0,3],[3,4]], N=[0:POINTS-1])
            [ DATA[WELD[1]]+N, DATA[WELD[0]]+N, DATA[WELD[1]]+(N+1)%POINTS ] ],
        
        // Bottom flat
        [ [ for(N=[0:POINTS-1]) N+DATA[(STUB>0)?4:0] ] ],
        // top flat.  Note reverse direction to mirror the normal.
        [ [ for(N=[0:POINTS-1], N2=POINTS-(N+1)) N2+DATA[1] ] ]
    );


    // Screw it, scale after, PITCH=1 is so much less math
    scale([1,1,PITCH]) translate([0,0,STUB?STUB:-FLAT_B]) polyhedron(POLY, PLIST, convexity=5);
}

// Compensated Threads.
// Threads are thinned by $PE mm.  Diameter is adjusted $OD_COMP/$ID_COMP amount
// depending on whether they're inside or outside threads.
// Only use this with leadscrews.
// A and H values as with prof().
module comp_thread(DMAJ=11, L=20, PITCH=2, A=30, H1=0.5/2, H2=0.5/2, STARTS=1, in=false)
{
    PE2=(in?$PE :-$PE)*(2.0/PITCH)*cos(A);
    echo("PE",PE2,"$PE",$PE);
    PR=prof(A, H1-PE2, H2+PE2);
    echo("comp_thread","DMAJ",DMAJ,"L",L,"PITCH",PITCH,"A",A,"H1",H1,"H2",H2,"=",PR);

   tsmthread(DMAJ+(in?$ID_COMP:$OD_COMP), L=L, PITCH=PITCH, STARTS=STARTS, PR=PR);
}

/* All common nuts and bolts. */
THREAD_UTS =let(H=0.8660) prof(60,H*(7/16), H*(3/8));

/* "Garden Hose" thread profile.  Very close to UTS but sharper & deeper. */
THREAD_NH=let(H=0.8660) prof(60, H*(3/8), H*(3/8));

//THREAD_EXTERNAL_NPSH=let(H=0.8660/2) prof(60,(H-.1), H-0.1);

/* Imperial leadscrews */
THREAD_ACME=let(H=0.5/2) prof(29,H,H);

/* Metric leadscrews */
THREAD_TRAP=let(H=0.5/2) prof(30,H,H);

// Vises, etc
THREAD_EXTERNAL_SQUARE=[ [0,0], [0.25+.1,0], [0.25+.1,0.5],[0.75+.1,0.5],[0.75+.1,0]];

// Just for the hell of it, buttress threads.
function prof_butt(A,FLAT)=let(M=tan(A)) 
    [ [0,0],[FLAT,0],[FLAT,M*(1-(2*FLAT))], [2*FLAT,M*(1-(2*FLAT))] ];

THREAD_BUTT=prof_butt(30,0.2);

/* Just for fun, ball threads. */
THREAD_BALL=concat([ [0,0] ],
// Designed for 4.5mm balls used at a 6mm pitch
    [ for(A=[0:12.857:180]) let(R=(4.5+0.25)/(6*2)) R*[ -cos(A),sin(A) ]+[0.5,0]
    // implied
    // , [ 1,0 ] 
        ] );

/******************************************************************************/
/********************************NPT THREAD************************************/
/******************************************************************************/

/**
 * Tapering only works without distorting teeth because of the special
 * prof_npt thread profile.
 */
module thread_npt(DMAJ=10, L=10, PITCH=2.5, TAPER=1+(47/60), STUB=0) {
    PR=prof_npt(TAPER);
//    echo(PR);
    echo(add_npt(TAPER));
//    echo(TAPER);
    tsmthread(DMAJ=DMAJ, L=L, PITCH=PITCH, TAPER=TAPER, PR=PR, STUB=STUB);
}

/**
 * Differentiate an array.  delta([0,1,2,3,4,5])=[1,1,1,1]
 * Works on vectors too.
 */
function delta(V)=[ for(N=[0:len(V)-2]) V[N+1]-V[N] ];

// Integrate an array up to element N.
function integ(A, ADD=[ [1,0], [0,1] ], KEEP=[ [0,0], [0,0] ])=[
    for(N=[0:len(A)-2]) integ2(A, N, ADD, KEEP)	];
function integ2(A, N,
    ADD=[ [1,0], [0,1] ],
    KEEP=[ [0,0],[0,0] ])=
        (N<=0)?
            A[0]
        :(A[N]*KEEP) + (A[N]*ADD) + (integ2(A, N-1, ADD, KEEP) * ADD);

function normy(V)=V/V[1];               // Normalize a vector along Y, i.e. [3,0.5] -> [6,1]
function add_npt(TAPER)=[1,tan(TAPER)]; // Why so easy? tan(ANGLE) is the slope of an angle.

/**
 * NPT magic:  Length is added to one specific tooth so the
 * distorted half is bent back up to the correct angle.
 *
 * Only one value needs adding to.  The other fixes itself
 * via adding [1,M] per wraparound.
 */
function prof_npt(TAPER=30, H1=0.8/2, H2=0.8/2) =
    let(M=tan(TAPER), PR2=delta(prof(60,H1,H2))) 
    integ([
            [0,0],  // Replace origin deleted by delta()
            PR2[0], // bottom flat, OK
            // This is already a perfect 60 degrees, only scale it.
            // Have to add length of line AND length of flat!  Arrrrgh.
            PR2[1]+M*normy(PR2[1])*(PR2[1][0]+PR2[0][0]),
            PR2[2], // top flat
            PR2[3] ]);

module npt_profile_test(TAPER=15, W=3) translate([1/8,2/3]) {
    /* Calculate taper and matching NPT profile */
    PR=prof_npt(TAPER,0.4,0.4);
    ADD=add_npt(TAPER);


    /* A diagram of NPT thread calculated the same way tsmthread does it */
    difference() {
        for(X=W) polygon(concat(
            [ [0,-0.125] ],
            [ for(N=[0:X*len(PR)]) wrap(PR,N,ADD) ],
            [ [X,-0.125] ]
            ));
        translate([0,-0.1]) rotate([0,0,TAPER]) square([10,0.025]);

        translate([1.5,-1/16]) text("A",0.25);
    }

    translate([0.25,-0.5]) text("NPT Taper Profile",0.25);


    for(X=[1:W-1], S=0.8)
    translate([0.02,1-.22]+X*ADD) difference() {
        // Equilateral triangles to eyeball with
        rotate([0,0,-90]) intersection() {
            circle($fn=3, d=S/cos(60));
            rotate([0,0,60]) circle($fn=3, d=-.1+flat(3)*S/cos(60));
        }
        translate(-[0.75,1]*0.25) text("60",0.25);
    }

    echo("Input angle",TAPER,"Measured Angle", 
        atan((interpolate(PR,2,ADD) - interpolate(PR,0,ADD))/2),"Diff",
        TAPER-atan((interpolate(PR,2,ADD) - interpolate(PR,0,ADD))/2)
    );
}

/******************************************************************************/
/******************************MISC UTILITIES**********************************/
/******************************************************************************/

/**
 *  i.e. cylinder(d=flat(6)*10,$fn=6)
 *  makes a 10mm flat-to-flat hexagon.
 */
function flat(N=6)=1/cos(180/N);

/**
 *  Scales up objects to imperial inches and and alters $fs accordingly, so
 *  imperial() cylinder(d=1, h=1); renders a satisfying number of facets
 *  instead of freaking 5.
 */
module imperial(F=25.4) { 
    // modified $... values will be seen by children
    $fs     =$fs     /F;
    $OD_COMP=$OD_COMP/F;
    $ID_COMP=$ID_COMP/F;
    $PE     =$PE     /F;
    $SCALE  =         F;
    scale(F) children();
}

/**
 * A double-pointed cone or pyramid of exactly 45 degrees for tapers.
 * obeys $fn, $fs, $fa, r, d, center=true in a manner like cylinder().
 * example:
 *
 *  // Outside taper
 *  taper(d=10, h=10, off=1) cylinder(d=10, h=10);
 *
 *  // Inside taper
 *  difference() { cylinder(d=10, h=10); taper(in=true, d=5, h=10, off=1) cylinder(d=5, h=10); }
 */
module taper(d=1,h=1,off=0,r=0, center=false, in=false) {
    function points_r(r)=$fn?$fn:(ceil(max(min(360.0 / $fa, (r*2)*3.14159 / $fs), 5)));

    if(r) taper(r*2, h, off, r=0, center=center, in=in);
    else {
        // Calculate number of fragments same way openscad does
        U=points_r(d/2);

        if(in) difference() {
            children();
            translate(center?[0,0,0]:[0,0,h/2]) union() {
                for(M=[[0,0,1],[0,0,0]]) mirror(M)
                translate([0,0,h/2-d/2-off]) cylinder(d1=0, d2=d*2, h=d, $fn=points_r(d/2));
            }
        }
        else intersection() { 
            children();
            translate(center?[0,0,0]:[0,0,h/2]) scale(h+d-off) polyhedron(
                concat( [ for(N=[0:U-1]) 0.5*[cos((N*360)/U),sin((N*360)/U),0] ],
                        // Top and bottom of pyramid
                        [ 0.5*[ 0,0,1], -0.5*[0,0,1] ] ),
                concat( [ for(N=[0:U-1]) [ N, U, (N+1)%U]],
                        [ for(N=[0:U-1]) [ (N+1)%U, U+1, N]]
                ));
        }
    }
}

// Flange pattern as described by this URL:
// https://www.helixlinear.com/Product/PowerAC-38-2-RA-wBronze-Nut/
//
//      /---\   <--------
//      |   |           |
// ---> |>>>|           |
// |    |   |           |
// |    |   \---\ <--   |
// |    |       |   |   |
// F*2  |       |   C   H
// |    |       |   |   |
// |    |   /---/ <--   |
// |    |   |           |
// ---> |>>>|           |
//      |   |           |
//      \---/   <--------
//      ^   ^   ^
//      |-G-|-B-|
//
//      B is height of stem
//      C is diameter of stem
//      F is the radius of the screw pattern
//      F2 is the diameter of the screw holes.
//      G is the thickness of the base
//      H is width of base.
//
//      holes is the pattern of holes to drill.  default is 4 holes, 1 every 90 degrees.
//      when open is true, the holes are sots extending to the edge.
//      off is how much to bevel.
module flange(B,C,F,F2,G,off=0,holes=[45:90:360], open=false) {
    taper(d=H,h=G,off=off) linear_extrude(G, convexity=3) offset(off/2) offset(-off/2) difference() {
        circle(d=H);
        for(A=holes) hull() {
            translate(F*[sin(A),cos(A)]/2) circle(d=F2);
            if(open) translate(3*F*[sin(A),cos(A)]/2) circle(d=F2);
        }
    }
    if(B && C) taper(d=C,h=G+B,off=off) cylinder(d=C, h=G+B);
}

// What the hell is this?  I don't know.
module garnet() intersection_for(A=[[0,0,1],[0,1],[1,0]]) rotate(45*A) cube(10*[1,1,1],center=true);

//garnet();