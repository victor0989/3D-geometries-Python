# main.py
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Física y estructura del material
def simulate_material_resistance(temperature, pressure, radiation):
    """ Simula resistencia térmica y estructural de un material compuesto """
    # Coeficiente sintético representativo
    base_resistance = 1000  # unidad arbitraria
    degradation = 0.02 * temperature + 0.03 * pressure + 0.01 * radiation
    final_resistance = base_resistance - degradation
    return final_resistance

# Parámetros extremos como en entorno solar o cerca de agujero negro
temperature = 6000  # Kelvin
pressure = 5000     # atm
radiation = 2000    # W/m² (nivel elevado de rayos gamma o X)

resistance = simulate_material_resistance(temperature, pressure, radiation)

print(f"Material resistance under extreme conditions: {resistance:.2f} units")

# Visualización
params = ['Temperature', 'Pressure', 'Radiation']
values = [temperature, pressure, radiation]

plt.bar(params, values, color='orange')
plt.title('Input Conditions for Material Simulation')
plt.ylabel('Magnitude')
plt.grid(True)
plt.savefig("simulation_conditions.png")
#plt.show()

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import trimesh

from common import combine_meshes, plot_mesh

# Importar directamente desde archivos del mismo directorio
from Pannels_antennaSolarParker_renderSpace import
from render_panels import create_render_panels
from alien_craft import create_alien_craft
from integration_parts import create_falcon_parker_advanced_ship
from stalattor_propulsion import create_stalattor_propulsion
from enterprise import create_enterprise_module
from starship_reactor import create_starship_reactor
from spacecraft_2d import create_spacecraft_2d_parts
from estacion import create_estacion


def simulate_material_resistance(temperature, pressure, radiation):
    base_resistance = 1000
    degradation = 0.02 * temperature + 0.03 * pressure + 0.01 * radiation
    return base_resistance - degradation


def main():
    # Simulación simple
    temperature, pressure, radiation = 6000, 5000, 2000
    resistance = simulate_material_resistance(temperature, pressure, radiation)
    print(f"Material resistance under extreme conditions: {resistance:.2f} units")

    # Visualización
    plt.bar(['Temperature', 'Pressure', 'Radiation'], [temperature, pressure, radiation], color='orange')
    plt.title('Input Conditions for Material Simulation')
    plt.ylabel('Magnitude')
    plt.grid(True)
    plt.savefig("simulation_conditions.png")

    # Ensamblaje de la supernave
    print("🛠️ Ensamblando todos los módulos...")

    components = [
        create_antenna_panels(),
        create_station_module(),
        create_render_panels(),
        create_alien_craft(),
        create_falcon_parker_advanced_ship(),
        create_stalattor_propulsion(),
        create_enterprise_module(),
        create_starship_reactor(),
        create_spacecraft_2d_parts(),
        create_estacion()
    ]

    full_model = combine_meshes(components)
    plot_mesh(full_model, filename="SuperNave_Final.png")
    full_model.export("SuperNave_Final.stl")
    print("✅ SuperNave_Final.stl exportado correctamente")


if __name__ == "__main__":
    main()


