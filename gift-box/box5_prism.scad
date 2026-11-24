// 款式5：三角稜柱筒 + 端蓋
include <common.scad>
part = "scene"; // scene | tube | cap
S = 38;              // 內三角邊長
TL = R_L + 5;        // 內腔長 175
CL = 0.25; CAPD = 8;
module tri(s) polygon([[-s/2,0],[s/2,0],[0,s*sqrt(3)/2]]);
module tri_out(s, w) offset(r=w) tri(s);
module prof(fn) rotate([90,0,90]) linear_extrude(fn) children();   // YZ 剖面沿 X 擠出

module tube() difference() {
    translate([-TL/2-WALL, 0, 0]) prof(TL+WALL) translate([0,WALL]) tri_out(S, WALL);
    translate([-TL/2, 0, 0]) prof(TL+1) translate([0,WALL]) tri(S);
    // 底面直尺凹槽
    translate([-TL/2, -16, WALL-0.6]) cube([TL+1, 32, 1]);
}
module cap() {
    prof(WALL) translate([0,WALL]) tri_out(S, WALL);
    translate([-CAPD, 0, 0]) prof(CAPD+0.01) translate([0,WALL]) difference() {
        offset(delta=-CL) tri(S);
        offset(delta=-CL-1.6) tri(S);
    }
}
module deco() {   // 斜面上的文字（雙色浮雕）
    n = [0, -cos(30), sin(30)];
    m = [0, -S/4, S*sqrt(3)/4 + WALL] + n*WALL*1.0;
    translate(m) rotate([60,0,0]) linear_extrude(0.6)
        text("FOR YOU", size=10, halign="center", valign="center", font="DejaVu Sans:style=Bold");
    for (x=[-70,70]) translate(m + [x,0,0]) rotate([60,0,0]) linear_extrude(0.6)
        text("★", size=9, halign="center", valign="center", font="DejaVu Sans");
}

if (part=="tube") rotate([0,-90,0]) tube();
else if (part=="cap") rotate([0,-90,0]) cap();
else {
    color("#cdb4db") tube();
    color("#6d597a") deco();
    translate([60, 0, WALL+0.4-0.6]) ruler();
    translate([TL/2 + 45 + 20, 0, 0]) color("#6d597a") cap();
}
