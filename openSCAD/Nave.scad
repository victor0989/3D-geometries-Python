// === Nave Espacial en OpenSCAD ===

module fuselaje() {
    translate([0, 0, 0])
        cylinder(h=6, r=1, center=true);
}

module escudo() {
    intersection() {
        translate([0, 0, 3.1])
            sphere(r=1.05);
        translate([-2, -2, 2.8])
            cube([4, 4, 2], center=false);
    }
}

module panel_izq() {
    translate([-2, 0, 0])
        scale([1, 2, 0.05])
            cube([2, 2, 0.1], center=true);
}

module panel_der() {
    translate([2, 0, 0])
        scale([1, 2, 0.05])
            cube([2, 2, 0.1], center=true);
}

module motor(x_offset) {
    translate([x_offset, 0, -3.3])
        rotate([180, 0, 0])
            cylinder(h=0.6, r1=0.3, r2=0);
}

// Antena parabólica (esfera invertida)
module antena() {
    difference() {
        translate([0, 0, 4])
            sphere(r=0.5);
        translate([-1, -1, 4])
            cube([2, 2, 2], center=false);
    }
}

// Soportes de paneles
module soporte_panel(x_offset) {
    translate([x_offset, 0, 0])
        rotate([90, 0, 0])
            cylinder(h=1.5, r=0.05);
}

// Cúpula trasera
module cupula() {
    intersection() {
        translate([0, 0, -3.1])
            sphere(r=1);
        translate([-2, -2, -5])
            cube([4, 4, 2], center=false);
    }
}

// Ensamblar todo
color([0.1, 0.1, 0.1]) fuselaje();
color([0.1, 0.1, 0.1]) escudo();
cupula();
panel_izq();
panel_der();
soporte_panel(-1.5);
soporte_panel(1.5);
motor(-0.5);
motor(0.5);
antena();


// Ensamblar todo
color([0.1, 0.1, 0.1]) fuselaje();
color([0.1, 0.1, 0.1]) escudo();
panel_izq();
panel_der();
motor(-0.5);
motor(0.5);
