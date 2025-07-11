// Compact Merlin‑Tokamak hybrid

// Parameters
major_r = 20; // merlin base units
minor_r = 6;
coil_th = 2;
nozzle_length = 30;
nozzle_exit = 16;
tube_r = 1.5;

// Toroidal chamber
module torus(R, r) {
  rotate_extrude($fn=64)
    translate([R,0,0])
      circle(r=r, $fn=32);
}

// Merlin-style nozzle
module nozzle() {
  translate([0,0,-nozzle_length])
    cylinder(h = nozzle_length, r1 = coil_th, r2 = nozzle_exit, $fn=64);
}

// Cooling lines simulation
module tubes() {
  for (theta = [0:90:270]) {
    rotate([0,0,theta])
      translate([major_r+2, 0, 0])
        cylinder(h=minor_r*2, r=tube_r, $fn=32);
  }
}

// Combine
union() {
  color("silver") torus(major_r, minor_r);
  color("dimgray") nozzle();
  color("gold") tubes();
}

