import trimesh
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# Parámetros para módulos (naves) base de estación
BASE_MODULE_LENGTH = 40.0   # el doble de tu nave original
BASE_MODULE_RADIUS = 3.5    # más grueso

def create_base_module(length=BASE_MODULE_LENGTH, radius=BASE_MODULE_RADIUS, color=[70, 130, 180, 220]):
    # Módulo tipo nave grande (cilindro simple para rapidez)
    mod = trimesh.creation.cylinder(radius=radius, height=length)
    mod.apply_translation([0, 0, length/2])
    mod.visual.vertex_colors = color
    return mod

def create_connection_tunnel(length=12.0, radius=0.7, color=[128, 128, 128, 180]):
    tunnel = trimesh.creation.cylinder(radius=radius, height=length)
    tunnel.apply_translation([0, 0, length/2])
    tunnel.visual.vertex_colors = color
    return tunnel

def create_panel_large(position, size=(12, 0.1, 3), color=[30, 144, 255, 180]):
    panel = trimesh.creation.box(extents=size)
    panel.apply_translation(position)
    panel.visual.vertex_colors = color
    return panel

def create_antenna_cluster(position, count=10):
    antennas = []
    radius = 0.08
    height = 2.0
    for i in range(count):
        angle = 2 * np.pi * i / count
        x = position[0] + np.cos(angle) * 2.5
        y = position[1] + np.sin(angle) * 2.5
        z = position[2]
        mast = trimesh.creation.cylinder(radius=radius, height=height)
        mast.apply_translation([x, y, z + height / 2])
        mast.visual.vertex_colors = [200, 200, 200, 210]
        tip = trimesh.creation.icosphere(radius=0.1)
        tip.apply_translation([x, y, z + height])
        tip.visual.vertex_colors = [180, 180, 255, 230]
        antennas.extend([mast, tip])
    return antennas

def create_station_large():
    modules = []
    tunnels = []
    solar_panels = []
    antennas = []

    # Posiciones principales: módulo central + 3 módulos formando una T
    module_positions = [
        [0, 0, 0],                                # central
        [0, BASE_MODULE_RADIUS * 5, BASE_MODULE_LENGTH * 0.6],  # arriba
        [BASE_MODULE_RADIUS * 5, 0, BASE_MODULE_LENGTH * 0.6],  # derecha
        [-BASE_MODULE_RADIUS * 5, 0, BASE_MODULE_LENGTH * 0.6], # izquierda
    ]

    # Crear módulos
    for pos in module_positions:
        mod = create_base_module()
        mod.apply_translation(pos)
        modules.append(mod)

    # Crear conexiones (túneles) entre central y otros
    for pos in module_positions[1:]:
        vec = np.array(pos) - np.array(module_positions[0])
        dist = np.linalg.norm(vec)
        direction = vec / dist
        tunnel = create_connection_tunnel(length=dist - BASE_MODULE_RADIUS * 2)
        # Rotar túnel para alinear con dirección
        axis = np.cross([0, 0, 1], direction)
        angle = np.arccos(np.dot([0, 0, 1], direction))
        if np.linalg.norm(axis) > 1e-6:
            axis = axis / np.linalg.norm(axis)
            rot = trimesh.transformations.rotation_matrix(angle, axis)
            tunnel.apply_transform(rot)
        # Trasladar al punto medio
        midpoint = (np.array(module_positions[0]) + np.array(pos)) / 2
        tunnel.apply_translation(midpoint)
        tunnels.append(tunnel)

    # Añadir paneles solares grandes en módulo central
    solar_panels.append(create_panel_large(position=[0, BASE_MODULE_RADIUS + 1, BASE_MODULE_LENGTH * 0.5]))
    solar_panels.append(create_panel_large(position=[0, -BASE_MODULE_RADIUS - 1, BASE_MODULE_LENGTH * 0.5]))

    # Añadir cluster de antenas en módulo central arriba
    antennas.extend(create_antenna_cluster(position=[0, 0, BASE_MODULE_LENGTH + 5]))

    # Combinar todos los componentes
    all_parts = modules + tunnels + solar_panels + antennas
    station = trimesh.util.concatenate(all_parts)
    return station

def plot_mesh(mesh, filename="large_space_station.png"):
    fig = plt.figure(figsize=(18, 18))
    ax = fig.add_subplot(111, projection='3d')

    faces = mesh.faces
    vertices = mesh.vertices
    face_colors = mesh.visual.face_colors / 255.0 if hasattr(mesh.visual, 'face_colors') else (0.3, 0.5, 0.7, 0.9)

    collection = Poly3DCollection(vertices[faces], alpha=0.85, linewidths=0.6, edgecolors=(0.2, 0.2, 0.2, 0.7))
    collection.set_facecolor(face_colors)
    ax.add_collection3d(collection)

    bounds = mesh.bounds
    margin = 20
    ax.set_xlim(bounds[0][0] - margin, bounds[1][0] + margin)
    ax.set_ylim(bounds[0][1] - margin, bounds[1][1] + margin)
    ax.set_zlim(bounds[0][2] - margin, bounds[1][2] + margin)

    ax.set_axis_off()
    ax.view_init(elev=25, azim=45)

    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    plt.close()
    print(f"Estación espacial grande renderizada en {filename}")

if __name__ == "__main__":
    station = create_station_large()
    plot_mesh(station)
    station.export("large_space_station.stl")
    print("Archivo STL de estación espacial grande creado.")
