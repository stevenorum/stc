$fn = 48;
$inch = 25.4;
$noz = 0.4; // Used in determining error margins for parts that fit together.
$epsilon = 0.01; // tiny value to force overlap
$overext = 1; // arbitrary value used to lengthen things being subtracted to make holes completely through other components.  Any positive value works.
$overmult = 3; // arbitrary value used to lengthen things being subtracted to make holes completely through other components.  Any positive value over 2 works.

bearing_case_thickness = 3; // arbitrarily chosen, likely overkill
bearing_screw_diameter = 3; // m3 bolts because I've got a box lying around
bearing_screw_radius = bearing_screw_diameter / 2;
bearing_nut_thickness = 5; // this is way bigger than necessary, but right now going too high is the safe direction for this.
bearing_screw_sleeve_diameter = bearing_screw_diameter + bearing_case_thickness; // Only gives half the thickness on each side, but that should be plenty.
bearing_angle = [0, 90, 0];
bearing_screw_angle = [0, 0, 0];

rotary_bearing_od = 16;
rotary_bearing_id = 10; // axle is 5mm, but central rotating piece is 9mm, so that plus a safety gap
rotary_bearing_len = 5;

rotary_bearing_base_height = (rotary_bearing_od / 2) + bearing_case_thickness;
rotary_bearing_base_length = rotary_bearing_len + (2 * bearing_case_thickness);
rotary_bearing_base_width = rotary_bearing_od + (6 * bearing_case_thickness);

rotary_bearing_origin = [0, 0, rotary_bearing_base_height];
rotary_bearing_screw_x_offset = 0;
rotary_bearing_screw_y_offset = (rotary_bearing_base_width / 2) - (bearing_screw_sleeve_diameter * (2 / 3));

linear_bearing_od = 15;
linear_bearing_id = 10; // 8mm plus safety gap
linear_bearing_len = 24;

linear_bearing_base_height = (linear_bearing_od / 2) + bearing_case_thickness;
linear_bearing_base_length = linear_bearing_len + (2 * bearing_case_thickness);
linear_bearing_base_width = linear_bearing_od + (6 * bearing_case_thickness);

linear_bearing_origin = [0, 0, linear_bearing_base_height];
linear_bearing_screw_x_offset = (linear_bearing_base_length / 2) - bearing_screw_sleeve_diameter;
linear_bearing_screw_y_offset = (linear_bearing_base_width / 2) - (bearing_screw_sleeve_diameter * (2 / 3));

// w=x
// h=y
// t=z
/* heddle_end_inside_height = 100; */
/* heddle_end_bar_height = 10; */
/* heddle_end_edge_height = 3; */
/* heddle_end_bar_width = $inch; */
/* heddle_end_outside_width = $inch/2; */
/* heddle_end_outside_thickness = 10.5; */
/* heddle_end_bar_thickness = $inch/4; */
/* heddle_end_screw_radius = 1.5; */

connector_end_bar_height = 10;
connector_end_edge_height = 3;
connector_end_bar_width = $inch;
connector_end_outside_width = $inch/2;
connector_end_outside_thickness = 10.5;
connector_end_bar_thickness = $inch/4;
connector_end_screw_radius = 1.5;

heddle_end_inside_height = 100;
heddle_end_outside_height = heddle_end_inside_height + (2 * (connector_end_bar_height + connector_end_edge_height));
reed_end_inside_height = 50;
reed_end_outside_height = reed_end_inside_height + (2 * (connector_end_bar_height + connector_end_edge_height));

heddle_thickness = 2;
heddle_height = heddle_end_inside_height;
heddle_bar_thickness = connector_end_bar_thickness;
heddle_bar_height = connector_end_bar_height;
heddle_ridge_height = 2;
heddle_ridge_thickness = (connector_end_outside_thickness-heddle_bar_thickness)/2;

reed_thickness = heddle_thickness;
reed_height = reed_end_inside_height;
reed_bar_height = connector_end_bar_height;
reed_bar_thickness = connector_end_bar_thickness;
reed_ridge_height = heddle_ridge_height;
reed_ridge_thickness = (connector_end_outside_thickness-reed_bar_thickness)/2;

dpi = 10;
inches = 6;
dents = dpi*inches - 1;

shuttle_hole_length = 4 * $inch;
shuttle_hole_width = 2 * $inch;
shuttle_hole_height = 1 * $inch;
shuttle_wall_thickness = 3;
shuttle_end_length = 1.5 * $inch;
shuttle_cap_length = shuttle_end_length;
shuttle_bubbin_diameter = 3;

shuttle_length = shuttle_hole_length + (2 * shuttle_end_length);
shuttle_width = shuttle_hole_width + (2 * shuttle_wall_thickness);
shuttle_height = shuttle_hole_height + (2 * shuttle_wall_thickness);

shuttle_arm_od = (3/16) * $inch;
shuttle_arm_id = shuttle_arm_od - (2 * (0.014)*$inch);
shuttle_arm_angle = [0, 90, 0];
shuttle_arm_shaft_od = shuttle_arm_id;
shuttle_arm_shaft_screw_od = 2;
shuttle_arm_shaft_screw_radius = shuttle_arm_shaft_screw_od / 2;

shuttle_latch_body_height = shuttle_height / 4;
shuttle_latch_body_width = shuttle_height * (2/3);
shuttle_latch_body_length = shuttle_end_length / 2;
shuttle_latch_body_arm_origin = [(shuttle_latch_body_length / 4), 0, 0];
shuttle_latch_body_shaft_origin = [0, 0, 0];

shuttle_latch_hook_height = shuttle_height / 4;
shuttle_latch_hook_width = shuttle_height * (2/3);
shuttle_latch_hook_length = shuttle_end_length / 4;
shuttle_latch_hook_shaft_origin = [shuttle_wall_thickness, 0, 0];

stepper_motor_base_width = 50;
stepper_motor_base_length = 51;
stepper_motor_base_bolt_radius = 2;
stepper_motor_base_nut_radius = 4;
stepper_motor_base_nut_thickness = 5;
stepper_motor_base_trough_length = 30;
stepper_motor_base_trough_gap = 30;

x_bar_height = 20 + $noz;
x_bar_width = 20 + $noz;
x_bar_diameter = 20 + $noz;
/* x_bar_trough_width = 6; */
/* x_bar_trough_depth = 5 + $noz; */
x_bar_trough_width = 0;
x_bar_trough_depth = 0;

x_bar_bolt_radius = 2.5;

heddle_frame_wall_thickness = 3;
heddle_gap_width = 45;
heddle_travel_height = heddle_end_outside_height + (heddle_height / 2);
heddle_shaft_radius = 4;
heddle_end_gap_v1 = stepper_motor_base_length;
heddle_end_gap = stepper_motor_base_length - (x_bar_height + heddle_frame_wall_thickness);
heddle_frame_thickness = (1/2) * $inch;
heddle_frame_width = max(
     heddle_gap_width + (2 * (heddle_shaft_radius + heddle_frame_wall_thickness)),
     stepper_motor_base_width
     );
heddle_frame_length = heddle_end_gap + (2 * heddle_shaft_radius) + heddle_frame_wall_thickness + x_bar_height;
heddle_frame_support_center = [-1 * (((heddle_frame_length - x_bar_width) / 2) - heddle_frame_wall_thickness), 0, 0];
heddle_shaft_x = (heddle_frame_length / 2) - (heddle_shaft_radius + heddle_frame_wall_thickness);
heddle_shaft_support_distance = heddle_shaft_x - heddle_frame_support_center[0];


beater_frame_width = heddle_frame_width;

axle_hole_radius = 2.5;
axle_mount_height = axle_hole_radius * 6;
axle_mount_width = axle_mount_height;
axle_mount_thickness = axle_hole_radius * 3;
axle_spacer_length = 5;
axle_spacer_radius = 3;
axle_nut_radius = 4.5;
axle_nut_thickness = 4.5;
axle_bolt_radius = 2.5;
axle_spinner_radius = 9.5;

beam_top_wall_thickness = heddle_frame_wall_thickness;
beam_top_support_diameter = x_bar_diameter + 2*beam_top_wall_thickness;
beam_top_length = max(stepper_motor_base_length, beam_top_support_diameter);
beam_top_width = max(stepper_motor_base_width, beam_top_support_diameter);
beam_top_thickness = 1/4 * $inch;
beam_top_support_length = 1 * $inch;
beam_top_axle_z = beam_top_thickness + 30;
