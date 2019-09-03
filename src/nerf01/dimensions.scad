use <nerf_functions.scad>;

$fn=96;

$iota = .01;
inch = 1;
mm = 1/25.4;
charged = true;
$charged = true;
$charged = false;
//$charged = ($t % 2 == 0);

cs_ors = (7/32)/2; // smaller compression spring outer radius
cs_irs = (5/32)/2; // smaller compression spring inner radius
cs_ls_short = 11/16; // also have the same diameter in 1 1/2 inch length
cs_ls_long = 1.5;
cs_orl = (1/4)/2; // larger compression spring outer radius
cs_irl = (3/16)/2; // larger compression spring inner radius
cs_ll = 13/32;
cs_thickness = 1/32;

// Sear disk dimensions
// sd_???
// radii (sd_?r)
sd_or = 0.6; // face outer radius
sd_ir = 0.4; // face inner radius
/* sd_ar = 0.0775/2; // axle radius */
// sd_ar = (2.5/25.4)/2; // axle radius
sd_ar = .125/2; // axle radius
// dependent
sd_pr = sd_or*1.5; // pushrod radius
sd_cr = sd_ir/1.25; // catch radius
sd_sr = sd_pr; // spring radius
// angles (sd_?a)
// Order (clockwise from top): fa, fta, sa, spa, pa, pca, ca
sd_fa = acos(sd_ir/sd_or); // face angle
sd_pa = 55; // pushrod angle
sd_ca = 85; // catch angle
// dependent
sd_fta = 120 - sd_fa; // face trailing angle
sd_sa = 15; // spring angle
sd_spa = 180-(sd_fa+sd_fta+sd_sa); // spring-to-pushrod angle
sd_pca = 180-(sd_ca+sd_pa); // pushrod-to-catch angle

sd_aor = sd_ar*3;

sds_sa = 90;
sds_ta = 120;
sds_ir = sd_cr-cs_ors;
sds_or = sds_ir+2*cs_ors+$iota;

rc_sds_sa = 140;
rc_sds_ta = 20;
rc_sds_ir = sds_ir + $iota;
rc_sds_or = sds_or - $iota;

complainUnless("The sear disk angles do not add up to 360!!1!", (sd_fa+sd_fta+sd_sa+sd_spa+sd_pa+sd_pca+sd_ca) == 360);

sd_rotation = [0, 0, $charged ? 0 : sd_fa];
sd_thickness = 0.25;
sd_offset = [0,0,0];

rc_inner_gap = sd_thickness + $iota;

rc_wall = 0.15;
rc_offset = [0,0,(rc_wall+sd_thickness)/2];
rc_fx = -3;
rc_fy = -1.5;
rc_rx = 1.5;
rc_ry = 0.5;
rc_rt = 1;

rc_sr = 1/16;

// BARREL
// Not going to be printed, but need dimensions for sizing the printed parts.
// These measurements are for the carbon-fiber barrel.
br_or = 16*mm/2; // barrel outer radius, measured
br_ir = 13*mm/2; // barrel inner radius, measured
br_length = 16; // I think I have 18 or 20 inches of CF tube.  This number is guaranteed to change.

// SPRING
// Not going to be printed.  This is an AR buffer spring.
sp_or = 1/2;
sp_ir = 0.75/2;

// CYLINDER
// Not going to be printed, but need dimensions for sizing the printed parts.
/* cy_or = .83; // cylinder outer radius, canonical */
/* cy_wt = .14; // cylinder wall thickness, canonical */
/* cy_ir = cy_or - cy_wt; // cylinder inner radius */
/* cy_or = 1.665/2; // cylinder outer radius, measured, 1 1/4 pvc */
/* cy_ir = 1.365/2; // cylinder inner radius, measured, 1 1/4 pvc */
cy_or = 1.905/2 + $iota; // cylinder outer radius, measured, 1 1/2 pvc
cy_ir = 1.595/2; // cylinder inner radius, measured, 1 1/2 pvc
cy_wt = cy_or-cy_ir; // cylinder wall thickness
cy_length = 9;
cy_rside = 2;
cy_lshift = cy_length/2 - cy_rside;
cy_orientation = [0,90,0];
cy_origin = [0, cy_ir + sd_ir, 0];
cy_translate = [-cy_lshift, 0, 0];


// Sear catch dimensions
// sc_???
sc_ufh = sd_or; // upper front height
sc_lfh = sd_or*0.8; // lower front height
sc_urh = sd_or*0.75; // upper rear height
sc_lrh = sc_ufh + sc_lfh - sc_urh; // lower rear height
sc_lfw = sd_or*0.3; // lower front width
sc_lrw = sd_or*0.4; // lower rear width
sc_ufw = sd_or*0.5; // upper front width
sc_urw = sd_or*0.2; // upper rear width
sc_ar = sd_ar; // axle radius
sc_ah = sc_urw + sc_ar; // axle horizontal offset
sc_av = sc_ufh - sc_urh; // axle vertical offset
sc_co = sc_ufw/3; // catch overlap - how much of the catch contacts the sear disk.
sc_co_gap = sc_ufw/3; // catch overlap gap - how much of a gap is there between the sear disk and the wall at the front of the catch
sc_flh = sc_co; // front lip height - bump up in front of the sear catch
/* sc_ax = sc_ufw * 2 / 3; // (relative) axle x coordinate */
/* sc_ay = sc_ufh  / 3; // (relative) axle y coordinate */
sc_ax = sc_lfw + sc_lrw - sc_ah; // (relative) axle x coordinate
sc_ay = sc_ufh - sc_urh - sc_av; // (relative) axle y coordinate
sc_aor = sc_ar*3;
sc_exc_angle = sd_fa+sd_fta+sd_sa+sd_spa+sd_pa+sd_pca/4;

scs_radius = cs_irs;
scs_orientation = [0,90,0];
scs_length = cs_ls_short/4;
scs_origin = [sc_lfw+sc_lrw, -sc_lrh+(cs_ors+cs_thickness)*2, 0];
sc_offset = [-(sd_or + sc_ufw - sc_co),-sc_ufh,0];
sc_rotation = $charged ? 0 : 10;
sc_aax = sc_ax + sc_offset[0];
sc_aay = sc_ay + sc_offset[1];

// Floating-point numbers are annoying to compare.
complainUnless("Front and rear heights of the sear catch do not match!!1!",abs(sc_ufh+sc_lfh - (sc_lrh+sc_urh))<0.0001);

scs_or = sc_lrh-cs_ors;
scs_ir = sc_lrh-3*cs_ors - $iota;
scs_sa = 115;
scs_ta = 60;
rc_scs_or = scs_or - $iota;
rc_scs_ir = scs_ir + $iota;
rc_scs_sa = scs_sa + 5;
rc_scs_ta = 10;


// Safety rod dimensions
// sr_???
sr_or = sc_co * 2.1; // safety rod outer radius
sr_length = sd_thickness + rc_wall*2;
sr_offset = [sc_offset[0]-sr_or, -1*sr_or, 0];
sr_rotation = [0, 0, $charged ? 0 : -90];
sr_hr = 1.1*sr_or; // safety handle radius
sr_hl = 3*sr_or; // safety handle length
sr_ht = sd_thickness; // safety handle thickness

// plunger dimensions
// ph_??
ph_ot = 0.11; // o-ring thickness
ph_ol = 0.1; // o-ring groove length
ph_od = 3*ph_ol/4; // o-ring groove depth
ph_margin = ph_ot-ph_od; // gap between cylinder wall and plunger
ph_catch_margin = .01;
ph_fl = sd_ir * 2 * sin(sd_fa/2); // plunger head front length
ph_ft = ph_fl; // face thickness
ph_ffl = ph_ft;
ph_frl = ph_fl-ph_ffl;
ph_ml = sd_or * sin(sd_fa) * 2; // middle length
ph_rl = sd_ir * 2 * sin(sd_fa/2); // rear length
ph_tl = ph_ml; // tail length
ph_fr = cy_ir - ph_margin; // front radius
plunger_outer_radius_front = cy_ir - ph_margin;
plunger_inner_radius_front = plunger_outer_radius_front - 5*mm;

ph_mr = cy_ir - ph_catch_margin - (sd_or-sd_ir); // middle radius
ph_rr = cy_ir - ph_margin; // rear radius
ph_ir = sp_or; // inner radius - this is currently perfect
ph_tr = ph_ir+0.1; // tail radius

ph_offset = [-(ph_fl + ph_ml) + ($charged ? 0 : -ph_rl), 0, 0];

ph_ffo = cy_origin + [ph_ffl/2,0,0];
ph_fro = ph_ffo + [(ph_ffl+ph_frl)/2,0,0];
ph_mo = ph_fro + [(ph_frl+ph_ml)/2,0,0];
ph_ro = ph_mo + [(ph_ml)/2 + ph_rl/2,0,0];
ph_to = ph_ro + [(ph_rl)/2 + ph_tl/2,0,0];


// bolt dimensions
// bh_??
bh_ot_cy = ph_ot; // o-ring thickness
bh_ol_cy = ph_ol; // o-ring groove length
bh_od_cy = ph_od; // o-ring groove depth
bh_margin = ph_margin;
bh_or_cy = ph_fr; // outer radius, cylinder section
bh_or_ch = 5/16; // outer radius, chamber section
bh_wall_thickness = .1;
bh_ir = bh_or_ch - bh_wall_thickness;
bh_l_ch = 4;
bh_l_cy = 0.75;
bh_o_cy = cy_origin + [-1, 0, 0];
bh_o_ch = bh_o_cy + [-(bh_l_cy+bh_l_ch)/2, 0, 0];
bh_ft_cy = ph_ft;

bh_l_br = 1;
bh_or_br = br_ir - $iota; // OR of the part that goes into the barrel.  I still need to add the oring stuff to this part.
bolt_outer_radius_barrel = 12*mm/2;
bolt_oring_radius_barrel = 10.5*mm/2;
bolt_oring_length_barrel = 1.5*mm;
bolt_inner_radius_barrel = 8*mm/2;

bh_ir_br = bh_or_br*0.75;
bh_o_br = bh_o_ch + [-(bh_l_ch+bh_l_br)/2, 0, 0];

bolt_handle_diameter = 0;
bolt_handle_radius = bolt_handle_diameter/2;
bolt_handle_length = 1;
bolt_handle_bend_angle = 60;
bolt_handle_bend_length = 0.5;
bolt_handle_ball_radius = 0.35;

bh_offset = [ph_offset[0] + ($charged ? 0.5 : -(bh_l_ch + bh_l_br)+1), 0, 0];




// trigger dimensions
// tg_???

/* tg_tl = sc_ufh + sc_lfh; */
tg_tl = (sc_urh + sc_lrh + 0.1)/2;
tg_tw = 0.3;

tg_bl = 0.3;
tg_bh = 0.2;

tg_ar = sd_ar;
tg_ax = tg_tw/2;
tg_ay = -tg_tl/4;

tg_aor = tg_ar*3; // trigger axle outer radius

tg_pd = 2*tg_tw; // trigger pull depth (how wide the trigger itself is, not the trigger pull distance)
tg_ph = 1.25; // trigger pull height (how tall the visible part of the trigger is)
tg_cr = 1; // trigger curvature radius
tg_cd = tg_pd/2; // trigger curvature depth

tg_sf = 0.5;
tg_sh = abs(tg_ay) * 2;

tgs_or = 1;
tgs_ogr = tgs_or - cs_ors;
tgs_igr = tgs_ogr - 2*cs_ors - $iota;
tgs_sa = 240;
tgs_ta = 90;

tgs_la = 15;
tga_ta = 15;

rc_tgs_sa = tgs_sa + tgs_la + 10;
rc_tgs_ta = 10;
rc_tgs_ogr = tgs_ogr - $iota;
rc_tgs_igr = tgs_igr + $iota;

tg_offset = [sc_offset[0] - tg_bl - tg_tw + sc_lfw, -tg_tl, 0];
tg_rotation = [0, 0, $charged ? -5 : 10];

tg_aax = tg_offset[0] + tg_ax;
tg_aay = tg_offset[1] + tg_ay;

// receiver dimensions
// rc_???

magwell_hole_length = 3.2;
magwell_hole_width = 1.0;
magwell_sidewall_thickness = 0.15;
magwell_width = magwell_hole_width + 2*magwell_sidewall_thickness;
magwell_rear_assembly_length = 0.5; // Contains the mag-hold catch and the release button, for example.
magwell_length = magwell_hole_length + magwell_sidewall_thickness + magwell_rear_assembly_length;

// bottom should be 3.3 inches below the line of the bolt
magwell_height = 3.3 - cy_origin[1];
/* magwell_height = 2; */

magwell_offset = [cy_translate[0]-cy_length/2-magwell_length,-magwell_height,0];


barrel_feed_diameter = 0;
barrel_feed_length = 0;









searOR = 0.5;
searCatchHeight = .1;
searIR = searOR - searCatchHeight;
searCatchAngle = acos(searIR/searOR);
searDiskThickness = 0.25;
searAR = 0.05;

searDiskPushrodAngle = 15;
searDiskPushrodLength = searOR*1.75;

cylinderOR = 0.83;
cylinderWall = 0.14;
cylinderIR = cylinderOR - cylinderWall;

plungerWallGap = 0.02;
plungerWallThickness = 0.1;
plungerSegmentLength = searIR * 2 * sin(searCatchAngle/2);
plungerMiddleSegmentLength = searOR * sin(searCatchAngle);
plungerOR = cylinderIR - plungerWallGap;
plungerMR = plungerOR - searCatchHeight;
plungerIR = plungerMR - plungerWallThickness;

searCatchPivot = [-searIR, -searOR];

triggerPivot = [];


receiverWallThickness = .25;
cylinderOrientation = [0,90,0];
cylinderOrigin = [0, cylinderIR + searIR, 0];
triggerOrigin = [-2, -1.25, 0];
tailPlungerSegmentOrigin = cylinderOrigin + [3*plungerSegmentLength/2,0,0];
rearPlungerSegmentOrigin = cylinderOrigin + [plungerSegmentLength/2,0,0];
middlePlungerSegmentOrigin = cylinderOrigin-[plungerMiddleSegmentLength/2,0,0];
frontPlungerSegmentOrigin = cylinderOrigin-[plungerMiddleSegmentLength+plungerSegmentLength/2,0,0];


triggerCatchAngle = charged ? 0 : 13;
plungerDirection = $charged ? 0 : -1;
safetyPosition = charged ? searDiskThickness*1.5 : 0;
triggerChargeOffset = charged ? [0,0,0] : [.1,0,0];

triggerOffset = triggerOrigin + triggerChargeOffset;
