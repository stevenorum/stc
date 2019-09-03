use <../../functions.scad>;
include <../dimensions.scad>;

module cylinderExterior() {
     translate(cy_translate) {
          cylinderAround(cy_or, L=cy_length + 2, O=cy_origin, A=cy_orientation);
     };
};

module cylinder_interior_3d() {
     translate(cy_translate) {
          cylinderAround(cy_ir, L=cy_length+$iota, O=cy_origin, A=cy_orientation);
     };
};

module cylinder_exterior_3d() {
     translate(cy_translate) {
          cylinderAround(cy_or, L=cy_length, O=cy_origin, IR=cy_ir, A=cy_orientation);
     };
};

module cylinder_test_exterior_3d() {
     translate(cy_translate) {
          cylinderAround(cy_or, L=cy_length, O=cy_origin, IR=cy_ir, A=cy_orientation);
     };
};
