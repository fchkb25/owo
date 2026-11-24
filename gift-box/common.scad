// ===== 共用參數與模組 =====
// 直尺尺寸 (mm)
R_L = 170; R_W = 30; R_T = 2;
GAP  = 1;            // 直尺凹槽每邊間隙
WALL = 2;            // 壁厚
FLOOR = 3;           // 底板厚（含直尺凹槽）
POCKET = 1.8;        // 直尺凹槽深
IN_L = R_L + 6;      // 內腔長 176
IN_W = R_W + 6;      // 內腔寬 36
$fn = 48;

// 圓角方塊：中心對齊 XY，Z 從 0 起
module rbox(l, w, h, r=3) {
    r2 = max(min(r, l/2-0.01, w/2-0.01), 0.01);
    hull() for (x=[-1,1], y=[-1,1])
        translate([x*(l/2-r2), y*(w/2-r2), 0]) cylinder(r=r2, h=h);
}

// 底板內的直尺凹槽 + 兩側取物指槽（作為 difference 的減去物件）
module ruler_pocket(z0) {
    translate([0,0,z0]) {
        translate([-(R_L+2*GAP)/2, -(R_W+2*GAP)/2, 0]) cube([R_L+2*GAP, R_W+2*GAP, 10]);
        intersection() {
            translate([0,0,-1]) rbox(IN_L, IN_W, 20, 1.5);
            for (y=[-1,1]) translate([0, y*(R_W/2), -0.6]) scale([1.6,1,1]) cylinder(r=7, h=10);
        }
    }
}

// 直尺模型（僅渲染用）
module ruler() {
    translate([-R_L/2, -R_W/2, 0]) {
        color([0.85,0.88,0.92,1]) cube([R_L, R_W, R_T]);
        color([0.15,0.15,0.2]) for (i=[0:150]) {
            len = (i%10==0) ? 7 : (i%5==0 ? 5 : 3);
            translate([10+i-0.1, R_W-len, R_T]) cube([0.2, len, 0.05]);
        }
        color([0.15,0.15,0.2]) for (c=[0:15])
            translate([10+c*10, R_W-11, R_T]) linear_extrude(0.05)
                text(str(c), size=2.4, halign="center", font="Liberation Sans:style=Bold");
    }
}
