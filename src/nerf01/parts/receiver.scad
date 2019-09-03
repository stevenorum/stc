use <../../functions.scad>;
include <../dimensions.scad>;

module receiver_pin_cutouts() {
     // Screw holes to connect to other half
     circleXY(rc_sr, X=rc_fx+1/4, Y=rc_fy+1/4);
     circleXY(rc_sr, X=rc_fx+1/4, Y=rc_fy+1/4+1);
     circleXY(rc_sr, X=rc_rx-1/4, Y=rc_fy+1/4);
     circleXY(rc_sr, X=rc_rx-1/4, Y=rc_fy+1/4+1);
     // safety hole
     translate(sr_offset) {
          safety_cutout_2d();
     };
     // axle pins
     translate(sd_offset) {
          sear_disk_subtract_2d();
     };
     translate(sc_offset) {
          sear_catch_subtract_2d();
     };
     translate(tg_offset) {
          trigger_2d_subtract();
     };
};

module receiver_footprint() {
     rectangle(rc_fx, rc_fy, rc_rx, rc_ry);
};

module receiver_plate(thickness=0) {
     plate_thickness = (thickness <= 0) ? rc_wall : thickness;
     deepify(plate_thickness) {
          difference() {
               receiver_footprint();
               receiver_pin_cutouts();
          };
     };
};
module remove_from_sides() {
     union() {
          cylinderExterior();
          translate([-.1,0,0]) {
               receiver_front_cylinder_holder();
          };
          translate([.1,0,0]) {
               receiver_rear_cylinder_holder();
          };
          cylinderAround(cy_or+$iota, L=rc_rt, O=[rc_rx, cy_origin[1], cy_origin[2]], A=cy_orientation, IR=cy_or);
          cylinderAround(cy_or+$iota, L=rc_rt, O=[rc_fx, cy_origin[1], cy_origin[2]], A=cy_orientation, IR=cy_or);
          receiver_front_cylinder_holder();
          receiver_rear_cylinder_holder();
     };
};

module receiver_spring_blocks() {
     deepify(rc_inner_gap) {
          arc(rc_sds_or, rc_sds_ta, rc_sds_sa, IR=rc_sds_ir); // spring for sear disk
          arc(rc_scs_or, rc_scs_ta, rc_scs_sa, IR=rc_scs_ir, X=sc_aax, Y=sc_aay); // spring for sear catch
          arc(rc_tgs_ogr, rc_tgs_ta, rc_tgs_sa, IR=rc_tgs_igr, X=tg_aax, Y=tg_aay); // spring for trigger
     };
};

module receiver_axle_pins() {
     deepify(rc_inner_gap) {
          translate(sd_offset) {
               sear_disk_axle_2d();
          };
          translate(sc_offset) {
               sear_catch_axle_2d();
          };
          translate(tg_offset) {
               trigger_axle_2d();
          };
     };
};

module receiver_right_side() {
     difference() {
          union() {
               translate(-1*rc_offset) {
                    receiver_plate();
               };
               receiver_spring_blocks();
          };
          remove_from_sides();
     };
};

module receiver_left_side() {
     difference() {
          union() {
               translate(rc_offset) {
                    receiver_plate();
               };
          };
          remove_from_sides();
     };
};

module receiver_front_cylinder_holder() {
     intersection() {
          difference() {
               union() {
                    receiver_plate(thickness=rc_inner_gap);
                    rc_cy_origin = [0, cy_origin[1], cy_origin[2]];
                    cylinderAround(cy_or+rc_wall, L=rc_rt, O=rc_cy_origin + [rc_fx+rc_rt/2, 0, 0], A=cy_orientation, IR=cy_or);
               };
               cylinderExterior();
          };
          deepify(10){
               rectangle(rc_fx-1/2, -100, rc_fx+1/2, 100);
          };
     };

};

module receiver_rear_cylinder_holder() {
     intersection() {
          difference() {
               union() {
                    receiver_plate(thickness=rc_inner_gap);
                    cylinderAround(cy_or+rc_wall, L=rc_rt, O=[rc_rx-rc_rt/2, cy_origin[1], cy_origin[2]], A=cy_orientation, IR=cy_or);
               };
               cylinderExterior();
          };
          deepify(10){
               rectangle(rc_rx-1/2, -100, rc_rx+1/2, 100);
          };
     };

};

/* color(rc_color[0], rc_color[1]) { */
/* /\* receiver_right_side(); *\/ */
/* /\* receiver_left_side(); *\/ */
/* /\* receiver_front_cylinder_holder(); *\/ */
/* /\* receiver_rear_cylinder_holder(); *\/ */
/* }; */
