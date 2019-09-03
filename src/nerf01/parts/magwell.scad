use <../../functions.scad>;
include <../dimensions.scad>;

module magwell_3d_raw() {
     difference() {
          union() {
               deepify(magwell_width) {
                    rectangleRelative(0,0,magwell_length, magwell_height);
               };
          };
          union() {
               deepify(magwell_hole_width) {
                    rectangleRelative((magwell_length-(magwell_hole_length+magwell_rear_assembly_length))/2,-$iota,magwell_hole_length, magwell_height + 2*$iota);
               };
          };
     };
};

module magwell_3d() {
     translate(magwell_offset) {
          magwell_3d_raw();
     };
};
