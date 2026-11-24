// 款式4：一體成形鉸鏈翻蓋盒（print-in-place）
include <common.scad>
part = "scene"; // scene | print（攤平 180° 一次列印）
H = 12; HL = 7; CL = 0.35;
OL = IN_L + 2*WALL; OW = IN_W + 2*WALL;
KR = 3.2; PIN = 1.5; NK = 7;                 // 鉸鏈節半徑 / 銷半徑 / 節數
AY = OW/2 + KR - 0.6;                        // 鉸鏈軸 y
KL = (OL - 20) / NK;                         // 每節長

module star(r=5) polygon([for (i=[0:9]) let(a=90+i*36, rr=(i%2==0)?r:r*0.42) [rr*cos(a), rr*sin(a)]]);

module knuckles(odd) for (i=[0:NK-1]) if (i%2==(odd?1:0)) {
    x0 = -OL/2 + 10 + i*KL + (i==0?0:CL/2);
    len = KL - ((i==0||i==NK-1)?CL/2:CL);
    difference() {
        union() {
            translate([x0, AY, H]) rotate([0,90,0]) cylinder(r=KR, h=len);
            // 連接塊：底盒節往下接，上蓋節往上接
            translate([x0, OW/2-2, odd ? H : H-KR]) cube([len, AY-OW/2+2, KR]);
        }
        if (odd) translate([x0-1, AY, H]) rotate([0,90,0]) cylinder(r=PIN+CL, h=len+2);
    }
    if (!odd) translate([x0 - (i==0?0:CL+0.01), AY, H]) rotate([0,90,0])
        cylinder(r=PIN, h=len + ((i==0||i==NK-1)?CL:2*CL)+0.02);
}
module base() {
    difference() {
        rbox(OL, OW, H, 3);
        translate([0,0,FLOOR]) rbox(IN_L, IN_W, H, 1.5);
        ruler_pocket(FLOOR - POCKET);
    }
    knuckles(false);
    translate([0, -OW/2, H-2]) scale([1,0.6,1]) rotate([0,90,0]) cylinder(r=1.2, h=14, center=true); // 卡扣凸點
}
module lid() {
    difference() {
        translate([0,0,H]) rbox(OL, OW, HL, 3);
        translate([0,0,H-0.01]) rbox(IN_L, IN_W, HL-1.8, 1.5);
        translate([0, -OW/2, H+2]) scale([1,0.6,1]) rotate([0,90,0]) cylinder(r=1.3, h=15, center=true);
    }
    knuckles(true);
    translate([0, -OW/2-1, H+HL/2]) cube([16, 2, HL-1], center=true); // 開蓋指扣
}
module lid_deco() {
    for (p=[[-60,6,6],[-35,-8,4],[-5,4,7],[25,-6,4.5],[52,8,5.5],[72,-7,3.5],[-78,-7,3.5]])
        translate([p[0], p[1], H+HL-0.01]) rotate(p[0]*3) linear_extrude(0.6) star(p[2]);
}
module open_lid(a) translate([0,AY,H]) rotate([-a,0,0]) translate([0,-AY,-H]) children();

if (part=="print") { base(); open_lid(180) lid(); }
else {
    color("#a8dadc") base();
    translate([0,0,FLOOR-POCKET]) ruler();
    open_lid(110) { color("#457b9d") lid(); color("#ffd166") lid_deco(); }
    // 後方再放一個「闔上」的樣子，看得到蓋面星星
    translate([0, OW + 75, 0]) { color("#a8dadc") base(); color("#457b9d") lid(); color("#ffd166") lid_deco(); }
}
