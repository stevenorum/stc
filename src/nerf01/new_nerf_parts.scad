use <../functions.scad>;
include <nerf_dimensions.scad>;

module safetyOutline() {
     difference() {
          union() {
               arc(searOR + .25, 90-2*searCatchAngle+30, 2*searCatchAngle);
          };
          union() {
               arc(searIR/1.5, 90-2*searCatchAngle, 2*searCatchAngle);
               arc(searOR, 90, 90);
          };
     };
};

color("orange") { // SAFETY
     translate([0,0,safetyPosition]) {
          difference() {
               deepify(3) {
                    safetyOutline();
               };
               deepify(searDiskThickness*1.2) {
                    difference() {
                         arc(searOR, 360, 2*searCatchAngle-.1);
                    };
               };
          };
     };
};

color("yellow") { // SEAR DISK
     deepify(searDiskThickness) {
          rotateAround(searDiskAngle, 0, 0) {
               difference() {
                    union() {
                         arc(searOR, 80, -80);
                         arc(searOR, searCatchAngle, searCatchAngle);
                         arc(searOR, 90, 95);
                         arc(searIR, -90, 2*searCatchAngle);
                         arc(searIR/1.25, 180, 180);
                         arc(searIR/1.5, 360 );
                    };
                    circle(searAR, $fn=24);
               };
          };
     };
};

color("red") { // SEAR CATCH
     deepify(searDiskThickness) {
          rotateAround(triggerCatchAngle, searCatchPivot[0], searCatchPivot[1]) {
               difference() {
                    union() {
                         rectangle(-searOR*1.4, 0, -searIR, -searOR*1.1);
                         rectangle(-searOR*1.1, -searIR/1.8, -searIR/2, -searOR*2);
                         arc(searOR*1.4+searCatchPivot[0], 90, 180, X=searCatchPivot[0], Y=searCatchPivot[1]);
                    };
                    union() {
                         circleXY(searAR, searCatchPivot[0], searCatchPivot[1]);
                         arc(searIR/1.2, 65, 180);
                    };
               };
          };
     };
};

color("blue") { // PLUNGER
     translate([plungerDirection*plungerSegmentLength,0,0]) {
          difference() {
               union() {
                    cylinderAround(plungerMR, L=plungerSegmentLength, O=tailPlungerSegmentOrigin, A=cylinderOrientation, IR=plungerIR);
                    cylinderAround(plungerOR, L=plungerSegmentLength, O=rearPlungerSegmentOrigin, A=cylinderOrientation, IR=plungerIR);
                    cylinderAround(plungerMR, L=plungerMiddleSegmentLength, O=middlePlungerSegmentOrigin, A=cylinderOrientation, IR=plungerIR);
                    cylinderAround(plungerOR, L=plungerSegmentLength, O=frontPlungerSegmentOrigin, A=cylinderOrientation);
               };
               union() {
                    // O-ring grooves
                    cylinderAround(plungerOR+plungerWallGap, L=2*plungerWallGap, O=rearPlungerSegmentOrigin, A=cylinderOrientation, IR=plungerOR-plungerWallGap);
                    cylinderAround(plungerOR+plungerWallGap, L=2*plungerWallGap, O=frontPlungerSegmentOrigin, A=cylinderOrientation, IR=plungerOR-plungerWallGap);
               };
          };
     };
};

color("purple"){ // TRIGGER
     deepify(searDiskThickness) {
          translate(triggerOffset) {
               union() {
                    difference() {
                         union() {
                              arc(0.5, 180);
                              rectangle(0,-.25,1,.5);
                              rectangle(-1,.25,1,.75);
                              rectangle(0.25, 0, 1.45, .5);
                         };
                         union() {
                              arc(0.4, 360);
                              rectangle(0,0,-2, .4);
                              rectangle(-.75,.525,.75,.65);
                              rectangle(0.5, .25, 1.25, .375);
                         };
                    };
               };
          };
     };
};

receiverWallThickness = .25;
color("black", alpha=0.5) { // RECEIVER
     union() {
          deepify(2) {
               rectangle(-3, cylinderOrigin[1]+cylinderOR, 1.5, cylinderOrigin[1]+cylinderOR+receiverWallThickness);
          };
          difference() {
               deepify(2) {
                    rectangle(1.25, cylinderOrigin[1]-cylinderOR-receiverWallThickness, 1.5, cylinderOrigin[1]+cylinderOR+receiverWallThickness);
                    rectangle(-3, cylinderOrigin[1]-cylinderOR-receiverWallThickness, -2.75, cylinderOrigin[1]+cylinderOR+receiverWallThickness);
               };
               union() {
                    cylinderAround(cylinderOR, L=10, O=cylinderOrigin, IR=cylinderIR, A=cylinderOrientation);
               };
          };
          translate([0,0,searDiskThickness/2 + receiverWallThickness/2]) {
               deepify(receiverWallThickness) {
                    difference() {
                         union() {
                              rectangle(-4, -2, 2, cylinderOrigin[1]-cylinderOR);
                         };
                         union() {
                              // safety hole
                              safetyOutline();
                              // sear disk axle
                              circle(searAR, $fn=24);
                              // sear catch axle
                              circleXY(searAR, searCatchPivot[0], searCatchPivot[1]);
                              translate(triggerOrigin) {
                                   // trigger top guide hole - need to add guide rod
                                   rectangle(-.5,.525,-.25,.65);
                                   rectangle(0.25,.525,.5,.65);
                                   // trigger bottom guide hole - need to add guide rod
                                   rectangle(0.75, .25, 1, .375);
                              };
                         };
                    };
               };
          };
     };
};

// CYLINDER - will actually be PVC.
color("green", alpha=0.2){ // Cylinder interior
     cylinderAround(cylinderIR, L=10, O=cylinderOrigin, A=cylinderOrientation);
};

color("lime", alpha=0.5){ // Cylinder exterior
     cylinderAround(cylinderOR, L=10, O=cylinderOrigin, IR=cylinderIR, A=cylinderOrientation);
};
