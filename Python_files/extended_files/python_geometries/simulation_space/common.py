# common.py
import trimesh
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

def combine_meshes(meshes):
    return trimesh.util.concatenate(meshes)

def plot_mesh(mesh, filename="ship_model.png"):
    fig = plt.figure(figsize=(12, 12))
    ax = fig.add_subplot(111, projection='3d')

    faces = mesh.faces
    vertices = mesh.vertices
    face_colors = mesh.visual.face_colors / 255.0 if hasattr(mesh.visual, 'face_colors') else (0.3, 0.3, 0.5, 0.8)

    collection = Poly3DCollection(vertices[faces], alpha=0.9, edgecolors=(0.2, 0.2, 0.2, 0.5))
    collection.set_facecolor(face_colors)
    ax.add_collection3d(collection)

    bounds = mesh.bounds
    margin = 2
    ax.set_xlim(bounds[0][0] - margin, bounds[1][0] + margin)
    ax.set_ylim(bounds[0][1] - margin, bounds[1][1] + margin)
    ax.set_zlim(bounds[0][2] - margin, bounds[1][2] + margin)
    ax.set_axis_off()

    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    plt.close()
    print(f"🛰️ Imagen guardada como {filename}")
