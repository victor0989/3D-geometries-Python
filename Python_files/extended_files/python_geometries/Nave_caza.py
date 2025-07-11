import trimesh
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
from trimesh.creation import torus

FUSELAGE_LENGTH = 18.0
FUSELAGE_RADIUS = 2.4

def create_advanced_fuselage():
    components = []
    main_body = trimesh.creation.cylinder(radius=FUSELAGE_RADIUS + 0.3, height=FUSELAGE_LENGTH)
    main_body.apply_translation([0, 0, FUSELAGE_LENGTH / 2])
    components.append(main_body)
    return combine_meshes(components)

def create_dome():
    dome = trimesh.creation.icosphere(subdivisions=3, radius=1.2)
    dome.apply_scale([1.1, 1.1, 1.4])  # Volumen vertical más alto
    dome.apply_translation([0, 0, FUSELAGE_LENGTH + 2.2])
    return dome

def create_landing_legs():
    legs = []
    angles = [np.pi / 4, 3 * np.pi / 4, -np.pi / 4, -3 * np.pi / 4]
    for angle in angles:
        x = np.cos(angle) * 1.8
        y = np.sin(angle) * 1.8
        leg = trimesh.creation.box(extents=[0.15, 0.15, 2.6])
        leg.apply_translation([x, y, -1.3])
        tilt = trimesh.transformations.rotation_matrix(np.radians(45), [1, 0, 0], point=[x, y, -1.3])
        leg.apply_transform(tilt)
        legs.append(leg)
    return legs

def combine_meshes(meshes):
    return trimesh.util.concatenate(meshes)

def plot_mesh(mesh, filename="Falcon_Parker_Enhanced_4.png"):
    fig = plt.figure(figsize=(14, 14))
    ax = fig.add_subplot(111, projection='3d')
    faces = mesh.faces
    vertices = mesh.vertices
    collection = Poly3DCollection(vertices[faces], alpha=0.9, linewidths=0.7, edgecolors=(0.1, 0.1, 0.1, 0.8))
    collection.set_facecolor((0.3, 0.5, 0.7, 0.8))
    ax.add_collection3d(collection)
    bounds = mesh.bounds
    margin = 3
    ax.set_xlim(bounds[0][0] - margin, bounds[1][0] + margin)
    ax.set_ylim(bounds[0][1] - margin, bounds[1][1] + margin)
    ax.set_zlim(bounds[0][2] - margin, bounds[1][2] + margin)
    ax.set_axis_off()
    ax.view_init(elev=55, azim=35)
    ax.dist = 6
    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    plt.close()

def main():
    components = [
        create_advanced_fuselage(),
        create_dome(),
        *create_landing_legs()
    ]
    model = combine_meshes(components)
    plot_mesh(model)
    model.export("falcon_parker_volume_fixed.stl")
    print("Modelo exportado como falcon_parker_volume_fixed.stl")

if __name__ == "__main__":
    main()
