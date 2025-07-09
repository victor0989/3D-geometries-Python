import trimesh
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
from trimesh.creation import torus

# ---------- Aquí insertamos todas tus funciones para crear Falcon Parker, por ejemplo:
# create_advanced_fuselage(), create_nose_cone(), create_escape_tower(), etc.
# Las asumo ya definidas tal cual me pasaste (por brevedad, no repito todo aquí)
# Además la función combine_meshes() y plot_mesh()
FUSELAGE_LENGTH = 20.0
FUSELAGE_RADIUS = 1.35

#def create_fuselage():
 #   fuselage = trimesh.creation.cylinder(radius=FUSELAGE_RADIUS, height=FUSELAGE_LENGTH)
  #  fuselage.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
   # fuselage.visual.vertex_colors = [70, 130, 180, 255]  # Azul acero sólido
    #return fuselage
def create_advanced_fuselage():
    components = []

    # Cuerpo principal más grueso y compacto
    main_body = trimesh.creation.cylinder(radius=FUSELAGE_RADIUS + 0.3, height=FUSELAGE_LENGTH)
    main_body.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
    main_body.visual.vertex_colors = [65, 105, 225, 255]  # Azul real
    components.append(main_body)

    # Anillos estructurales tipo refuerzo
    for z in np.linspace(2, FUSELAGE_LENGTH - 2, 5):
        ring = trimesh.creation.torus(FUSELAGE_RADIUS + 0.32, 0.05)
        ring.apply_translation([0, 0, z])
        ring.visual.vertex_colors = [105, 105, 105, 255]  # Gris oscuro
        components.append(ring)

    # Compartimentos cilíndricos externos
    for z in [5.0, 10.0, 15.0]:
        compartment = trimesh.creation.cylinder(radius=0.4, height=1.5)
        compartment.apply_translation([FUSELAGE_RADIUS + 0.6, 0, z])
        compartment.visual.vertex_colors = [139, 69, 19, 255]  # Marrón metálico
        components.append(compartment)

    # Revestimiento tipo kevlar o resina
    kevlar_layer = trimesh.creation.cylinder(radius=FUSELAGE_RADIUS + 0.4, height=FUSELAGE_LENGTH)
    kevlar_layer.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
    kevlar_layer.visual.vertex_colors = [184, 134, 11, 90]  # Dorado translúcido (kevlar)
    components.append(kevlar_layer)

    # Escudos pequeños (rejillas planas como aletas adicionales)
    for i in range(3):
        fin = trimesh.creation.box(extents=[0.05, 1.2, 0.8])
        angle = i * (2 * np.pi / 3)
        x = np.cos(angle) * (FUSELAGE_RADIUS + 0.5)
        y = np.sin(angle) * (FUSELAGE_RADIUS + 0.5)
        fin.apply_translation([x, y, FUSELAGE_LENGTH / 2])
        fin.visual.vertex_colors = [169, 169, 169, 200]  # Gris medio translúcido
        components.append(fin)

    # Sensores adicionales
    for z in [4.0, 12.0]:
        sensor = trimesh.creation.icosphere(radius=0.2)
        sensor.apply_translation([0, -(FUSELAGE_RADIUS + 0.4), z])
        sensor.visual.vertex_colors = [255, 140, 0, 255]  # Naranja sólido
        components.append(sensor)

    return combine_meshes(components)


def create_nose_cone():
    cone = trimesh.creation.cone(radius=FUSELAGE_RADIUS * 0.9, height=3.2)
    cone.apply_translation([0, 0, FUSELAGE_LENGTH + 1.6])
    cone.visual.vertex_colors = [255, 215, 0, 255]  # Amarillo dorado sólido
    return cone

def create_escape_tower():
    tower = trimesh.creation.cylinder(radius=0.2, height=1.4)
    tower.apply_translation([0, 0, FUSELAGE_LENGTH + 3.2])
    tower.visual.vertex_colors = [192, 192, 192, 220]  # Plata translúcido
    return tower

def create_propulsion_base():
    base = trimesh.creation.cone(radius=1.4, height=1.2)
    base.apply_translation([0, 0, -0.6])
    base.visual.vertex_colors = [105, 105, 105, 255]  # Gris oscuro
    return base

def create_thermal_shield():
    shield = trimesh.creation.cylinder(radius=2.6, height=0.6)
    shield.apply_translation([0, 0, FUSELAGE_LENGTH + 0.3])
    shield.visual.vertex_colors = [255, 69, 0, 150]  # Rojo anaranjado translúcido
    return shield

def create_reinforced_heat_shield_layers():
    layers = []
    radii = [2.7, 2.9, 3.1]
    heights = [0.15, 0.15, 0.15]
    colors = [[255, 140, 0, 120], [255, 69, 0, 100], [178, 34, 34, 80]]  # Naranjas y rojos translúcidos
    z_pos = FUSELAGE_LENGTH + 0.6
    for r, h, c in zip(radii, heights, colors):
        layer = trimesh.creation.cylinder(radius=r, height=h)
        layer.apply_translation([0, 0, z_pos])
        layer.visual.vertex_colors = c
        layers.append(layer)
        z_pos += h
    return layers

def create_detailed_merlin_engine(position):
    chamber = trimesh.creation.cylinder(radius=0.15, height=0.4)
    chamber.apply_translation([0, 0, 0.2])
    chamber.visual.vertex_colors = [220, 220, 220, 255]  # Gris claro

    nozzle = trimesh.creation.cone(radius=0.25, height=0.6)
    nozzle.apply_translation([0, 0, -0.3])
    nozzle.visual.vertex_colors = [169, 169, 169, 255]  # Gris medio

    engine = combine_meshes([chamber, nozzle])
    engine.apply_translation(position)
    return engine

def create_merlin_engine_array():
    engines = []
    pattern = [(np.cos(a) * 0.75, np.sin(a) * 0.75) for a in np.linspace(0, 2*np.pi, 8, endpoint=False)]
    pattern.append((0, 0))  # motor central
    for x, y in pattern:
        engines.append(create_detailed_merlin_engine([x, y, -1.5]))
    return engines

def create_solar_panels():
    panels = []
    width, height, depth = 5.0, 1.5, 0.1
    panel1 = trimesh.creation.box(extents=[width, depth, height])
    panel1.apply_translation([-3.2, 0, FUSELAGE_LENGTH * 0.4])
    panel1.visual.vertex_colors = [30, 144, 255, 180]  # Azul dodger, translúcido
    panel2 = panel1.copy()
    panel2.apply_translation([6.4, 0, 0])  # mover a la derecha
    panels.extend([panel1, panel2])
    return panels

def create_solar_panel_frames():
    frames = []
    width, height, depth = 5.1, 0.12, 1.6
    frame1 = trimesh.creation.box(extents=[width, height, depth])
    frame1.apply_translation([-3.2, 0, FUSELAGE_LENGTH * 0.4])
    frame1.visual.vertex_colors = [169, 169, 169, 255]  # Gris oscuro marco

    frame2 = frame1.copy()
    frame2.apply_translation([6.4, 0, 0])
    frames.extend([frame1, frame2])
    return frames

def create_radiator_panels():
    radiators = []
    width, height, depth = 3.0, 0.05, 1.0
    positions = [[2.5, 0, FUSELAGE_LENGTH * 0.7], [-2.5, 0, FUSELAGE_LENGTH * 0.7]]
    for pos in positions:
        panel = trimesh.creation.box(extents=[width, height, depth])
        panel.apply_translation(pos)
        panel.visual.vertex_colors = [70, 70, 70, 180]  # Gris oscuro translúcido
        radiators.append(panel)
    return radiators

def create_segmented_torus(radius_major, radius_minor, segments_major=12, segments_minor=6):
    components = []
    angle_step = 2 * np.pi / segments_major
    for i in range(segments_major):
        angle = i * angle_step
        center_x = radius_major * np.cos(angle)
        center_y = radius_major * np.sin(angle)
        rotation_angle = angle + np.pi / 2

        cyl = trimesh.creation.cylinder(
            radius=radius_minor,
            height=radius_major * angle_step * 0.6,  # ligeramente más corto para menos grosor visual
            sections=16
        )
        cyl.apply_translation([0, cyl.bounds[1][1]/2, 0])
        cyl.apply_transform(trimesh.transformations.rotation_matrix(
            rotation_angle, [0,0,1]
        ))
        cyl.apply_translation([center_x, center_y, 0])
        components.append(cyl)
    return trimesh.util.concatenate(components)

def create_warp_nacelle(length=10, radius=0.9, curve_radius=5, segments=18):
    components = []
    angle_step = np.pi / (2 * segments)
    for i in range(segments):
        angle = i * angle_step
        center_x = curve_radius * np.sin(angle)
        center_y = curve_radius * (1 - np.cos(angle))
        cyl = trimesh.creation.cylinder(radius=radius, height=length/segments, sections=12)
        cyl.apply_translation([0, cyl.bounds[1][1]/2, 0])
        rot = trimesh.transformations.rotation_matrix(angle, [0, 0, 1])
        cyl.apply_transform(rot)
        cyl.apply_translation([center_x, center_y, 0])
        components.append(cyl)
    return trimesh.util.concatenate(components)

def create_parabolic_antenna(radius=1.0, depth=0.4, segments=16):
    phi = np.linspace(0, np.pi/2, segments)
    theta = np.linspace(0, 2*np.pi, segments)
    phi, theta = np.meshgrid(phi, theta)
    r = radius * (phi / (np.pi/2))**2
    x = r * np.cos(theta)
    y = r * np.sin(theta)
    z = depth * (1 - phi / (np.pi/2))
    vertices = np.column_stack((x.flatten(), y.flatten(), z.flatten()))
    faces = []
    for i in range(segments-1):
        for j in range(segments-1):
            idx = i * segments + j
            faces.append([idx, idx+1, idx+segments])
            faces.append([idx+1, idx+segments+1, idx+segments])
    antenna_mesh = trimesh.Trimesh(vertices=vertices, faces=faces)
    return antenna_mesh

def build_falcon_parker():
    components = []

    # Cuerpo principal más delgado y largo
    fuselage = trimesh.creation.box(extents=[4.5, 18, 4.5])
    components.append(fuselage)

    # Motores traseros más delgados y cortos
    thruster1 = trimesh.creation.cylinder(radius=1.5, height=4, sections=16)
    thruster1.apply_translation([2.5, -11, 0])
    components.append(thruster1)

    thruster2 = thruster1.copy()
    thruster2.apply_translation([-5, 0, 0])
    components.append(thruster2)

    # Anillos torus más finos
    torus1 = create_segmented_torus(radius_major=3.5, radius_minor=0.35, segments_major=16, segments_minor=8)
    torus1.apply_translation([0, 1.5, 0])
    components.append(torus1)

    # Nacelles warp más finos y compactos
    nacelle_left = create_warp_nacelle(length=10, radius=0.85, curve_radius=5, segments=18)
    nacelle_left.apply_translation([-6, 0, 0])
    components.append(nacelle_left)

    nacelle_right = nacelle_left.copy()
    nacelle_right.apply_scale([-1,1,1])
    components.append(nacelle_right)

    # Antenas parabólicas más pequeñas
    antenna1 = create_parabolic_antenna(radius=1.3, depth=0.4, segments=20)
    antenna1.apply_translation([0, -9, 2.5])
    components.append(antenna1)

    antenna2 = antenna1.copy()
    antenna2.apply_translation([0, 0, -5])
    components.append(antenna2)

    model = trimesh.util.concatenate(components)
    model.export('falcon_parker_warp_model_special_1.stl')
    print("Modelo con nacelles y antenas exportado a falcon_parker_warp_model_special.stl")

if __name__ == "__main__":
    build_falcon_parker()
