use <../../functions.scad>;
include <../dimensions.scad>;

/*
This guy has changed geometry enough since the first draft that I should redo the pieces that contribute to it.
Instead of having a core of two overlapping rectangles, a rectangle, a circle, and an arc should do a better job.
*/

module sear_catch_add_2d() {
     // I know I'm using difference() in something named add,
     // but the point of this method is to give the overall outer border of the object.
     // The subtraction in here is part of that.
     // The stuff down in the subtract method is an interior axle hole.
     difference() {
          union() {
               rectangle(0, 0, sc_ufw, sc_ufh);
               rectangleRelative(0, sc_ufh, sc_ufw-sc_co-sc_co_gap, sc_flh);
               /* rectangleRelative(sc_lfw, sc_ufh-sc_urh, sc_lrw, -sc_lrh); */
               arc(max(sc_ax, sc_ay), 90, 180, X=sc_ax, Y=sc_ay);
               arc(sc_lrh, 85, 105, X=sc_ax, Y=sc_ay);
               /* circleXY(sc_aor, X=sc_ax, Y=sc_ay); */
               circleXY(scs_ir, X=sc_ax, Y=sc_ay);
               arc(scs_or, scs_ta, scs_sa, IR=scs_ir, X=sc_ax, Y=sc_ay);
               // TODO: clean up this logic and refactor out into a function.
               H = scs_ir*1.6;
               A = scs_ir;
               theta = acos(A/H);
               rx = sc_ax-sin(theta)*A;
               ry = sc_ay-cos(theta)*A;
               polygon([
                    [sc_ax, sc_ay],
                    /* [sc_ax-scs_ir, sc_ay], */
                    [rx, ry],
                    [sc_ax, sc_ay-H]
                    ]);
               /* arc(scs_ir, 270, 90, IR=scs_ir, X=sc_ax, Y=sc_ay); */
          };
          union() {
               polygon([[sc_ufw-sc_co-sc_co_gap, sc_ufh],[sc_ufw-sc_co-sc_co_gap, sc_ufh*0.95],[sc_ufw, sc_ufh]]);
               circleXY(sd_cr, X=-1*sc_offset[0], Y=-1*sc_offset[1]);
               x_corn = sc_ufw + sc_offset[0];
               y_corn = sc_ufh - sc_urh + sc_offset[1];
               echo(x_corn);
               echo(y_corn);
               /* exc_angle = atan(x_corn/y_corn); */
               exc_angle = sc_exc_angle;
               exc_radius = sqrt(x_corn*x_corn+y_corn*y_corn);
               arc((exc_radius+sd_or)/2, exc_angle, X=-1*sc_offset[0], Y=-1*sc_offset[1]);
               arc(scs_or, scs_ta, scs_sa, IR=scs_ir, X=sc_ax, Y=sc_ay);
          };
     };
};

module sear_catch_subtract_2d() {
     union() {
          circleXY(sc_ar, X=sc_ax, Y=sc_ay);
     };
};

module sear_catch_axle_2d() {
     union() {
          circleXY(sc_ar-$iota, X=sc_ax, Y=sc_ay);
     };
}

module sear_catch_2d() {
     difference() {
          sear_catch_add_2d();
          sear_catch_subtract_2d();
     };
};

module sear_catch_3d_raw() {
     union() {
          deepify(sd_thickness) {
               sear_catch_2d();
          };
          /* cylinderAround(scs_radius, L=scs_length, O=scs_origin, A=scs_orientation); */
     };
};

module sear_catch_3d() {
     translate(sc_offset) {
          rotateAround(sc_rotation, X=sc_ax, Y=sc_ay) {
               sear_catch_3d_raw();
          };
     };
};
