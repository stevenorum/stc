use <../common/functions.scad>;
include <variables.scad>;

module x_bar_profile() {
     difference() {
          union() {
               rectangleRelative(
                    -1 * (x_bar_height / 2),
                    -1 * (x_bar_width / 2),
                    x_bar_height,
                    x_bar_width
                    );
          };
          union() {
               rectangleRelative(
                    -1 * (x_bar_height / 2),
                    -1 * (x_bar_trough_width / 2),
                    x_bar_trough_depth,
                    x_bar_trough_width
                    );
               rectangleRelative(
                    (x_bar_height / 2),
                    -1 * (x_bar_trough_width / 2),
                    -1 * x_bar_trough_depth,
                    x_bar_trough_width
                    );
               rectangleRelative(
                    -1 * (x_bar_trough_width / 2),
                    -1 * (x_bar_width / 2),
                    x_bar_trough_width,
                    x_bar_trough_depth
                    );
               rectangleRelative(
                    -1 * (x_bar_trough_width / 2),
                    (x_bar_width / 2),
                    x_bar_trough_width,
                    -1 * x_bar_trough_depth
                    );
          };
     };
};

module _heddle(height, width, hole_height, hole_width, thickness=2, bar_width=0, hoffset=0, first=false, last=false, extension=0, bar_thickness=2) {
     bar_height = bar_width > 0 ? bar_width : thickness*4;
     bar_x_offset = hoffset==0 ? (hole_width) : 0;
     translate([hoffset, 0, 0]) {
          pull(bar_thickness) {
               translate([bar_x_offset,(height+bar_height)/2,0]) {
                    square([width*2, bar_height], center=true);
               };
               translate([bar_x_offset,-1*(height+bar_height)/2,0]) {
                    square([width*2, bar_height], center=true);
               };
          };
          difference() {
               pull(thickness) {
                    difference() {
                         union() {
                              square([width, height+bar_height], center=true);
                              translate([bar_x_offset,(height+bar_height)/2,0]) {
                                   square([width*2, bar_height], center=true);
                              };
                              translate([bar_x_offset,-1*(height+bar_height)/2,0]) {
                                   square([width*2, bar_height], center=true);
                              };
                              if (extension > 0) {
                                   translate([0,(height+bar_height)/2+extension/2,0]) {
                                        square([(width-hole_width)/2, bar_width+extension], center=true);
                                        translate([(width+hole_width)/2,0,0]) {
                                             square([(width-hole_width)/2, bar_width+extension], center=true);
                                        };
                                   };

                              };
                         };
                         union() {
                              if (hole_width > 0 && hole_height > 0) {
                                   square([hole_width, hole_height], center=true);
                              };
                         };
                    };
               };
               union() {
                    if (extension>0) {
                         pull(thickness/2) {
                              ext_gap = extension*2/3;
                              translate([bar_x_offset,(height+2*bar_height+ext_gap)/2,0]) {
                                   square([width*2, ext_gap], center=true);
                              };
                         };
                    };
               };
          };
     };
};

module _comb(count, height, dpi, thickness, bar_height, gap_fraction, bar_thickness, ridge_height, ridge_thickness, hole_height) {
     tcount = ((count % 2) == 1) ? (count - 1) : (count);
     mm_per_dent = 25.4 / dpi;
     mm_per_pair = mm_per_dent * 2;
     gap = mm_per_pair / gap_fraction;
     _hole_height = (hole_height > 0) ? (hole_height) : (gap * 4);
     union() {
          for (i = [0:tcount]) {
               if (i%2 == 0) {
                    union() {
                         _heddle(height, gap*(gap_fraction-1), _hole_height, gap, thickness=thickness, hoffset=i/2*mm_per_pair, bar_width=bar_height, bar_thickness=bar_thickness, ridge_height=0, ridge_thickness=0);
                    };
               };
          };
          if (ridge_height>0 && ridge_thickness>0) {
               _comb(count=count, height=height-2*ridge_height, dpi=dpi, thickness=thickness, bar_height=ridge_height, gap_fraction=gap_fraction, bar_thickness=bar_thickness+ridge_thickness, ridge_height=0, ridge_thickness=0, hole_height=hole_height);
          };
     };
}

module heddle(count, height, dpi, thickness=2, bar_height=0, gap_fraction=3, bar_thickness=2, ridge_height=0, ridge_thickness=0) {
     _comb(count=count, height=height, dpi=dpi, thickness=thickness, bar_height=bar_height, gap_fraction=gap_fraction, bar_thickness=bar_thickness, ridge_height=ridge_height, ridge_thickness=ridge_thickness, hole_height=0);
};

module reed(count, height, dpi, thickness=2, bar_height=0, gap_fraction=3, bar_thickness=2, ridge_height=0, ridge_thickness=0) {
     _comb(count=count, height=height, dpi=dpi, thickness=thickness, bar_height=bar_height, gap_fraction=gap_fraction, bar_thickness=bar_thickness, ridge_height=ridge_height, ridge_thickness=ridge_thickness, hole_height=height);
};

module warp_guide(count, height, dpi, thickness=2, bar_height=0, gap_fraction=3, extension=0) {
     tcount = count%2 == 1 ? count-1 : count;
     mm_per_dent = 25.4/dpi;
     mm_per_pair = mm_per_dent * 2;
     gap = mm_per_pair/gap_fraction;
     for (i = [0:tcount]) {
          if (i%2 == 0) {
               union() {
                    _heddle(height, gap*(gap_fraction-1), height, gap, thickness=thickness, hoffset=i/2*mm_per_pair, bar_width=bar_height, extension=extension);
               };
          };
     };
};

module linear_bearing_half() {
     difference() {
          union() {
               // block holding bearing
               pull(linear_bearing_base_height) {
                    rectangleRelative(
                         x1 = -1 * (linear_bearing_base_length / 2),
                         y1 = -1 * (linear_bearing_base_width / 2),
                         x2 = linear_bearing_base_length,
                         y2 = linear_bearing_base_width
                         );
               };
               // screw sleeves to fit into other half
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter - $noz) / 2,
                    L = linear_bearing_base_height,
                    A = bearing_screw_angle,
                    O = [
                         linear_bearing_screw_x_offset,
                         linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter - $noz) / 2,
                    L = linear_bearing_base_height,
                    A = bearing_screw_angle,
                    O = [
                         linear_bearing_screw_x_offset,
                         -1 * linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
          };
          union() {
               // cutout for the bearing itself
               cylinderAround(
                    R = (linear_bearing_od + $noz) / 2,
                    L = linear_bearing_len + $noz,
                    O = linear_bearing_origin,
                    A = bearing_angle
                    );
               // cutout for the axle
               cylinderAround(
                    R = linear_bearing_id / 2,
                    L = linear_bearing_base_length + $overext,
                    O = linear_bearing_origin,
                    A = bearing_angle
                    );
               // cutouts to let the screw sleeves fit in
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter + $noz) / 2,
                    L = linear_bearing_base_height + $overext,
                    A = bearing_screw_angle,
                    O = [
                         -1 * linear_bearing_screw_x_offset,
                         -1 * linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter + $noz) / 2,
                    L = linear_bearing_base_height + $overext,
                    A = bearing_screw_angle,
                    O = [
                         -1 * linear_bearing_screw_x_offset,
                         linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               // cutout for the screws through the extending pegs
               cylinderAround(
                    R = bearing_screw_radius,
                    L = linear_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         linear_bearing_screw_x_offset,
                         linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               cylinderAround(
                    R = bearing_screw_radius,
                    L = linear_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         linear_bearing_screw_x_offset,
                         -1 * linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               // cutout for the screws through the intruding pegs
               cylinderAround(
                    R = bearing_screw_radius,
                    L = linear_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         -1 * linear_bearing_screw_x_offset,
                         linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
               cylinderAround(
                    R = bearing_screw_radius,
                    L = linear_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         -1 * linear_bearing_screw_x_offset,
                         -1 * linear_bearing_screw_y_offset,
                         linear_bearing_base_height
                         ]
                    );
          };
     };
};

module rotary_bearing_half() {
     difference() {
          union() {
               // block holding bearing
               pull(rotary_bearing_base_height) {
                    rectangleRelative(
                         x1 = -1 * (rotary_bearing_base_length / 2),
                         y1 = -1 * (rotary_bearing_base_width / 2),
                         x2 = rotary_bearing_base_length,
                         y2 = rotary_bearing_base_width
                         );
               };
               // screw sleeve to fit into other half
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter - $noz) / 2,
                    L = rotary_bearing_base_height,
                    A = bearing_screw_angle,
                    O = [
                         rotary_bearing_screw_x_offset,
                         rotary_bearing_screw_y_offset,
                         rotary_bearing_base_height
                         ]
                    );
          };
          union() {
               // cutout for the bearing itself
               cylinderAround(
                    R = (rotary_bearing_od + $noz) / 2,
                    L = rotary_bearing_len + $noz,
                    O = rotary_bearing_origin,
                    A = bearing_angle
                    );
               // cutout for the axle
               cylinderAround(
                    R = rotary_bearing_id / 2,
                    L = rotary_bearing_base_length + $overext,
                    O = rotary_bearing_origin,
                    A = bearing_angle
                    );
               // cutout to let the screw sleeve fit in
               cylinderAround(
                    R = (bearing_screw_sleeve_diameter + $noz) / 2,
                    L = rotary_bearing_base_height + $overext,
                    A = bearing_screw_angle,
                    O = [
                         rotary_bearing_screw_x_offset,
                         -1 * rotary_bearing_screw_y_offset,
                         rotary_bearing_base_height
                         ]
                    );
               // cutout for the screw through the extending peg
               cylinderAround(
                    R = bearing_screw_radius,
                    L = rotary_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         rotary_bearing_screw_x_offset,
                         rotary_bearing_screw_y_offset,
                         rotary_bearing_base_height
                         ]
                    );
               // cutout for the screw through the intruding peg
               cylinderAround(
                    R = bearing_screw_radius,
                    L = rotary_bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         rotary_bearing_screw_x_offset,
                         -1 * rotary_bearing_screw_y_offset,
                         rotary_bearing_base_height
                         ]
                    );
          };
     };
};


module connector_end(inside_height) {
     outside_height = inside_height + (2 * (connector_end_bar_height + connector_end_edge_height));
     difference() {
          union() {
               deepify(connector_end_outside_thickness) {
                    rectangleRelative(
                         0,
                         0,
                         connector_end_outside_width,
                         outside_height
                         );
                    rectangleRelative(
                         0,
                         0,
                         connector_end_outside_width,
                         outside_height
                         );
                    rectangleRelative(
                         0,
                         connector_end_edge_height + connector_end_bar_height,
                         connector_end_bar_width + connector_end_outside_width,
                         connector_end_bar_width
                         );
                    rectangleRelative(
                         0,
                         outside_height - (connector_end_bar_height + connector_end_edge_height + connector_end_bar_width),
                         connector_end_bar_width + connector_end_outside_width,
                         connector_end_bar_width
                         );
               };
               deepify(connector_end_bar_thickness) {
                    rectangleRelative(
                         0,
                         connector_end_edge_height,
                         connector_end_bar_width + connector_end_outside_width,
                         connector_end_bar_height + connector_end_bar_width
                         );
                    rectangleRelative(
                         0,
                         outside_height - (connector_end_bar_height + connector_end_edge_height + connector_end_bar_width),
                         connector_end_bar_width + connector_end_outside_width,
                         connector_end_bar_height + connector_end_bar_width
                         );
               };
          };
          union() {
               deepify(connector_end_outside_thickness + $overext) {
                    circleXY(
                         connector_end_bar_width,
                         connector_end_bar_width + connector_end_outside_width,
                         connector_end_bar_height + connector_end_bar_width + connector_end_edge_height
                         );
                    circleXY(
                         connector_end_bar_width,
                         connector_end_bar_width + connector_end_outside_width,
                         outside_height - (connector_end_bar_height + connector_end_bar_width + connector_end_edge_height)
                         );
                    circleXY(
                         connector_end_screw_radius,
                         connector_end_bar_width + connector_end_outside_width - (connector_end_bar_height / 2),
                         connector_end_edge_height + (connector_end_bar_height / 2)
                         );
                    circleXY(
                         connector_end_screw_radius,
                         connector_end_outside_width + connector_end_bar_height,
                         connector_end_edge_height + (connector_end_bar_height / 2)
                         );
                    circleXY(
                         connector_end_screw_radius,
                         connector_end_bar_width + connector_end_outside_width - (connector_end_bar_height / 2),
                         outside_height - (connector_end_edge_height + (connector_end_bar_height / 2))
                         );
                    circleXY(
                         connector_end_screw_radius,
                         connector_end_outside_width + connector_end_bar_height,
                         outside_height - (connector_end_edge_height + (connector_end_bar_height / 2))
                         );
               };
          };
     };
};

module heddle_end() {
     union() {
          connector_end(heddle_end_inside_height);
          translate(
               [
                    -1 * ((linear_bearing_base_width / 2) - $epsilon),
                    linear_bearing_base_length / 2,
                    -1 * (connector_end_outside_thickness / 2)
                    ]
               ) {
               rotateAround(-90, 0, 0, 0) {
                    linear_bearing_half();
               };
          };
          translate(
               [
                    -1 * ((linear_bearing_base_width / 2) - $epsilon),
                    heddle_end_outside_height - (linear_bearing_base_length / 2),
                    -1 * (connector_end_outside_thickness / 2)
                    ]
               ) {
               rotateAround(90, 0, 0, 0) {
                    linear_bearing_half();
               };
          };
     };
};

module reed_end() {
     union() {
          connector_end(reed_end_inside_height);
          translate(
               [
                    //-1 * ((linear_bearing_base_width / 2) - $epsilon + heddle_shaft_support_distance),
                    0,
                    (reed_end_outside_height / 2) + connector_end_outside_thickness - linear_bearing_base_height/2,
                    /* (linear_bearing_base_length / 2) */
                    connector_end_outside_thickness/2
                    /* 0 - (connector_end_outside_thickness / 2) */
                    ]
               ) {
          rotate([90,0,0]) {
               deepify(linear_bearing_base_height) {
                    x1 = $epsilon;
                    x2 = $epsilon;
                    x3 = -1 * (heddle_shaft_support_distance + $epsilon);
                    x4 = -1 * (heddle_shaft_support_distance + $epsilon);
                    y1 = -1 * $epsilon;
                    y4 = -1 * $epsilon;
                    y2 = linear_bearing_base_length-connector_end_outside_thickness;
                    y3 = linear_bearing_base_length-connector_end_outside_thickness;
                    polygon(points = [
                                 [x1, y1],
                                 /* [x2, y2], */
                                 [x3, y3],
                                 [x4, y4],
                                 ]);
               };
          };
          };
          deepify(connector_end_outside_thickness) {
               rectangleRelative(
                    $epsilon,
                    (reed_end_outside_height / 2) + connector_end_outside_thickness,
                    -1 * (heddle_shaft_support_distance + 2*$epsilon),
                    -1 * linear_bearing_base_height
                    );
          };
          translate(
               [
                    -1 * ((linear_bearing_base_width / 2) - $epsilon + heddle_shaft_support_distance),
                    (reed_end_outside_height / 2) + connector_end_outside_thickness,
                    (linear_bearing_base_length / 2) - (connector_end_outside_thickness / 2)
                    ]
               ) {
               rotateAround(-90, 0, 0, 0) {
                    rotate([0, 90, 0]) {
                         linear_bearing_half();
                    };
               };
          };
     };
};

module shuttle() {
     difference() {
          union() {
               deepify(shuttle_height) {
                    rectangleRelative(
                         -1 * (shuttle_length / 2),
                         -1 * (shuttle_width / 2),
                         shuttle_length,
                         shuttle_wall_thickness
                         );
                    rectangleRelative(
                         -1 * (shuttle_length / 2),
                         (shuttle_width / 2) - shuttle_wall_thickness,
                         shuttle_length,
                         shuttle_wall_thickness
                         );
                    // end blocks
                    rectangleRelative(
                         -1 * (shuttle_hole_length / 2 + shuttle_end_length),
                         -1 * (shuttle_width / 2),
                         shuttle_end_length,
                         shuttle_width
                         );
                    rectangleRelative(
                         shuttle_hole_length / 2,
                         -1 * (shuttle_width / 2),
                         shuttle_end_length,
                         shuttle_width
                         );
               };
               /* translate([0,0,0]) { */
               /*      deepify(shuttle_height) { */
               /*           rectangleRelative( */
               /*                0, */
               /*                0, */
               /*                shuttle_width, */
               /*                shuttle_end_length */
               /*                ); */
               /*      }; */
               /* }; */
               /* deepify(shuttle_height) { */
               /*      rectangleRelative( */
               /*           -1 * (shuttle_width / 2), */
               /*           -1 * (shuttle_length / 2), */
               /*           shuttle_width, */
               /*           shuttle_length */
               /*           ); */
               /* }; */
          };
          union() {};
     };
};

module shuttle_cap() {
     difference() {
          union() {
               deepify(shuttle_height) {
                    rectangleRelative(
                         -1 * (shuttle_cap_length / 2),
                         -1 * (shuttle_width / 2),
                         shuttle_cap_length,
                         shuttle_width
                         );
               };
          };
          union() {
               /* pull(shuttle_height) { */
               /*      rectangleRelative( */
               /*           -1 * (shuttle_cap_length / 1.9), */
               /*           -1 * (shuttle_width / 1.9), */
               /*           shuttle_cap_length*1.1, */
               /*           shuttle_width*1.1 */
               /*           ); */
               /* }; */
               deepify(shuttle_latch_body_height) {
                    rectangleRelative(
                         -1 * (shuttle_cap_length / 2),
                         /* -1 * ((shuttle_latch_body_length + shuttle_latch_hook_length) / 2), */
                         -1 * (shuttle_latch_body_width / 2),
                         shuttle_latch_body_length,
                         shuttle_latch_body_width
                         );
               };
               cylinderAround(
                    R = shuttle_latch_hook_width / 1.9,
                    L = shuttle_latch_hook_length + $noz,
                    A = shuttle_arm_angle,
                    O = [
                         -1 * (shuttle_cap_length / 2) + shuttle_latch_body_length + shuttle_latch_hook_length/2,
                         /* (shuttle_latch_body_length)/2, */
                         0,
                         0
                         ]
                    );
          };
     };

};

module shuttle_bobbin() {};

module shuttle_latch_body() {
     difference() {
          union() {
               deepify(shuttle_latch_body_height) {
                    rectangleRelative(
                         -1 * (shuttle_latch_body_length / 2),
                         -1 * (shuttle_latch_body_width / 2),
                         shuttle_latch_body_length,
                         shuttle_latch_body_width
                         );
               };
          };
          union() {
               cylinderAround(
                    R = shuttle_latch_hook_width * $overmult,
                    L = shuttle_latch_hook_length * $overmult,
                    IR = shuttle_latch_hook_width / 2.05,
                    A = shuttle_arm_angle
                    );
               cylinderAround(
                    R = shuttle_arm_od / 2,
                    L = shuttle_latch_body_length / 2,
                    A = shuttle_arm_angle,
                    O = shuttle_latch_body_arm_origin
                    );
               cylinderAround(
                    R = (shuttle_arm_shaft_od + $noz) / 2,
                    L = shuttle_latch_body_length * $overmult,
                    A = shuttle_arm_angle
                    );
          };
     };
};

module shuttle_latch_hook() {
     difference() {
          union() {
               deepify(shuttle_latch_hook_height) {
                    rectangleRelative(
                         -1 * (shuttle_latch_hook_length / 2),
                         -1 * (shuttle_latch_hook_width / 2),
                         shuttle_latch_hook_length,
                         shuttle_latch_hook_width
                         );
               };
          };
          union() {
               cylinderAround(
                    R = shuttle_latch_hook_width * $overmult,
                    L = shuttle_latch_hook_length * $overmult,
                    IR = shuttle_latch_hook_width / 2,
                    A = shuttle_arm_angle
                    );
               cylinderAround(
                    R = shuttle_latch_hook_width * $overmult,
                    L = shuttle_latch_hook_length * $overmult,
                    IR = shuttle_latch_hook_width / 2,
                    A = [0,0,90]
                    );
               cylinderAround(
                    R = shuttle_arm_shaft_od / 2,
                    L = shuttle_latch_hook_length,
                    A = shuttle_arm_angle,
                    O = shuttle_latch_hook_shaft_origin
                    );
               cylinderAround(
                    R = shuttle_arm_shaft_screw_radius,
                    L = shuttle_latch_hook_length * $overmult,
                    A = shuttle_arm_angle,
                    O = shuttle_latch_hook_shaft_origin
                    );
          };
     };

};

module heddle_frame_corner() {};

module heddle_frame_top_left_v1() {
     piece_width = heddle_frame_width;
     piece_length = heddle_end_gap + (2 * heddle_shaft_radius) + heddle_frame_wall_thickness + x_bar_height;
     support_center = [-1 * (((piece_length - x_bar_width) / 2) - heddle_frame_wall_thickness), 0, 0];
     support_diameter = x_bar_width + (2 * heddle_frame_wall_thickness);
     support_height_multiplier = 1;
     support_length = heddle_frame_thickness * (support_height_multiplier + 1);
     difference() {
          union() {
               translate(support_center) {
                    lift(heddle_frame_thickness/2) {
                         pull(-1 * support_length) {
                              square(support_diameter, center=true);
                         };
                    };
               };
               deepify(heddle_frame_thickness) {
                    rectangleRelative(
                         -1 * (piece_length / 2) + support_diameter,
                         -1 * (piece_width / 2),
                         piece_length - (heddle_shaft_radius + heddle_frame_wall_thickness + support_diameter),
                         piece_width
                         );
                    x12 = -1 * (piece_length / 2) + support_diameter;
                    x34 = -1 * (piece_length / 2);
                    y1 = -1 * (piece_width / 2);
                    y2 = 1 * (piece_width / 2);
                    y3 = 1 * (support_diameter / 2);
                    y4 = -1 * (support_diameter / 2);
                    polygon(points = [
                                 [x12, y1],
                                 [x12, y2],
                                 [x34, y3],
                                 [x34, y4],
                                 ]);
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
          union() {
               deepify(support_length * $overmult) {
                    translate(support_center) {
                         x_bar_profile();
                    };
               };
               motor_x_base = -1 * (piece_length / 2) + (2 * heddle_frame_wall_thickness) + x_bar_height + stepper_motor_base_bolt_radius;
               motor_x_back = motor_x_base + (stepper_motor_base_trough_length * (1/4));
               motor_x_front = motor_x_base + (stepper_motor_base_trough_length * (4/4));
               deepify(heddle_frame_thickness * $overmult) {
                    circleXY(stepper_motor_base_bolt_radius, motor_x_back, stepper_motor_base_trough_gap / 2);
                    circleXY(stepper_motor_base_bolt_radius, motor_x_back, -1 * (stepper_motor_base_trough_gap / 2));
                    circleXY(stepper_motor_base_bolt_radius, motor_x_front, stepper_motor_base_trough_gap / 2);
                    circleXY(stepper_motor_base_bolt_radius, motor_x_front, -1 * (stepper_motor_base_trough_gap / 2));
               };
               lift(-1 * (heddle_frame_thickness/2 - stepper_motor_base_nut_thickness)) {
                    pull(-1 * heddle_frame_thickness) {
                         $fn = 6;
                         circleXY(stepper_motor_base_nut_radius, motor_x_back, stepper_motor_base_trough_gap / 2);
                         circleXY(stepper_motor_base_nut_radius, motor_x_back, -1 * (stepper_motor_base_trough_gap / 2));
                         circleXY(stepper_motor_base_nut_radius, motor_x_front, stepper_motor_base_trough_gap / 2);
                         circleXY(stepper_motor_base_nut_radius, motor_x_front, -1 * (stepper_motor_base_trough_gap / 2));
                    };
               };
               for(_offset = [0:support_height_multiplier]) {
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = heddle_frame_wall_thickness + (x_bar_width / 2),
                    A = [0,90,0],
                    O = [-1 * (piece_length / 2), 0, -1 * _offset * heddle_frame_thickness]
                    );
               }
               pull(-1 * heddle_frame_thickness) {
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
     };
};

module heddle_frame_top_left() {
     piece_width = heddle_frame_width;
     piece_length = heddle_frame_length;
     support_center = heddle_frame_support_center;
     support_diameter = x_bar_width + (2 * heddle_frame_wall_thickness);
     support_height_multiplier = 1;
     support_length = heddle_frame_thickness * (support_height_multiplier + 1);
     difference() {
          union() {
               translate(support_center) {
                    lift(heddle_frame_thickness/2) {
                         pull(-1 * support_length) {
                              square(support_diameter, center=true);
                         };
                    };
               };
               cylinderAround(
                    R2 = axle_spacer_radius,
                    R = heddle_frame_thickness/2,
                    L = axle_mount_thickness+axle_spacer_length,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         0]
                    );
               deepify(heddle_frame_thickness) {
                    rectangleRelative(
                         -1 * (piece_length / 2) + support_diameter,
                         -1 * (piece_width / 2),
                         piece_length - (heddle_shaft_radius + heddle_frame_wall_thickness + support_diameter),
                         piece_width
                         );
                    x12 = -1 * (piece_length / 2) + support_diameter;
                    x34 = -1 * (piece_length / 2);
                    y1 = -1 * (piece_width / 2);
                    y2 = 1 * (piece_width / 2);
                    y3 = 1 * ((support_diameter / 2) + heddle_frame_wall_thickness);
                    y4 = -1 * ((support_diameter / 2) + heddle_frame_wall_thickness);
                    polygon(points = [
                                 [x12, y1],
                                 [x12, y2],
                                 [x34, y3],
                                 [x34, y4],
                                 ]);
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
          union() {
               cylinderAround(
                    R = axle_hole_radius,
                    L = axle_mount_thickness*1.01 + axle_spacer_length,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         -1 * ((heddle_frame_thickness / 2) + (axle_mount_height / 2))
                         ]
                    );
               cylinderAround(
                    R = axle_hole_radius,
                    L = axle_mount_thickness*1.01 + axle_spacer_length*5,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         0
                         ]
                    );
               deepify(heddle_frame_thickness * $overmult) {
                    rectangleRelative(
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - (axle_mount_thickness + axle_nut_thickness),
                         -1 * (axle_nut_radius),
                         axle_nut_thickness,
                         axle_nut_radius * 2
                         );
               };

               deepify(support_length * $overmult) {
                    translate(support_center) {
                         x_bar_profile();
                    };
               };
               motor_x_base =
                    -1 * (piece_length / 2)
                    + (2 * heddle_frame_wall_thickness)
                    + x_bar_height
                    + stepper_motor_base_bolt_radius
                    - (x_bar_height + heddle_frame_wall_thickness);
               motor_x_back = motor_x_base + (stepper_motor_base_trough_length * (1/4));
               motor_x_front = motor_x_base + (stepper_motor_base_trough_length * (4/4));
               deepify(heddle_frame_thickness) {
                    circleXY(stepper_motor_base_bolt_radius, motor_x_back, stepper_motor_base_trough_gap / 2);
                    circleXY(stepper_motor_base_bolt_radius, motor_x_back, -1 * (stepper_motor_base_trough_gap / 2));
                    circleXY(stepper_motor_base_bolt_radius, motor_x_front, stepper_motor_base_trough_gap / 2);
                    circleXY(stepper_motor_base_bolt_radius, motor_x_front, -1 * (stepper_motor_base_trough_gap / 2));
               };
               lift(-1 * (heddle_frame_thickness/2 - stepper_motor_base_nut_thickness)) {
                    pull(-1 * stepper_motor_base_nut_thickness*2) {
                         $fn = 6;
                         circleXY(stepper_motor_base_nut_radius, motor_x_back, stepper_motor_base_trough_gap / 2);
                         circleXY(stepper_motor_base_nut_radius, motor_x_back, -1 * (stepper_motor_base_trough_gap / 2));
                         circleXY(stepper_motor_base_nut_radius, motor_x_front, stepper_motor_base_trough_gap / 2);
                         circleXY(stepper_motor_base_nut_radius, motor_x_front, -1 * (stepper_motor_base_trough_gap / 2));
                    };
               };

               for(_offset = [0:support_height_multiplier]) {
                    cylinderAround(
                         R = x_bar_bolt_radius,
                         L = heddle_frame_wall_thickness + (x_bar_width / 2),
                         A = [0,90,0],
                         O = [-1 * (piece_length / 2), 0, -1 * _offset * heddle_frame_thickness]
                         );
               }
               pull(-1 * heddle_frame_thickness) {
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
     };
};
module heddle_frame_top_right() {};

module heddle_frame_mid_left() {};
module heddle_frame_mid_right() {};

module heddle_frame_bottom_left() {
     piece_width = heddle_frame_width;
     piece_length = heddle_frame_length;
     support_center = heddle_frame_support_center;
     support_diameter = x_bar_width + (2 * heddle_frame_wall_thickness);
     support_height_multiplier = 1;
     support_length = heddle_frame_thickness * (support_height_multiplier + 1);
     difference() {
          union() {
               translate(support_center) {
                    lift(heddle_frame_thickness/2) {
                         pull(-1 * support_length) {
                              square(support_diameter, center=true);
                         };
                    };
               };
               cylinderAround(
                    R2 = axle_spacer_radius,
                    R = heddle_frame_thickness/2,
                    L = axle_mount_thickness+axle_spacer_length,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         0]
                    );
               deepify(heddle_frame_thickness) {
                    rectangleRelative(
                         -1 * (piece_length / 2) + support_diameter,
                         -1 * (piece_width / 2),
                         piece_length - (heddle_shaft_radius + heddle_frame_wall_thickness + support_diameter),
                         piece_width
                         );
                    x12 = -1 * (piece_length / 2) + support_diameter;
                    x34 = -1 * (piece_length / 2);
                    y1 = -1 * (piece_width / 2);
                    y2 = 1 * (piece_width / 2);
                    y3 = 1 * ((support_diameter / 2) + heddle_frame_wall_thickness);
                    y4 = -1 * ((support_diameter / 2) + heddle_frame_wall_thickness);
                    polygon(points = [
                                 [x12, y1],
                                 [x12, y2],
                                 [x34, y3],
                                 [x34, y4],
                                 ]);
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius + heddle_frame_wall_thickness,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
          union() {
               cylinderAround(
                    R = axle_hole_radius,
                    L = axle_mount_thickness*1.01 + axle_spacer_length,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         -1 * ((heddle_frame_thickness / 2) + (axle_mount_height / 2))
                         ]
                    );
               cylinderAround(
                    R = axle_hole_radius,
                    L = axle_mount_thickness*1.01 + axle_spacer_length*5,
                    A = [0,90,0],
                    O = [
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - axle_mount_thickness/2 + axle_spacer_length/2,
                         0,
                         0
                         ]
                    );
               deepify(heddle_frame_thickness * $overmult) {
                    rectangleRelative(
                         (piece_length / 2) - (heddle_frame_wall_thickness + heddle_shaft_radius) - (axle_mount_thickness + axle_nut_thickness),
                         -1 * (axle_nut_radius),
                         axle_nut_thickness,
                         axle_nut_radius * 2
                         );
               };

               deepify(support_length * $overmult) {
                    translate(support_center) {
                         x_bar_profile();
                    };
               };

               for(_offset = [0:support_height_multiplier]) {
                    cylinderAround(
                         R = x_bar_bolt_radius,
                         L = heddle_frame_wall_thickness + (x_bar_width / 2),
                         A = [0,90,0],
                         O = [-1 * (piece_length / 2), 0, -1 * _offset * heddle_frame_thickness]
                         );
               }
               pull(-1 * heddle_frame_thickness) {
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         (heddle_gap_width / 2)
                         );
                    circleXY(
                         heddle_shaft_radius,
                         (piece_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness),
                         -1 * (heddle_gap_width / 2)
                         );
               };
          };
     };
};
module heddle_frame_bottom_right() {};

module shuttle_arm_mount_left() {};
module shuttle_arm_mount_right() {};

module near_beam_frame_left() {

};

module near_beam_frame_right() {};

module beam_motor_mount() {
     piece_width = beam_top_width;
     piece_length = beam_top_length;
     support_center = [0,0,0];
     support_diameter = beam_top_support_diameter;
     support_length = beam_top_support_length;
     difference() {
          union() {
               translate(support_center) {
                    pull(-1 * support_length) {
                         square(support_diameter, center=true);
                    };
               };
               pull(beam_top_thickness) {
                    square([beam_top_length, beam_top_width], center=true);
               };
          };
          union() {
               deepify(support_length * $overmult) {
                    translate(support_center) {
                         x_bar_profile();
                    };
               };
               motor_bolt_y = 15;
               motor_bolt_x_back = -15;
               motor_bolt_x_front = 15;
               motor_bolt_coordinates = [
                    [motor_bolt_x_back, motor_bolt_y],
                    [motor_bolt_x_back, -1*motor_bolt_y],
                    [motor_bolt_x_front, motor_bolt_y],
                    [motor_bolt_x_front, -1*motor_bolt_y],
                    ];
               for (i = [0:3]) {
                    deepify(heddle_frame_thickness) {
                         circleXY(stepper_motor_base_bolt_radius, motor_bolt_coordinates[i][0], motor_bolt_coordinates[i][1]);
                    };
                    lift(-1 * (beam_top_thickness/2 - stepper_motor_base_nut_thickness)) {
                    pull(-1 * stepper_motor_base_nut_thickness*2) {
                         $fn = 6;
                         circleXY(stepper_motor_base_nut_radius, motor_bolt_coordinates[i][0], motor_bolt_coordinates[i][1]);
                    };
               };
               };
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = max(beam_top_length, beam_top_width),
                    A = [0,90,0],
                    O = [0, 0, -1 * beam_top_support_length/2]
                    );
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = max(beam_top_length, beam_top_width),
                    A = [0,90,90],
                    O = [0, 0, -1 * beam_top_support_length/2]
                    );
          };
     };
};

module beam_top_axle_mount() {
     piece_width = beam_top_width;
     piece_length = beam_top_length;
     support_center = [0,0,0];
     support_diameter = beam_top_support_diameter;
     support_length = beam_top_support_length;
     axle_height = 30;
     base_thickness = 3;
     difference() {
          union() {
               pull(base_thickness) {
                    square([beam_top_length, beam_top_width], center=true);
               };
               
               lift(axle_height - rotary_bearing_base_height) {
                    rotary_bearing_half();
               }
               pull(axle_height - rotary_bearing_base_height + bearing_case_thickness - $noz) {
                    square([rotary_bearing_base_length,rotary_bearing_od], center=true);
               };

               rotateAround(A=[90,0,0], O=[0,0,0]) {
                    deepify(base_thickness) {
                         polygon(points=[
                                      [0,axle_height - rotary_bearing_od/2 - $noz],
                                      [0,(axle_height)/2],
                                      [beam_top_length/2,base_thickness],
                                      [beam_top_length/2,0],
                                      [-1*beam_top_length/2,0],
                                      [-1*beam_top_length/2,base_thickness]
                                      ]);
                    };
               };
          };
          union() {
               motor_bolt_y = 15;
               motor_bolt_x_back = -15;
               motor_bolt_x_front = 15;
               motor_bolt_coordinates = [
                    [motor_bolt_x_back, motor_bolt_y],
                    [motor_bolt_x_back, -1*motor_bolt_y],
                    [motor_bolt_x_front, motor_bolt_y],
                    [motor_bolt_x_front, -1*motor_bolt_y],
                    ];
               deepify(heddle_frame_thickness) {
                    for (i = [0:3]) {
                         circleXY(stepper_motor_base_bolt_radius, motor_bolt_coordinates[i][0], motor_bolt_coordinates[i][1]);
                    };
               };
          };
     };
};

module beam_dual_mount() {
};

module custom_rotary_bearing_half(bearing_od=16, bearing_id=10, bearing_len=5, min_center_height=0, min_screw_gap=0) {
     case_thickness = 3;
     screw_diameter = 3;
     screw_radius = screw_diameter/2;
     screw_sleeve_diameter = screw_diameter + case_thickness;
     bearing_base_height = max((bearing_od / 2) + case_thickness, min_center_height);
     bearing_base_length = bearing_len + (2 * case_thickness);
     bearing_base_width = max(bearing_od + (6 * case_thickness), min_screw_gap + screw_sleeve_diameter * (4 / 3));
     screw_y_offset = (bearing_base_width / 2) - screw_sleeve_diameter * (2 / 3);
     screw_sleeve_length = min(bearing_base_height/2, ((bearing_od / 2)+bearing_case_thickness)/2);
     difference() {
          union() {
               // block holding bearing
               pull(bearing_base_height) {
                    square([bearing_base_length, bearing_base_width], center=true);
               };
               // screw sleeve to fit into other half
               cylinderAround(
                    R = (screw_sleeve_diameter - $noz) / 2,
                    L = screw_sleeve_length,
                    A = bearing_screw_angle,
                    O = [
                         0,
                         screw_y_offset,
                         bearing_base_height + screw_sleeve_length/2
                         ]
                    );
          };
          union() {
               // cutout for the bearing itself
               cylinderAround(
                    R = (bearing_od + $noz) / 2,
                    L = bearing_len + $noz,
                    O = [0, 0, bearing_base_height],
                    A = bearing_angle
                    );
               // cutout for the axle
               cylinderAround(
                    R = bearing_id / 2,
                    L = bearing_base_length + $overext,
                    O = [0, 0, bearing_base_height],
                    A = bearing_angle
                    );
               // cutout to let the screw sleeve fit in
               cylinderAround(
                    R = (screw_sleeve_diameter + $noz) / 2,
                    L = bearing_base_height + $overext,
                    A = bearing_screw_angle,
                    O = [
                         0,
                         -1 * screw_y_offset,
                         bearing_base_height
                         ]
                    );
               // cutout for the screw through the extending peg
               cylinderAround(
                    R = screw_radius,
                    L = bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         0,
                         screw_y_offset,
                         bearing_base_height
                         ]
                    );
               // cutout for the screw through the intruding peg
               cylinderAround(
                    R = bearing_screw_radius,
                    L = bearing_base_height * $overmult,
                    A = bearing_screw_angle,
                    O = [
                         0,
                         -1 * screw_y_offset,
                         bearing_base_height
                         ]
                    );
          };
     };
};

module beam_axle_mount() {
     piece_width = beam_top_width;
     piece_length = beam_top_length;
     support_center = [0,0,0];
     support_diameter = beam_top_support_diameter;
     support_length = beam_top_support_length;
     difference() {
          union() {
               translate(support_center) {
                    lift(beam_top_thickness) {
                    pull(-1 * (support_length+beam_top_thickness)) {
                         square(support_diameter, center=true);
                    };
                    };
               };
               pull(beam_top_thickness) {
                    rectangle();
                    square([beam_top_length, beam_top_width], center=true);
               };
               translate([support_diameter/2 + rotary_bearing_base_length/2,0,beam_top_thickness]) {
                    /* rotary_bearing_base_length */
                    rotary_bearing_half();
               };
          };
          union() {
               deepify(support_length * $overmult) {
                    translate(support_center) {
                         x_bar_profile();
                    };
               };
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = max(beam_top_length, beam_top_width),
                    A = [0,90,0],
                    O = [0, 0, -1 * beam_top_support_length/2]
                    );
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = max(beam_top_length, beam_top_width),
                    A = [0,90,90],
                    O = [0, 0, -1 * beam_top_support_length/2]
                    );
          };
     };

};

module far_beam_frame_left() {

};

module far_beam_frame_right() {

};

module motor_base_plate() {
     difference() {
          union() {
               pull(heddle_frame_wall_thickness + stepper_motor_base_nut_thickness) {
                    rectangleRelative(
                         0,
                         -1 * (stepper_motor_base_width/2),
                         stepper_motor_base_length,
                         stepper_motor_base_width
                         );
               };
          };
          union() {
               y_l = -15;
               y_r = 15;
               xs = [11,20,30,40];
               for(_offset = [0:3]) {
                    pull(heddle_frame_wall_thickness + stepper_motor_base_nut_thickness) {
                         circleXY(stepper_motor_base_bolt_radius, xs[_offset], y_l);
                         circleXY(stepper_motor_base_bolt_radius, xs[_offset], y_r);
                    };
                    pull (stepper_motor_base_nut_thickness) {
                         $fn = 6;
                         circleXY(stepper_motor_base_nut_radius, xs[_offset], y_l);
                         circleXY(stepper_motor_base_nut_radius, xs[_offset], y_r);
                    };
               };
          };
     };
};

module beater_frame(include_motor=false, include_axle=false, center_motor=true) {
     support_diameter = x_bar_width + (2 * heddle_frame_wall_thickness);
     support_height_multiplier = 1;
     support_length = 2 * (heddle_shaft_radius + heddle_frame_wall_thickness);
     axle_bump_length = axle_nut_thickness + heddle_frame_wall_thickness;
     difference() {
          union() {
               if (include_motor) {
                    translate(
                         [
                              -1*(support_diameter/2) + heddle_frame_wall_thickness,
                              center_motor ? (-1*(stepper_motor_base_length/2)) : (-1*(stepper_motor_base_length-support_diameter/2)),
                              0
                              ]
                         ) {
                         rotate([-90,0,90]) {
                              difference() {
                                   motor_base_plate();
                                   union() {
                                        nuthole_translation = [
                                             center_motor ? 0 : (stepper_motor_base_length-support_diameter)/2,
                                             0,
                                             0];
                                        translate(nuthole_translation) {
                                        lift(heddle_frame_wall_thickness) {
                                             pull(axle_nut_thickness*5) {
                                                  circleXY(axle_nut_radius, stepper_motor_base_length/2, 0);
                                             };
                                        };
                                        };
                                        if (center_motor) {
                                        pull(heddle_frame_wall_thickness + stepper_motor_base_nut_thickness) {
                                             y_edge = 15-(stepper_motor_base_nut_radius+heddle_frame_wall_thickness);
                                             rectangleRelative(
                                                  0,
                                                  -1 * y_edge,
                                                  (stepper_motor_base_length - support_diameter)/2,
                                                  2 * y_edge
                                                  );
                                             rectangleRelative(
                                                  stepper_motor_base_length,
                                                  -1 * y_edge,
                                                  -1 * (stepper_motor_base_length - support_diameter)/2,
                                                  2 * y_edge
                                                  );
                                        };
                                        };
                                   };
                              };
                         };
                    };
               };
               deepify(support_length) {
                    square(support_diameter, center=true);
               };
               shaft_holder_length = heddle_frame_thickness/2;
               cylinderAround(
                    R = (heddle_frame_wall_thickness + heddle_shaft_radius),
                    IR = heddle_shaft_radius,
                    L = heddle_frame_wall_thickness + shaft_holder_length,
                    A = [0,90,0],
                    O = [
                         (shaft_holder_length / 2) + (support_diameter / 2),
                         0,
                         0
                         ]
                    );
               if (include_axle) {
                    cylinderAround(
                         R = min(axle_nut_radius,heddle_shaft_radius) + heddle_frame_wall_thickness,
                         R2 = axle_bolt_radius * 1.2,
                         IR = axle_bolt_radius,
                         L = heddle_frame_wall_thickness + axle_bump_length,
                         A = [0,-90,90],
                         O = [0,-1*((x_bar_width/2) + (axle_bump_length+heddle_frame_wall_thickness)/2),0]
                         );
               };
          };
          union() {
               deepify(support_length * $overmult) {
                    x_bar_profile();
               };
               if (include_axle) {
                    $fn = 6;
                    cylinderAround(
                         R = axle_nut_radius,
                         L = axle_nut_thickness,
                         A = [0,-90,90],
                         O = [0,-1*((x_bar_width/2) + (axle_nut_thickness/2) - $epsilon),0]
                         );
               };
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = x_bar_width,
                    A = [0,90,0],
                    O = [-1*(x_bar_width/2),0,0]
                    );
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = x_bar_width,
                    A = [0,90,0],
                    O = [-1*(x_bar_width*(2/3)),0,0]
                    );
               cylinderAround(
                    R = x_bar_bolt_radius,
                    L = 2 * (heddle_frame_wall_thickness + x_bar_width),
                    A = [0,90,90],
                    O = [0,0,0]
                    );

          };
     };

};
