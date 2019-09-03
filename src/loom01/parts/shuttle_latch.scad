include <../variables.scad>;
use <../loom_v1.scad>;

translate([-shuttle_latch_hook_length/2,0,0]) {
     color("red", 1.0) {
         rotate([00,0,0]) {
          shuttle_latch_hook();
             };
     };
};
translate([shuttle_latch_body_length/2,0,0]) {
     color("blue", 1.0) {
          shuttle_latch_body();
     };
};
translate([-shuttle_latch_body_length-shuttle_latch_hook_length-2,0,0]) {
     color("green", 0.5) {
         rotate([0,0,180]) {
          shuttle_cap();
             };
     };
};
