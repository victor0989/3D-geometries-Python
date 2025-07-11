// Parámetros
FUSELAGE_LENGTH = 20;
FUSELAGE_RADIUS = 1.35;

// Función para crear un anillo (torus approx)
module ring(radius = 1.67, thickness = 0.05) {
    difference() {
        cylinder(h=thickness, r=radius + thickness, center=true);
        cylinder(h=thickness+0.1, r=radius, center=true);
    }
}

// Fuselaje avanzado
module advanced_fuselage() {
    // Cuerpo principal más grueso y compacto
    color("royalblue")
        translate([0, 0, FUSELAGE_LENGTH/2])
            cylinder(h=FUSELAGE_LENGTH, r=FUSELAGE_RADIUS + 0.3, center=false);

    // Anillos estructurales tipo refuerzo
    color("dimgray")
    for (z = [2,6,10,14,18]) {
        translate([0, 0, z])
            ring(radius=FUSELAGE_RADIUS + 0.32, thickness=0.05);
    }

    // Compartimentos cilíndricos externos
    color("saddlebrown")
    for (z = [5, 10, 15]) {
        translate([FUSELAGE_RADIUS + 0.6, 0, z])
            cylinder(h=1.5, r=0.4, center=true);
    }

    // Revestimiento tipo kevlar o resina translúcido
    color([184/255, 134/255, 11/255, 0.35])
        translate([0, 0, FUSELAGE_LENGTH/2])
            cylinder(h=FUSELAGE_LENGTH, r=FUSELAGE_RADIUS + 0.4, center=false);

    // Escudos pequeños (rejillas planas)
    color([0.66,0.66,0.66,0.8])
    for (i = [0:2]) {
        angle = i*120;
        x = cos(angle)* (FUSELAGE_RADIUS + 0.5);
        y = sin(angle)* (FUSELAGE_RADIUS + 0.5);
        translate([x, y, FUSELAGE_LENGTH/2])
            cube([0.05, 1.2, 0.8], center=true);
    }

    // Sensores (esferas naranja)
    color("darkorange")
    for (z = [4,12]) {
        translate([0, -(FUSELAGE_RADIUS + 0.4), z])
            sphere(r=0.2);
    }
}

// Nariz cono
module nose_cone() {
    color("gold")
        translate([0, 0, FUSELAGE_LENGTH + 1.6])
            cone(r1=FUSELAGE_RADIUS * 0.9, r2=0, h=3.2);
}

// Torre de escape
module escape_tower() {
    color([192/255,192/255,192/255,0.86])
        translate([0, 0, FUSELAGE_LENGTH + 3.2])
            cylinder(h=1.4, r=0.2, center=false);
}

// Base propulsión
module propulsion_base() {
    color("dimgray")
        translate([0,0,-0.6])
            cone(r1=1.4, r2=0, h=1.2);
}

// Escudo térmico
module thermal_shield() {
    color([1, 69/255, 0, 0.6])
        translate([0, 0, FUSELAGE_LENGTH + 0.3])
            cylinder(h=0.6, r=2.6, center=false);
}

// Capa reforzada escudo térmico
module reinforced_heat_shield_layers() {
    colors = [[1,140/255,0,0.47],[1,69/255,0,0.39],[178/255,34/255,34/255,0.31]];
    radii = [2.7, 2.9, 3.1];
    heights = [0.15,0.15,0.15];
    zpos = FUSELAGE_LENGTH + 0.6;

    for (i = [0:2]) {
        color(colors[i])
            translate([0, 0, zpos])
                cylinder(h=heights[i], r=radii[i], center=false);
        zpos = zpos + heights[i];
    }
}

// Cono (OpenSCAD no tiene cone directo, usamos cylinder con r2=0)
module cone(r1, r2, h) {
    cylinder(h=h, r1=r1, r2=r2, center=false);
}

// Función para hacer merlin engine simple (con cilindro y cono)
module merlin_engine(position=[0,0,0]) {
    color("lightgray")
        translate([position[0], position[1], position[2] + 0.2])
            cylinder(h=0.4, r=0.15, center=false);

    color("darkgray")
        translate([position[0], position[1], position[2] - 0.1])
            cone(r1=0.25, r2=0, h=0.6);
}

// Matriz de motores merlin
module merlin_engine_array() {
    // 8 motores alrededor + 1 central
    for (i = [0:7]) {
        angle = i*360/8;
        x = cos(angle)*0.75;
        y = sin(angle)*0.75;
        merlin_engine([x,y,-1.5]);
    }
    merlin_engine([0,0,-1.5]);
}

// Paneles solares
module solar_panels() {
    color([30/255,144/255,1,0.7])
    translate([-3.2, 0, FUSELAGE_LENGTH * 0.4])
        cube([5.0, 0.1, 1.5], center=true);
    translate([3.2, 0, FUSELAGE_LENGTH * 0.4])
        cube([5.0, 0.1, 1.5], center=true);
}

// Marcos paneles solares
module solar_panel_frames() {
    color("darkgray")
    translate([-3.2, 0, FUSELAGE_LENGTH * 0.4])
        cube([5.1, 0.12, 1.6], center=true);
    translate([3.2, 0, FUSELAGE_LENGTH * 0.4])
        cube([5.1, 0.12, 1.6], center=true);
}

// Radiadores
module radiator_panels() {
    color([0.27, 0.27, 0.27, 0.7])
    translate([2.5, 0, FUSELAGE_LENGTH * 0.7])
        cube([3.0, 0.05, 1.0], center=true);
    translate([-2.5, 0, FUSELAGE_LENGTH * 0.7])
        cube([3.0, 0.05, 1.0], center=true);
}

// Sensores
module sensors() {
    color("darkorange")
    translate([1.1, 0, FUSELAGE_LENGTH - 2])
        sphere(r=0.15);
    translate([-1.1, 0, FUSELAGE_LENGTH - 2])
        sphere(r=0.15);
}

// Antenas
module antenna_array() {
    color("lightyellow")
    translate([0.4, 0.4, FUSELAGE_LENGTH - 0.8])
        cylinder(h=1.3, r=0.05, center=false);
    translate([-0.4, -0.4, FUSELAGE_LENGTH - 0.8])
        cylinder(h=1.3, r=0.05, center=false);
}

// Brazo robótico simple
module robotic_arm() {
    color("sienna")
        translate([1.6, 0, FUSELAGE_LENGTH * 0.7])
            union() {
                cylinder(h=0.4, r=0.1, center=false);
                translate([0, 0.6, 0])
                    cube([0.1, 1.2, 0.1], center=false);
            }
}

// Estructura columna espinal
module spine_structure() {
    color("dimgray")
        translate([0, 0, FUSELAGE_LENGTH * 0.4])
            cylinder(h=FUSELAGE_LENGTH * 0.8, r=0.08, center=false);
}

// Cúpula
module dome() {
    color([135/255,206/255,250/255,0.7])
        translate([0,0,FUSELAGE_LENGTH+2.6])
            scale([1.1, 1.1, 0.5])
                sphere(r=1.2);
}

// Módulo científico
module scientific_module() {
    color("deepskyblue")
        translate([0, 0, FUSELAGE_LENGTH * 0.2])
            cylinder(h=0.4, r=1.0, center=false);
}

// Módulo carga útil
module payload_module() {
    color("sienna")
        translate([0, 0, FUSELAGE_LENGTH * 0.3])
            cube([2.5, 2.5, 1.2], center=true);
}

// Piernas de aterrizaje
module landing_legs() {
    color("gray")
    for (angle = [45, 135, -45, -135]) {
        x = cos(angle) * 1.8;
        y = sin(angle) * 1.8;
        translate([x, y, -1])
            rotate([35,0,0])
                cube([0.1, 0.1, 2], center=true);
    }
}

// --- AÑADIDO: Sistema de propulsión iónica ---
module ion_propulsion_system() {
    parts() {
        // Anillo exterior
        color([80/255,80/255,90/255])
            translate([0, 0, -0.7])
                cylinder(h=0.2, r=1.5, center=false);

        // Anillo interior hueco (simulación restando con diferencia)
        difference() {
            translate([0, 0, -0.7])
                cylinder(h=0.2, r=1.5, center=false);
            translate([0, 0, -0.7])
                cylinder(h=0.3, r=1.2, center=false);
        }

        // 6 pequeños motores iónicos en círculo
        color([100/255,149/255,237/255])
        for (i = [0:5]) {
            angle = i*360/6;
            x = cos(angle)*1.3;
            y = sin(angle)*1.3;
            translate([x, y, -1.2])
                cone(r1=0.1, r2=0, h=0.3);
        }
    }
}

// --- AÑADIDO: Antena parabólica simple ---
module parabolic_antenna() {
    union() {
        color([211/255,211/255,211/255,0.86])
            translate([0, 0, FUSELAGE_LENGTH * 0.9])
                cone(r1=1.2, r2=0, h=0.6);
        color("dimgray")
            translate([0, 0, FUSELAGE_LENGTH * 0.9 - 0.8])
                cylinder(h=0.8, r=0.07, center=false);
    }
}

// Ensamblado final con añadidos
module falcon_paper_advanced() {
    advanced_fuselage();
    nose_cone();
    escape_tower();
    propulsion_base();
    thermal_shield();
    reinforced_heat_shield_layers();
    spine_structure();
    scientific_module();
    merlin_engine_array();
    solar_panels();
    solar_panel_frames();
    radiator_panels();
    sensors();
    antenna_array();
    robotic_arm();
    dome();
    payload_module();
    landing_legs();

    // Añadidos
    ion_propulsion_system();
    parabolic_antenna();
}

// Ejecución
falcon_paper_advanced();

