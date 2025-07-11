// Parámetros globales para escala oval
scale_x = 1.6;
scale_y = 1.0;

// ALAS OVAlADAS (tipo planas y alargadas)
module wings_oval() {
    wing_length = 8;
    wing_width = 2.4;
    wing_thickness = 0.15;

    // ala izquierda
    translate([-wing_length/2, -(FUSELAGE_RADIUS + 0.6)*scale_y, FUSELAGE_LENGTH * 0.45])
        scale([scale_x, scale_y, 1])
            color("steelblue")
                // alas con forma elíptica, usamos hull para suavizar extremos
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

// PAYLOAD DE PROPULSION (cono invertido con base ancha)
module propulsion_payload() {
    base_radius = 2.5;
    height = 4;

    translate([0, 0, -height/2])
        color("dimgray")
            scale([scale_x, scale_y, 1])
                cone(base_radius, height);
}

// OpenSCAD no tiene función cone() nativa, así que definimos:
module cone(r, h) {
    cylinder(h=h, r1=r, r2=0, center=true);
}

// Ejemplo uso:
wings_oval();
propulsion_payload();




