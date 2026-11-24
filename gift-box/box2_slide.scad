// 款式2：鳩尾滑蓋鉛筆盒（蓋子從一端推入，免黏合）
include <common.scad>
part = "scene"; // scene | base | lid
H = 13; SLOT_H = 2.5; CL = 0.25;
W2 = 3.2;   // 側壁加厚，鳩尾槽底部仍留 1.7mm
OL = IN_L + 2*W2; OW = IN_W + 2*W2;
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
// ---- 蓋面文字（可自行修改）----
STYLE = 1;   // 1 | 2 | 3（定稿：1 = A 版） 三種生日版面
CJK = "WenQuanYi Zen Hei";
module cake2d(sc=1) scale(sc) {      // 蛋糕圖示（2D）
    translate([-6,0]) square([12,4.5]);
    translate([-4.5,4.5]) square([9,3.5]);
    for (x=[-2.5,0,2.5]) { translate([x-0.45,8]) square([0.9,3]); translate([x,12.2]) scale([0.8,1.3]) circle(r=0.9,$fn=16); }
}
module lid_text2d() {
    if (STYLE==1) {
        translate([-8,0]) text("HAPPY BIRTHDAY", size=7, halign="center", valign="center", font="DejaVu Sans:style=Bold");
        translate([-82,-6.5]) cake2d(0.9);
        translate([58,-6.5]) cake2d(0.9);
    } else if (STYLE==2) {
        translate([-10,5]) text("生日快樂", size=10, halign="center", valign="center", font=CJK);
        translate([-10,-8.5]) text("HAPPY BIRTHDAY", size=4.2, halign="center", valign="center", font="DejaVu Sans:style=Bold", spacing=1.25);
        for (x=[-62,42]) translate([x,0]) rotate(18) text("\u2605", size=7, halign="center", valign="center", font="DejaVu Sans");
    } else {
        translate([-12,3.5]) text("Happy Birthday!", size=8.5, halign="center", valign="center", font="DejaVu Serif:style=Bold Italic");
        translate([-12,-9]) text("~ make a wish ~", size=4, halign="center", valign="center", font="DejaVu Serif:style=Italic");
        translate([-80,-7]) cake2d(1.05);
    }
}
module lid_deco() {   // 雙色：浮雕文字 + 推動止滑紋
    translate([0, 0, SLOT_H-0.15]) linear_extrude(0.6) lid_text2d();
    for (i=[0:4]) translate([OL/2-6-i*2.4, -9, SLOT_H-0.15]) cube([1.2, 18, 0.6]);
}

if (part=="base") base();
else if (part=="lid") lid();
else if (part=="lidtext") lid_deco();   // 白色浮雕（3MF 第二色）
else if (part=="lidview") { color("#e9c46a") base(); translate([0,0,H-SLOT_H]) { color("#264653") lid(); color("#ffffff") lid_deco(); } }
else {
    color("#e9c46a") base();
    translate([0,0,FLOOR-POCKET]) ruler();
    translate([60, 0, H-SLOT_H]) { color("#264653") lid(); color("#ffffff") lid_deco(); }
}
