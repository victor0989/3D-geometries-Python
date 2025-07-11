import trimesh
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

FUSELAGE_LENGTH = 26.0
FUSELAGE_RADIUS = 1.3

def create_fuselage():
    fuselage = trimesh.creation.cylinder(radius=FUSELAGE_RADIUS, height=FUSELAGE_LENGTH)
    fuselage.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
    fuselage.visual.vertex_colors = [70, 130, 180, 255]  # Azul acero sólido
    return fuselage

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

def create_sensors():
    sensors = []
    # Dos sensores tipo esfera pequeños a ambos lados del fuselaje cerca de la parte superior
    positions = [[1.1, 0, FUSELAGE_LENGTH - 2], [-1.1, 0, FUSELAGE_LENGTH - 2]]
    for pos in positions:
        sensor = trimesh.creation.icosphere(radius=0.15)
        sensor.apply_translation(pos)
        sensor.visual.vertex_colors = [255, 140, 0, 200]  # Naranja translúcido
        sensors.append(sensor)
    return sensors

def create_antenna_array():
    antennas = []
    for pos in [[0.4, 0.4, FUSELAGE_LENGTH - 0.8], [-0.4, -0.4, FUSELAGE_LENGTH - 0.8]]:
        mast = trimesh.creation.cylinder(radius=0.05, height=1.3)
        mast.apply_translation([pos[0], pos[1], pos[2] + 0.65])
        mast.visual.vertex_colors = [255, 255, 224, 255]  # Amarillo pálido
        antennas.append(mast)
    return antennas

def create_scientific_module():
    module = trimesh.creation.cylinder(radius=1.0, height=0.4)
    module.apply_translation([0, 0, FUSELAGE_LENGTH * 0.2])
    module.visual.vertex_colors = [0, 191, 255, 255]  # Azul profundo
    return module

def create_payload_module():
    box = trimesh.creation.box(extents=[2.5, 2.5, 1.2])
    box.apply_translation([0, 0, FUSELAGE_LENGTH * 0.3])
    box.visual.vertex_colors = [160, 82, 45, 255]  # Marrón oscuro
    return box

def create_landing_legs():
    legs = []
    angles = [np.pi / 4, 3 * np.pi / 4, -np.pi / 4, -3 * np.pi / 4]
    for angle in angles:
        x = np.cos(angle) * 1.8
        y = np.sin(angle) * 1.8
        leg = trimesh.creation.box(extents=[0.1, 0.1, 2.0])
        leg.apply_translation([x, y, -1.0])
        tilt = trimesh.transformations.rotation_matrix(np.radians(35), [1, 0, 0], point=[x, y, -1.0])
        leg.apply_transform(tilt)
        leg.visual.vertex_colors = [128, 128, 128, 255]  # Gris medio
        legs.append(leg)
    return legs

def create_robotic_arm():
    arm_base = trimesh.creation.cylinder(radius=0.1, height=0.4)
    arm_base.visual.vertex_colors = [139, 69, 19, 255]  # Marrón oscuro
    arm = trimesh.creation.box(extents=[0.1, 1.2, 0.1])
    arm.apply_translation([0, 0.6, 0])
    arm.visual.vertex_colors = [160, 82, 45, 255]  # Marrón claro
    robotic = combine_meshes([arm_base, arm])
    robotic.apply_translation([1.6, 0, FUSELAGE_LENGTH * 0.7])
    return robotic

def create_spine_structure():
    spine = trimesh.creation.cylinder(radius=0.08, height=FUSELAGE_LENGTH * 0.8)
    spine.apply_translation([0, 0, FUSELAGE_LENGTH * 0.4])
    spine.visual.vertex_colors = [105, 105, 105, 255]  # Gris oscuro
    return spine

def create_dome():
    dome = trimesh.creation.icosphere(subdivisions=3, radius=1.2)
    dome.apply_scale([1.1, 1.1, 0.5])
    dome.apply_translation([0, 0, FUSELAGE_LENGTH + 2.6])
    dome.visual.vertex_colors = [135, 206, 250, 180]  # Azul cielo translúcido
    return dome

def combine_meshes(meshes):
    return trimesh.util.concatenate(meshes)

def plot_mesh(mesh, filename="Spacecraft_Falcon_Parker_Advanced.png"):
    fig = plt.figure(figsize=(14, 14))
    ax = fig.add_subplot(111, projection='3d')

    faces = mesh.faces
    vertices = mesh.vertices

    # Normalizar colores de las caras si existen
    face_colors = mesh.visual.face_colors / 255.0 if hasattr(mesh.visual, 'face_colors') else (0.2, 0.4, 0.6, 0.9)

    collection = Poly3DCollection(vertices[faces], alpha=0.9, linewidths=0.7, edgecolors=(0.1, 0.1, 0.1, 0.8))
    collection.set_facecolor(face_colors)
    ax.add_collection3d(collection)

    bounds = mesh.bounds
    margin = 3
    ax.set_xlim(bounds[0][0] - margin, bounds[1][0] + margin)
    ax.set_ylim(bounds[0][1] - margin, bounds[1][1] + margin)
    ax.set_zlim(bounds[0][2] - margin, bounds[1][2] + margin)

    ax.set_axis_off()
    ax.view_init(elev=35, azim=40)

    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    plt.close()
    print(f"Imagen renderizada guardada como: {filename}")

def main():
    components = [
        create_fuselage(),
        create_nose_cone(),
        create_escape_tower(),
        create_propulsion_base(),
        create_thermal_shield(),
        *create_reinforced_heat_shield_layers(),
        create_spine_structure(),
        create_scientific_module(),
        *create_merlin_engine_array(),
        *create_solar_panels(),
        *create_solar_panel_frames(),
        *create_radiator_panels(),
        *create_landing_legs(),
        *create_sensors(),
        *create_antenna_array(),
        create_robotic_arm(),
        create_dome(),
        create_payload_module()
    ]
    model = combine_meshes(components)
    plot_mesh(model, filename="Falcon_Parker_Advanced.png")

if __name__ == "__main__":
    main()
