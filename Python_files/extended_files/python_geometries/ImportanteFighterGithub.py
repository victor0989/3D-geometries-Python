import trimesh
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

FUSELAGE_LENGTH = 20.0
FUSELAGE_BASE_RADIUS = 1.35
FUSELAGE_NOSE_HEIGHT = 4.0

def combine_meshes(meshes):
    return trimesh.util.concatenate(meshes)

# --- 1. Cuerpo troncocónico reforzado con bulkheads ---
def create_truncated_cone(base_radius, top_radius, height, sections=8):
    cone = trimesh.creation.cone(radius=base_radius, height=height)
    # Cortar parte superior para hacerlo truncado
    # Lo hacemos escalando la parte superior al top_radius
    vertices = cone.vertices.copy()
    # Encontrar el plano z = height - small offset para cortar
    cut_z = height * 0.85
    top_scale = top_radius / base_radius

    # Escalar vértices con z > cut_z hacia el eje Z y x,y
    for i, v in enumerate(vertices):
        if v[2] > cut_z:
            dz = v[2] - cut_z
            vertices[i, 2] = cut_z + dz * 1.0
            vertices[i, 0] *= top_scale
            vertices[i, 1] *= top_scale

    cone.vertices = vertices
    return cone

def create_internal_bulkheads(height, base_radius, count=5):
    bulkheads = []
    for i in range(1, count + 1):
        z = height * i / (count + 1)
        ring = trimesh.creation.torus(base_radius * (1 - 0.3 * (z / height)), 0.05)
        ring.apply_translation([0, 0, z])
        ring.visual.vertex_colors = [120, 120, 120, 220]  # gris medio translúcido
        bulkheads.append(ring)
    return bulkheads

def create_advanced_fuselage():
    components = []

    # Cuerpo troncocónico reforzado
    body = create_truncated_cone(FUSELAGE_BASE_RADIUS + 0.3, FUSELAGE_BASE_RADIUS * 0.6, FUSELAGE_LENGTH)
    body.apply_translation([0, 0, 0])
    body.visual.vertex_colors = [70, 130, 180, 255]  # Azul acero
    components.append(body)

    # Bulkheads internos
    components.extend(create_internal_bulkheads(FUSELAGE_LENGTH, FUSELAGE_BASE_RADIUS + 0.3, count=6))

    # Kevlar translúcido
    kevlar_layer = trimesh.creation.cylinder(radius=FUSELAGE_BASE_RADIUS + 0.4, height=FUSELAGE_LENGTH)
    kevlar_layer.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
    kevlar_layer.visual.vertex_colors = [184, 134, 11, 80]  # dorado translúcido kevlar
    components.append(kevlar_layer)

    return combine_meshes(components)

# --- 2. Domo hemisférico incrustado en la nariz ---
def create_embedded_hemisphere(radius=1.2):
    sphere = trimesh.creation.icosphere(subdivisions=3, radius=radius)
    # Cortar a hemisferio: conservar vértices con z >= 0
    vertices = sphere.vertices
    faces = []
    for face in sphere.faces:
        if all(vertices[face, 2] >= 0):
            faces.append(face)
    hemisphere = trimesh.Trimesh(vertices=vertices, faces=faces, process=False)
    # Incrustar: trasladar hacia dentro nariz
    hemisphere.apply_translation([0, 0, FUSELAGE_LENGTH - radius * 0.3])
    hemisphere.visual.vertex_colors = [135, 206, 250, 180]  # Azul cielo translúcido
    return hemisphere

# --- 3. Blindaje hexagonal con rotación e inclinación ---
def create_hex_panel(radius=0.5, thickness=0.1, tilt_deg=15):
    angle = np.pi / 3
    points = np.array([[np.cos(i * angle), np.sin(i * angle), 0] for i in range(6)])
    vertices = np.vstack([points, points + [0, 0, thickness]])

    faces = []
    for i in range(6):
        next_i = (i + 1) % 6
        faces.append([i, next_i, next_i + 6])
        faces.append([i, next_i + 6, i + 6])

    for i in range(1, 5):
        faces.append([0, i, i + 1])
    faces.append([0, 5, 1])
    for i in range(7, 11):
        faces.append([6, i, i + 1])
    faces.append([6, 11, 7])

    hex_mesh = trimesh.Trimesh(vertices=vertices, faces=faces, process=False)

    # Rotar y aplicar inclinación (tilt)
    tilt_rad = np.radians(tilt_deg)
    rot_tilt = trimesh.transformations.rotation_matrix(tilt_rad, [1, 0, 0])
    rot_y = trimesh.transformations.rotation_matrix(np.random.uniform(0, 2 * np.pi), [0, 0, 1])

    hex_mesh.apply_transform(rot_tilt)
    hex_mesh.apply_transform(rot_y)

    hex_mesh.visual.vertex_colors = [255, 140, 0, 180]  # naranja translúcido
    return hex_mesh

def create_hex_shield_layer(z_height, radius=3.3, panel_spacing=0.55):
    panels = []
    step = panel_spacing
    x_vals = np.arange(-radius, radius + step, step)
    y_vals = np.arange(-radius, radius + step, step * np.sqrt(3) / 2)

    for i, y in enumerate(y_vals):
        offset = 0 if i % 2 == 0 else step / 2
        for x in x_vals:
            pos_x = x + offset
            if pos_x ** 2 + y ** 2 <= radius ** 2:
                panel = create_hex_panel()
                panel.apply_translation([pos_x, y, z_height])
                panels.append(panel)
    return panels

# --- 4. Aletas delta truncadas ---
def create_delta_fin(size=(1.5, 0.8, 0.05)):
    # Triángulo delta truncado con base rectangular
    # Crear base con box y recortar con plano (aprox)
    fin = trimesh.creation.box(extents=size)
    # Cortar una esquina para hacer delta truncado
    vertices = fin.vertices
    mask = vertices[:, 0] > 0  # parte derecha
    mask &= vertices[:, 1] > 0  # parte arriba
    # Para simplicidad, bajamos esa esquina (recortamos en Z)
    vertices[mask, 2] *= 0.1
    fin.vertices = vertices
    fin.visual.vertex_colors = [100, 100, 140, 200]  # azul grisáceo translúcido
    return fin

def create_delta_fins():
    fins = []
    angles = [np.pi / 3, np.pi, 5 * np.pi / 3]
    for angle in angles:
        fin = create_delta_fin()
        # Posicionar alrededor del fuselaje, al nivel medio
        radius = FUSELAGE_BASE_RADIUS + 0.5
        x = np.cos(angle) * radius
        y = np.sin(angle) * radius
        fin.apply_translation([x, y, FUSELAGE_LENGTH / 2])
        # Rotar para alinear con radio
        rot = trimesh.transformations.rotation_matrix(angle + np.pi / 2, [0, 0, 1])
        fin.apply_transform(rot)
        fins.append(fin)
    return fins

# --- 5. Warp propulsor rediseñado ---
def create_warp_propulsor_complex(position, main_radius=0.8, length=3.5):
    components = []

    # Capa exterior anular (toroide)
    outer_torus = trimesh.creation.torus(main_radius + 0.15, 0.15)
    outer_torus.apply_translation([0, 0, length / 2])
    outer_torus.visual.vertex_colors = [50, 50, 80, 200]

    # Núcleo interno (cilindro)
    inner_cyl = trimesh.creation.cylinder(radius=main_radius, height=length * 0.9)
    inner_cyl.apply_translation([0, 0, length / 2 + 0.15])
    inner_cyl.visual.vertex_colors = [80, 80, 140, 240]

    # Tubos radiales internos
    for i in range(8):
        angle = 2 * np.pi * i / 8
        tube = trimesh.creation.cylinder(radius=0.05, height=length)
        x = np.cos(angle) * (main_radius + 0.3)
        y = np.sin(angle) * (main_radius + 0.3)
        tube.apply_translation([x, y, length / 2])
        tube.visual.vertex_colors = [150, 150, 200, 200]
        components.append(tube)

    components.extend([outer_torus, inner_cyl])

    warp_assembly = combine_meshes(components)
    warp_assembly.apply_translation(position)
    return warp_assembly

# --- Main assembling ---
def main():
    components = [
        create_advanced_fuselage(),
        create_embedded_hemisphere(),
        *create_hex_shield_layer(FUSELAGE_LENGTH + 0.6, radius=3.3),
        *create_hex_shield_layer(FUSELAGE_LENGTH + 0.8, radius=3.3),
        *create_delta_fins(),
        create_warp_propulsor_complex([FUSELAGE_BASE_RADIUS + 2.5, 0, 6]),
        create_warp_propulsor_complex([-FUSELAGE_BASE_RADIUS - 2.5, 0, 6]),
    ]

    model = combine_meshes(components)

    # Exportar STL
    model.export('futuristic_resistant_fighter.stl')
    print("STL exportado como 'futuristic_resistant_fighter.stl'")

    # Renderizado 3D (imagen)
    fig = plt.figure(figsize=(14, 14))
    ax = fig.add_subplot(111, projection='3d')
    faces = model.faces
    vertices = model.vertices
    face_colors = model.visual.face_colors / 255.0 if hasattr(model.visual, 'face_colors') else (0.2, 0.4, 0.6, 0.9)

    collection = Poly3DCollection(vertices[faces], alpha=0.9, linewidths=0.7, edgecolors=(0.1, 0.1, 0.1, 0.3))
    collection.set_facecolor(face_colors)
    ax.add_collection3d(collection)

    scale = model.extents
    ax.auto_scale_xyz([-scale[0], scale[0]], [-scale[1], scale[1]], [0, scale[2] * 1.2])

    ax.set_axis_off()
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    main()
