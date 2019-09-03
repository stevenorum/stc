use <../../functions.scad>;
include <../dimensions.scad>;

module sear_disk_add_2d() {
     difference() {
     union() {
          arcs(
               [
                    [sd_ir, sd_fa],
                    [sd_or, sd_fta],
                    [sd_or, sd_sa],
                    [sd_or, sd_spa],
                    [sd_or, sd_pa],
                    [sd_cr, sd_pca],
                    [sd_or, sd_ca]
                    ]
               );
          circleXY(sd_aor);
     };
     union() {
          arc(sds_or, sds_ta, sds_sa, IR=sds_ir);
     };
     };
}

module sear_disk_subtract_2d() {
     circleXY(sd_ar);
}

module sear_disk_axle_2d() {
     circleXY(sd_ar-$iota);
}

module sear_disk_2d() {
     rotate(sd_rotation) {
          difference() {
               sear_disk_add_2d();
               sear_disk_subtract_2d();
          };
     };
};

module sear_disk_3d_raw() {
     deepify(sd_thickness) {
          sear_disk_2d();
     };
};

module sear_disk_3d() {
     translate(sd_offset) {
          sear_disk_3d_raw();
     };
};
