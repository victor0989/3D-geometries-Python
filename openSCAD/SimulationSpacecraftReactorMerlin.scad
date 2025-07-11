$fn = 100;

// Tobera Merlin
difference() {
    cone(h=2.0, r1=0.25, r2=0.9);
    translate([0, 0, -0.1]) cylinder(h=2.1, r=0.2);
}

// Toroide Tokamak
translate([0, 0, 2.0])
    torus(R=0.75, r=0.15);

// Solenoide central
translate([0, 0, 2.0])
    cylinder(h=1.4, r=0.08);

// Bobinas toroidales
for (a = [0 : 30 : 330]) {
    rotate([0, 0, a])
    translate([0.75, 0, 2.0])
        rotate([90, 0, 0])
            torus(R=0.05, r=0.015);
}

// Inyector
translate([0.9, 0, 2.2]) rotate([0, 90, 0]) cylinder(h=0.4, r=0.02);

// Conductos
for (a = [0 : 90 : 270]) {
    rotate([0, 0, a])
    translate([0.6, 0, 2.3]) cylinder(h=0.5, r=0.015);
}

// Escudo térmico
difference() {
    translate([0, 0, 1.9]) cylinder(h=0.4, r=1.05);
    translate([0, 0, 1.9]) cylinder(h=0.4, r=0.95);
}

// Nodo de control
translate([-0.4, 0, 2.3]) cube([0.1, 0.1, 0.1], center=true);

module torus(R, r) {
    rotate_extrude(angle = 360)
        translate([R, 0, 0])
            circle(r);
}
