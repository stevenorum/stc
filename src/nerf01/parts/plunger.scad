use <../../functions.scad>;
include <../dimensions.scad>;

module plunger_3d_raw() {
     difference() {
          union() {
               cylinderAround(ph_fr, L=ph_ffl, O=ph_ffo, A=cy_orientation);
               cylinderAround(ph_mr, L=ph_ml, O=ph_mo, A=cy_orientation, IR=ph_ir);
               cylinderAround(ph_rr, L=ph_rl, O=ph_ro, A=cy_orientation, IR=ph_ir);
               cylinderAround(ph_tr, L=ph_tl, O=ph_to, A=cy_orientation, IR=ph_ir);
          };
          union() {
               cylinderAround(cy_ir, L=ph_ol, O=ph_ffo, A=cy_orientation, IR=ph_fr-ph_od);
               cylinderAround(cy_ir, L=ph_ol, O=ph_ro, A=cy_orientation, IR=ph_fr-ph_od);
          };
     };
};

module plunger_3d() {
     translate(ph_offset) {
          plunger_3d_raw();
     };
};

module plunger_test_3d() {
     length = 3*inch;
     step = inch / 6;
     difference() {
          union() {
               translate([0,0,length/2]) {
                   cylinderAround(plunger_outer_radius_front, L=length, IR=plunger_inner_radius_front);
               };
               translate([0,0,length]) {
                   cylinderAround(plunger_outer_radius_front*1.25, L=inch/8);
               };
          };
          union() {
               porf = plunger_outer_radius_front;
               cylinderAround(porf+$iota, L=1.5*mm, O=[0,0,1*step], IR=porf-3.0*mm);
               cylinderAround(porf+$iota, L=2.0*mm, O=[0,0,2*step], IR=porf-3.0*mm);
               cylinderAround(porf+$iota, L=2.5*mm, O=[0,0,3*step], IR=porf-3.0*mm);
               cylinderAround(porf+$iota, L=3.0*mm, O=[0,0,4*step], IR=porf-3.0*mm);
               cylinderAround(porf+$iota, L=1.5*mm, O=[0,0,5*step], IR=porf-2.5*mm);
               cylinderAround(porf+$iota, L=2.0*mm, O=[0,0,6*step], IR=porf-2.5*mm);
               cylinderAround(porf+$iota, L=2.5*mm, O=[0,0,7*step], IR=porf-2.5*mm);
               cylinderAround(porf+$iota, L=3.0*mm, O=[0,0,8*step], IR=porf-2.5*mm);
               cylinderAround(porf+$iota, L=1.5*mm, O=[0,0,9*step], IR=porf-2.0*mm);
               cylinderAround(porf+$iota, L=2.0*mm, O=[0,0,10*step], IR=porf-2.0*mm);
               cylinderAround(porf+$iota, L=2.5*mm, O=[0,0,11*step], IR=porf-2.0*mm);
               cylinderAround(porf+$iota, L=3.0*mm, O=[0,0,12*step], IR=porf-2.0*mm);
               cylinderAround(porf+$iota, L=1.5*mm, O=[0,0,13*step], IR=porf-1.5*mm);
               cylinderAround(porf+$iota, L=2.0*mm, O=[0,0,14*step], IR=porf-1.5*mm);
               cylinderAround(porf+$iota, L=2.5*mm, O=[0,0,15*step], IR=porf-1.5*mm);
               cylinderAround(porf+$iota, L=3.0*mm, O=[0,0,16*step], IR=porf-1.5*mm);
          };
     };
};
