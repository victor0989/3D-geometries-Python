// Parámetros generales
FUSELAGE_LENGTH = 20;
FUSELAGE_RADIUS = 1.35;
scale_x = 1.6;
scale_y = 1.0;

// Módulo cono para propulsión
module cone(r, h) {
    cylinder(h=h, r1=r, r2=0, center=true);
}

// Fuselaje ovalado: cilindro escalado + algunos detalles
module fuselage_oval() {
    color([0.25, 0.41, 0.88])  // Azul real
        translate([0,0,FUSELAGE_LENGTH/2])
            scale([scale_x, scale_y, 1])
                cylinder(h=FUSELAGE_LENGTH, r=FUSELAGE_RADIUS + 0.3, center=false);

    // Anillos estructurales (simples)
    for (z = [2, 6, 10, 14, 18]) {
        color([0.41, 0.41, 0.41])
            translate([0, 0, z])
                scale([scale_x, scale_y, 1])
                    torus_ring(FUSELAGE_RADIUS + 0.32, 0.05);
    }

    // Compartimentos cilíndricos externos
    for (z = [5, 10, 15]) {
        color([0.54, 0.27, 0.07])
            translate([(FUSELAGE_RADIUS + 0.6) * scale_x, 0, z])
                scale([scale_x, scale_y, 1])
                    cylinder(h=1.5, r=0.4, center=true);
    }

    // Kevlar layer (translúcido dorado)
    color([0.72, 0.53, 0.04, 0.3])
        translate([0, 0, FUSELAGE_LENGTH / 2])
            scale([scale_x, scale_y, 1])
                cylinder(h=FUSELAGE_LENGTH, r=FUSELAGE_RADIUS + 0.4, center=false);

    // Escudos (aletas)
    for (i = [0 : 2]) {
        angle = i * 120; // grados
        x = cos(angle) * (FUSELAGE_RADIUS + 0.5) * scale_x;
        y = sin(angle) * (FUSELAGE_RADIUS + 0.5) * scale_y;
        color([0.66, 0.66, 0.66, 0.8])
            translate([x, y, FUSELAGE_LENGTH / 2])
                rotate([0, 0, angle])
                    cube([0.05, 1.2, 0.8], center=true);
    }

    // Sensores adicionales
    for (z = [4, 12]) {
        color("orange")
            translate([0, -(FUSELAGE_RADIUS + 0.4)*scale_y, z])
                scale([scale_x, scale_y, 1])
                    sphere(r=0.2);
    }
}

// Función para crear un torus simple (ring) en OpenSCAD
// Approximate with difference of two cylinders
module torus_ring(outer_r, thickness) {
    difference() {
        cylinder(h=thickness, r=outer_r, center=true);
        cylinder(h=thickness+0.1, r=outer_r - thickness, center=true);
    }
}

// Alas ovaladas
module wings_oval() {
    wing_length = 8;
    wing_width = 2.4;
    wing_thickness = 0.15;

    // ala izquierda
    translate([-wing_length/2, -(FUSELAGE_RADIUS + 0.6)*scale_y, FUSELAGE_LENGTH * 0.45])
        scale([scale_x, scale_y, 1])
            color("steelblue")
                hull() {
                    translate([0, 0, 0])
                        cube([wing_length*0.2, wing_width*0.6, wing_thickness], center=true);
                    translate([wing_length/2, 0, 0])
                        cube([wing_length*0.2, wing_width*0.3, wing_thickness], center=true);
                }

    // ala derecha (simétrica)
    translate([wing_length/2, -(FUSELAGE_RADIUS + 0.6)*scale_y, FUSELAGE_LENGTH * 0.45])
        scale([scale_x, scale_y, 1])
            color("steelblue")
                hull() {
                    translate([0, 0, 0])
                        cube([wing_length*0.2, wing_width*0.6, wing_thickness], center=true);
                    translate([-wing_length/2, 0, 0])
                        cube([wing_length*0.2, wing_width*0.3, wing_thickness], center=true);
                }
}

// Payload de propulsión (cono invertido)
module propulsion_payload() {
    base_radius = 2.5;
    height = 4;

    translate([0, 0, -height/2])
        color("dimgray")
            scale([scale_x, scale_y, 1])
                cone(base_radius, height);
}

// Definición de cone (cylinder con r2=0)
module cone(r, h) {
    cylinder(h=h, r1=r, r2=0, center=true);
}

// Ensamblaje final de la nave
module spaceship() {
    fuselage_oval();
    wings_oval();
    propulsion_payload();
}

// Renderiza la nave
spaceship();
