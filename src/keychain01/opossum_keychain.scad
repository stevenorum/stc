use <../common/functions.scad>;
include <../common/opossum_logo.scad>;
$fn = 96;
thickness = 5;
engraving_depth = 2;
radius = 20;
hole_radius = 2.5;


difference() {
     cylinderAround(radius, thickness);
     union() {
          translate(-1*[radius/15,-2*radius/15,-1*thickness/2 + engraving_depth]) {
          pull(engraving_depth + 1) {
               scale((radius*0.1/35)) {
                    possum();
               };
               /*translate([radius/14,-1*radius/2.5,0]) {
                    text("DRL", font="Squares Bold", valign="center", halign="center", size=14*radius/40);
               };*/
               translate([radius/14,-1*radius/1.75,0]) {
                    text("DR", font="Squares Bold", valign="center", halign="center", size=19*radius/40);
               };
          };
          translate([radius/1.3,-4*radius/15,0]) {
               cylinderAround(hole_radius, thickness*2);
          };
          };
     };
};
