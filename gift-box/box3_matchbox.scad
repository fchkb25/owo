// 款式3：火柴盒抽屜式（外套筒 + 抽屜）
include <common.scad>
part = "scene"; // scene | drawer | sleeve
H = 13; CL = 0.3; SW = 1.6;
DL = IN_L + 2*WALL; DW = IN_W + 2*WALL;          // 抽屜外尺寸
SL = DL; SIW = DW + 2*CL; SIH = H + 2*CL;         // 套筒內尺寸

module drawer() {
    difference() {
        rbox(DL, DW, H, 1);
        translate([0,0,FLOOR]) rbox(IN_L, IN_W, H, 1);
        ruler_pocket(FLOOR - POCKET);
    }
    // 拉環
    translate([-DL/2-1.5, 0, H*0.5]) rotate([0,90,0]) scale([1,1.4,1]) rotate_extrude($fn=40) translate([4,0]) circle(r=1.3, $fn=16);
}
module sleeve() difference() {
    translate([-SL/2, 0, 0]) rotate([0,90,0]) rotate([0,0,90])
        linear_extrude(SL) offset(r=1) offset(delta=SW-1) square([SIW, SIH], center=true);
    translate([-SL/2-1, -SIW/2, -SIH/2]) cube([SL+2, SIW, SIH]);
    // 兩端推指半圓
    translate([SL/2, 0, 0]) cylinder(r=9, h=SIH+10, center=true);   // 後端推指凹口
}
module sleeve_deco() { // 頂面刻度 + 文字（雙色）
    z = SIH/2 + SW - 0.01;
    for (i=[0:150]) {
        len = (i%10==0) ? 6 : (i%5==0 ? 4 : 2.5);
        translate([-75+i-0.15, SIW/2+SW-1.5-len, z]) cube([0.3, len, 0.5]);
    }
    translate([0, -6, z]) linear_extrude(0.5)
        text("measure the good times", size=6, halign="center", valign="center", font="DejaVu Serif:style=Bold Italic");
}

if (part=="drawer") drawer();
else if (part=="sleeve") translate([0,0,SIH/2+SW]) rotate([180,0,0]) sleeve();
else {
    translate([-80, 0, 0]) {
        color("#f1faee") drawer();
        translate([0,0,FLOOR-POCKET]) ruler();
    }
    translate([0,0,SIH/2-CL]) { color("#e76f51") sleeve(); color("#264653") sleeve_deco(); }
}
