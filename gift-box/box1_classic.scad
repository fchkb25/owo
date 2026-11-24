// 款式1：經典天地蓋 + 緞帶蝴蝶結
include <common.scad>
part = "scene"; // scene | base | lid | bow
H_BASE = 14; H_LID = 9; CL = 0.3;
OL = IN_L + 2*WALL; OW = IN_W + 2*WALL;          // 底盒外尺寸 180 x 40
LL = OL + 2*CL + 2*WALL; LW = OW + 2*CL + 2*WALL; // 上蓋外尺寸

module base() difference() {
    rbox(OL, OW, H_BASE, 3);
    translate([0,0,FLOOR]) rbox(IN_L, IN_W, H_BASE, 1.5);
    ruler_pocket(FLOOR - POCKET);
}
module lid() {
    difference() {
        rbox(LL, LW, H_LID, 4);
        translate([0,0,-0.01]) rbox(OL+2*CL, OW+2*CL, H_LID-1.6, 3+CL);
    }
}
module ribbon() { // 緞帶（雙色列印：換料或另印黏上）
    translate([0,0,H_LID-0.01]) {
        translate([-LL/2, -6, 0]) cube([LL, 12, 0.8]);
        translate([LL*0.18-6, -LW/2, 0]) cube([12, LW, 0.8]);
    }
    for (s=[-1,1]) translate([s*LL/2,-6,0]) translate([s>0?0:-0.8,0,0]) cube([0.8,12,H_LID]);
}
module bow() { // 蝴蝶結（另印黏上）
    for (a=[-35, 35+180]) rotate([0,0,a]) translate([11,0,4])
        scale([1.6,0.9,0.8]) rotate_extrude($fn=40) translate([6,0]) circle(r=1.8, $fn=20);
    for (a=[-110,-70]) rotate([0,0,a]) translate([0,0,0.5]) hull(){ cylinder(r=2.5,h=1.5); translate([16,0,0]) cylinder(r=3.5,h=1.2);}
    translate([0,0,1]) scale([1,1,0.8]) sphere(r=5);
}

if (part=="base") base();
else if (part=="lid") rotate([180,0,0]) lid();
else if (part=="bow") bow();
else {
    color("#f2dfc0") base();
    translate([0,0,FLOOR-POCKET]) ruler();
    translate([0, LW+18, 0]) {
        color("#2f5d8a") lid();
        color("#c8323c") ribbon();
        translate([LL*0.18, 0, H_LID+0.8]) color("#c8323c") bow();
    }
}
