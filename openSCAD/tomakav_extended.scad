// Mini‑Tokamak + Cryo‑cooling + Solenoid + Nozzle

// Parámetros
major_r = 20;
minor_r = 6;
coil_th = 1.5;
sol_th = 4;
nozzle_len = 30;
nozzle_exit = 16;
tube_r = 1.0;
shield_th = 22;

// Cámaras y bobinas
module torus(R, r) {
  rotate_extrude($fn=64)
    translate([R,0,0])
      circle(r=r, $fn=32);
}

module solenoid() {
  translate([0,0,shield_th])
    rotate([90,0,0])
      cylinder(h=shield_th*2, r=sol_th, $fn=64);
}

// Tobera estilo Merlin
module nozzle() {
  translate([0,0,-nozzle_len])
    cylinder(h = nozzle_len, r1 = coil_th, r2 = nozzle_exit, $fn=64);
}

// Circuito criogénico
module cryotubes() {
  for (theta = [0:90:270]) {
    rotate([0,0,theta])
      translate([major_r+2,0,0])
        cylinder(h = minor_r*2, r = tube_r, $fn=32);
  }
}

// Blindaje intermedio
module shield() {
  color("lightblue")
  torus(major_r, minor_r + 1);
}

// Ensamble
union() {
  color("silver") torus(major_r, minor_r);
  color("silver") solenoid();
  color("dimgray") nozzle();
  color("gold") cryotubes();
  shield();
}
