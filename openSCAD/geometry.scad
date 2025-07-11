$fn = 100;

// === Utilidades ===
module torus(R, r){
    rotate_extrude(angle = 360)
    translate([R, 0, 0])
    circle(r=r);
}

module hex_panel(thickness = 0.1) {
    angle = 360 / 6;
    points = [for (i = [0:5]) [cos(i * angle), sin(i * angle)]];
    linear_extrude(height = thickness)
        polygon(points);
}

module hex_shield_layer(z_height, radius = 30, spacing = 2.0) {
    rows = floor(2 * radius / spacing);
    cols = floor(2 * radius / spacing);
    for (i = [0 : rows]) {
        for (j = [0 : cols]) {
            x_offset = (j % 2 == 0) ? 0 : spacing / 2;
            x = -radius + j * spacing + x_offset;
            y = -radius + i * spacing * sqrt(3)/2;
            if (x * x + y * y <= radius * radius)
                translate([x, y, z_height])
                    color([1, 0.55, 0], 0.6)
                        hex_panel(0.15);
        }
    }
}

module solar_panel(pos = [0,0,0]) {
    translate(pos)
        color([0.12, 0.56, 1.0], 0.7)
            cube([5.0, 0.2, 1.5], center=true);
}

// === Motor Merlin ===
module merlin_engine(pos = [0,0,0]) {
    translate(pos){
        // Cámara de combustión
        color("lightgray")
        cylinder(h=4, r=1.2);
        // Tobera
        translate([0,0,-4])
        color("gray")
        cylinder(h=4, r1=2.2, r2=1.2);
    }
}

// === Propulsión iónica ===
module ion_propulsion(){
    // Anillo externo
    color([0.3, 0.3, 0.4])
    translate([0, 0, -0.7])
    cylinder(r=6, h=0.4);
    
    // Motores iónicos
    for (i = [0:60:360]){
        angle = i;
        x = cos(angle) * 5.5;
        y = sin(angle) * 5.5;
        translate([x, y, -1.2])
            color([0.39, 0.58, 0.93])
            rotate([180,0,0])
            cylinder(h=0.6, r1=0.1, r2=0.3);
    }
}

// === Módulo científico ===
module scientific_module(){
    color("deepskyblue")
    translate([0, 0, 28])
    cylinder(h=4, r=3.5, center=true);
}

// === Módulo de carga ===
module cargo_module(){
    color("saddlebrown")
    translate([0, 0, 38])
    cube([5, 5, 3], center=true);
}

// === Nave completa ===
module nave_principal(){
    // Fuselaje
    color("steelblue")
    translate([0,0,20])
    cylinder(h=40, r1=10, r2=10);

    // Refuerzos toroidales
    for (z = [25, 30, 35]) {
        color("dimgray")
        translate([0,0,z])
        torus(10.5, 0.6);
    }

    // Compartimentos laterales
    color("saddlebrown")
    translate([13, 0, 30])
    cylinder(h=10, r=2.5, center=true);

    translate([-13, 0, 20])
    cube([5, 3, 8], center=true);

    // Cúpula
    color("skyblue", 0.6)
    translate([0, 0, 60])
    scale([1.2,1.2,0.6])
    sphere(r=10);

    // Propulsor inferior
    color("gray")
    rotate([180,0,0])
    translate([0,0,-10])
    cylinder(h=10, r1=12, r2=3);

    // Aletas externas
    for (a = [0:120:360]) {
        rotate([0,0,a])
        translate([15,0,20])
        color("lightgray", 0.6)
        cube([0.5, 5, 6], center=true);
    }

    // Paneles solares
    solar_panel([12, 0, 35]);
    solar_panel([-12, 0, 35]);

    // Escudos hexagonales
    hex_shield_layer(65, 18);
    hex_shield_layer(67, 18);

    // Módulo científico y carga
    scientific_module();
    cargo_module();

    // Propulsión iónica
    translate([0,0,10])
        ion_propulsion();

    // Motores Merlin
    for (a = [0:72:360]){
        angle = a;
        x = cos(angle) * 6;
        y = sin(angle) * 6;
        merlin_engine([x, y, 10]);
    }
    // Motor central
    merlin_engine([0, 0, 10]);
}

nave_principal();

