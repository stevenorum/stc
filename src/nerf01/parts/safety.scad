use <../../functions.scad>;
include <../dimensions.scad>;

module safety_2d() {
     rotate([0,0,180]) {
          difference() {
               circleXY(sr_or);
               rectangle(-sr_or, sc_co*1.1-sr_or, sr_or, -sr_or);
          };
     };
};

module safety_cutout_2d() {
     circleXY(sr_or);
};

module safety_handle_2d() {
     rotate([0,0,-90]) {
     square([2*sr_hr, sr_hl], center=true);
     arc(sr_hr, 180, 90, X=0, Y=-sr_hl/2);
     arc(sr_hr, 180, 270, X=0, Y=sr_hl/2);
     polygon(points = [ [sr_hr, 0], [-sr_hr, 0], [0, -sr_hl] ]);
     };
};

module safety_3d_raw() {
     deepify(sr_length) {
          safety_2d();
     };
     translate([(sr_hl/2+sr_hr-sr_or), 0, sr_length/2]) {
          pull(sr_ht) {
               safety_handle_2d();
          };
     };
};

module safety_3d() {
     translate(sr_offset) {
          rotate(sr_rotation) {
               safety_3d_raw();
          };
     };
};
