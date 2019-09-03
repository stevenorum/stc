// This is the conversion between mm and whatever unit we want to use.
// Default is inches because that's what I've been using for the nerf gun I'm working on.
//$fn = 48;
$UNIT = 25.4;
$PI = 3.14159;

module warn(s) {
     echo(str("<h1 style='color:red'>", s, "</h1>"));
     // Using the undefined variable 'bar' triggers a warning, which ensures that I look at the console and see the big red message.
     foo = bar;
};

module complainUnless(complaint, assertion) {
     if (!assertion) {
          warn(complaint);
     };
};

module assert(assertion) {
     complainUnless("Assertion failed!", assertion);
};

module rectangle(x1, y1, x2, y2) {
     translate([(x1+x2)/2,(y1+y2)/2,0]) {
          square([abs(x2-x1), abs(y2-y1)], center=true);
     };
};

module rectangleRelative(x1, y1, x2, y2) {
     rectangle(x1, y1, x1+x2, y1+y2);
};

module semicircle(R) {
    intersection() {
        circle(R, center=true);
        translate([R, 0, 0]) {
            square(R*2, center=true);
        };
    };
};

module arc (R, A=360, O=0, X=0, Y=0, IR=0) {
     // Creates the arc starting on the Y axis and rotating clockwise.
     // O is the offset angle of the start, going clockwise.
     //direction = A >= 0 ? -1 : 1;
     //A = abs(A);
     difference() {
          translate([X, Y, 0]) {
               rotate([0,0,-O + (A >= 0 ? 0 : abs(A))]) {
                    union() {
                         if (A >= 180) {
                              union() {
                                   rotate([0,0,180-abs(A)]) {
                                        semicircle(R);
                                   };
                                   semicircle(R);
                              };
                         };
                         if (A < 180) {
                              intersection() {
                                   rotate([0,0,180-abs(A)]) {
                                        semicircle(R);
                                   };
                                   semicircle(R);
                              };
                         };
                    };
               };
          };
          union() {
               if (IR > 0) {
                    arc(R=IR, A=A+1, O=O-0.5, X=X, Y=Y, IR=0);
               };
          };
     };
};

function lastIndex(v, last=-1) = last < 0 ? (len(v) + last) : last;

function valueAtIndex(v, index) = (index > (len(v) + 1)) ? (v) : (v[index]);

function sumRange(v, first=0, last=-1, index=0) = 0 + ((first >= lastIndex(v, last)) ? 0 : ((valueAtIndex(v[first], index)) + sumRange(v, first=first+1, last=last, index=index)));

module arcs(R_A, X=0, Y=0) {
     union() {
          for (i = [0:len(R_A)]) {
               // The extra logic in here is to have the arcs overlap somewhat to prevent interior seams.
               // In my experience, it's a tossup whether they'll be handled properly (as one continuous piece)
               // or not (as two separate pieces that happen to be distance 0 apart).
               // Even in a single circle of arcs generated with this function without the overlap,
               // sometimes it was correct, and sometimes it wasn't.
               start_offset_angle = (i > 0 && R_A[i][0] <= R_A[i-1][0]) ? (R_A[i-1][1])/2 : 0;
               end_offset_angle = (i < len(R_A)-1 && R_A[i][0] <= R_A[i+1][0]) ? (R_A[i+1][1])/2 : 0;
               start_angle = sumRange(R_A, last=i, index=1) - start_offset_angle;
               segment_angle = R_A[i][1] + start_offset_angle + end_offset_angle;
               arc(R_A[i][0], segment_angle, start_angle, X=X, Y=Y);
          };
     };
};

module circleXY(R, X=0, Y=0, IR=0) {
     difference() {
          translate([X, Y, 0]) {
               circle(R, center=true);
          };
          union() {
               if (IR > 0) {
                    circleXY(R=IR, X=X, Y=Y, IR=0);
               };
          };
     };
};

module circlePolar(R, theta=0, length=0) {
    rotate([0,0,theta]) {
        translate([length, 0, 0]) {
            circle(R, center=true);
        }
    }
}

module rotateAround(A, X=0, Y=0, Z=0, O=[0,0,0]) {
     _O = (X==0 && Y==0 && Z==0) ? O : [X,Y,Z];
     translate(_O) {
          rotate(A) {
               translate([-1*_O[0], -1*_O[1], 1*_O[2]]) {
                    children();
               };
          };
     };
};

module cylinderAround(R, L, O=[0,0,0], IR=-1, A=[0,0,0], R2=-1, IR2=-1) {
     translate(O) {
          rotate(a=A) {
               difference() {
                    union() {
                         if (R2 < 0) {
                              cylinder(h=L, r=R, center=true);
                         };
                         if (R2 >= 0) {
                              cylinder(h=L, r1=R, r2=R2, center=true);
                         };
                    };
                    union() {
                         if (IR >= 0) {
                              // Extend the inner cylinder a bit so that there aren't the weird boundary effects at the end.
                              if (IR2 < 0 || IR2==IR) {
                                   cylinder(h=L*1.1, r=IR, center=true);
                              };
                              if (IR2 >= 0) {
                                   // Because of the sloped interior, need to be a bit smarter than usual about the overextended inner cylinder.
                                   echo(L);
                                   echo(IR);
                                   echo(IR2);
                                   gap = (IR-IR2);
                                   /* cylinder(h=L, r1=IR, r2=IR2, center=true); */
                                   cylinder(h=L*1.002, r1=IR + gap*0.001, r2=IR2 - gap*0.001, center=true);
                              };
                         };
                    };
               };
          };
     };
};

module deepify(thickness) {
     translate([0,0,-thickness/2]) {
          linear_extrude(thickness) {
               children();
          };
     };
};

module lift(z) {
     translate([0, 0, z]) {
          children();
     };
};

module pull(z, liftby=0) {
     lift(liftby) {
          translate([0, 0, z<0 ? z : 0]) {
               linear_extrude(abs(z)) {
                    children();
               };
          };
     };
};

module mirrorAdd(v) {
     children();
     mirror(v=v) children();
};

function concatenate(L1, L2) = [for (i=[0:len(L1)+len(L2)-1]) 
                        i < len(L1)? L1[i] : L2[i-len(L1)]] ;

module sphereXYZ(R, X=0, Y=0, Z=0) {
     translate([X,Y,Z]) {
          sphere(r=R);
     };
};
