use <../../functions.scad>;
include <../dimensions.scad>;

module trigger_add_2d() {
     difference() {
          union() {
               difference() {
                    rectangleRelative(0, 0, tg_tw, -tg_tl);
                    arc(abs(tg_ax) + abs(tg_ay), 90, X=tg_ax, Y=tg_ay, IR=max(abs(tg_ax),abs(tg_ay)));
               };
               rectangleRelative(tg_tw, -tg_tl, tg_bl, tg_bh);
               rectangleRelative(-tg_pd/2, -tg_tl, tg_pd, -tg_ph);
               polygon([[0,0],[-tg_pd/2, -tg_tl],[0,-tg_tl]]);
               rectangleRelative(0,0,-tg_sf,-tg_sh);
               arc(tgs_or, tgs_ta, tgs_sa, X=tg_ax, Y=tg_ay);
               circleXY(tg_aor, X=tg_ax, Y=tg_ay);
               rectangleRelative(tg_ax, tg_ay, tg_aor, -(tg_tl+tg_ay));
               rectangleRelative(tg_ax, tg_ay, -tg_aor, tg_aor);
          };
          union() {
               /* rectangleRelative(tg_tw, -tg_tl, tg_bl, tg_bh); */
               polygon([
                            [tg_tw+tg_bl,tg_bh/2-tg_tl],
                            [tg_tw+tg_bl,tg_bh-tg_tl],
                            [tg_tw+tg_bl-tg_bh/2,tg_bh-tg_tl]]);
               arc(tg_cr, 90, 45, X=tg_cd-tg_cr-tg_pd/2, Y=-tg_tl-tg_ph/2);
               // round off the corner nearest the sear catch and safety
               arc(tgs_or-cs_ors, tgs_ta-20, tgs_sa+10, IR=tgs_or-3*cs_ors-$iota, X=tg_ax, Y=tg_ay);
          };
     };

};

module trigger_subtract_2d() {
     union(){
          circleXY(tg_ar, X=tg_ax, Y=tg_ay); // pivot axle
     };
};

module trigger_axle_2d() {
     union(){
          circleXY(tg_ar-$iota, X=tg_ax, Y=tg_ay); // pivot axle
     };
}

module trigger_2d() {
     difference() {
          trigger_add_2d();
          trigger_subtract_2d();
     };
};

module trigger_3d_raw() {
     deepify(sd_thickness) {
          trigger_2d();
     };
};

module trigger_3d() {
     translate(tg_offset) {
          rotateAround(tg_rotation, X=tg_ax, Y=tg_ay) {
               trigger_3d_raw();
          };
     };
};
