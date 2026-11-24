// 款式2：鳩尾滑蓋鉛筆盒（蓋子從一端推入，免黏合）
include <common.scad>
part = "scene"; // scene | base | lid
H = 13; SLOT_H = 2.5; CL = 0.25;
OL = IN_L + 2*WALL; OW = IN_W + 2*WALL;
SW_B = IN_W + 3; SW_T = IN_W + 1;   // 鳩尾槽 下寬 / 上寬

module trap(x0, x1, wb, wt, h) hull() {
    translate([x0, -wb/2, 0]) cube([x1-x0, wb, 0.01]);
    translate([x0, -wt/2, h-0.01]) cube([x1-x0, wt, 0.01]);
}
module base() difference() {
    rbox(OL, OW, H, 2);
    translate([0,0,FLOOR]) rbox(IN_L, IN_W, H, 1);
    translate([0,0,H-SLOT_H]) trap(-IN_L/2-1, OL/2+1, SW_B, SW_T, SLOT_H+0.01);
    ruler_pocket(FLOOR - POCKET);
}
module lid() trap(-IN_L/2-1+CL, OL/2, SW_B-2*CL, SW_T-2*CL, SLOT_H-0.15);
module lid_deco() {   // 雙色：浮雕文字 + 推動止滑紋
    translate([-10, 0, SLOT_H-0.16]) linear_extrude(0.6)
        text("FOR YOU ♥", size=9, halign="center", valign="center", font="DejaVu Sans:style=Bold");
    for (i=[0:4]) translate([OL/2-6-i*2.4, -9, SLOT_H-0.16]) cube([1.2, 18, 0.6]);
}

if (part=="base") base();
else if (part=="lid") lid();
else {
    color("#e9c46a") base();
    translate([0,0,FLOOR-POCKET]) ruler();
    translate([75, 0, H-SLOT_H]) { color("#264653") lid(); color("#ffffff") lid_deco(); }
}
