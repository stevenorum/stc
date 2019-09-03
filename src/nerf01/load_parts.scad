use <../functions.scad>;
include <dimensions.scad>;
rc_color = ["black",0.5];
sr_color = ["orange",1.0];
sd_color = ["yellow",1.0];
sc_color = ["red", 1.0];
ph_color = ["blue",1.0];
bh_color = ["orange",1.0];
tg_color = ["purple",1.0];
rc_color = ["black",0.5];
ce_color = ["lime",0.5];
ci_color = ["white",0.2];
mw_color = ["magenta",1.0];

include <parts/sear_disk.scad>;
include <parts/sear_catch.scad>;
include <parts/safety.scad>;
include <parts/plunger.scad>;
include <parts/bolt.scad>;
include <parts/trigger.scad>;
include <parts/receiver.scad>;
include <parts/cylinder.scad>;
include <parts/magwell.scad>;

color(mw_color[0], mw_color[1]) {
     magwell_3d();
};

color(sc_color[0], sc_color[1]) {
     //sear_catch_3d();
};

color(sd_color[0], sd_color[1]) {
     sear_disk_3d();
};

color(tg_color[0], tg_color[1]) {
     //trigger_3d();
};

color(sr_color[0], sr_color[1]) {
     //safety_3d();
};

color(ph_color[0], ph_color[1]) {
    //plunger_3d();
};

color(bh_color[0], bh_color[1]) {
    //bolt_3d();
};

color(ci_color[0], ci_color[1]){
    //cylinder_interior_3d();
};                                                                                                                                         

color(ce_color[0], ce_color[1]){
    //cylinder_exterior_3d();
    //cylinder_exterior_3d();
};

color(rc_color[0], rc_color[1]) {
    //receiver_spring_blocks(); // not to be printed, but I want to see these and rendering the entire receiver plate takes a shockingly long time for some reason.
    //receiver_axle_pins(); // not to be printed, but I want to see these and rendering the entire receiver plate takes a shockingly long time for some reason.
 //receiver_right_side(); 
 //receiver_left_side(); 
// receiver_front_cylinder_holder(); 
// receiver_rear_cylinder_holder(); 
};
