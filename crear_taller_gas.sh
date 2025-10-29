#!/bin/bash
# ===============================================================
# Script completo: Simulación de un Gas Ideal en una Caja
# Crea toda la estructura, instala dependencias y ejecuta pruebas
# ===============================================================

set -e

echo "=============================================="
echo "  🚀 Creando proyecto: Simulación de un Gas Ideal"
echo "=============================================="


# 2️⃣ Crear archivo particula.py
cat > particula.py << 'EOF'
import numpy as np

class Particula:
    """Clase que representa una partícula del gas ideal."""

    def __init__(self, x, y, vx, vy, m=1.0):
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
        self.m = m

    def mover(self, dt):
        """Actualiza la posición según la velocidad actual."""
        self.x += self.vx * dt
        self.y += self.vy * dt

    def colisionar_pared(self, ancho, alto):
        """Refleja la velocidad al chocar con las paredes."""
        if self.x <= 0 or self.x >= ancho:
            self.vx *= -1
            self.x = np.clip(self.x, 0, ancho)
        if self.y <= 0 or self.y >= alto:
            self.vy *= -1
            self.y = np.clip(self.y, 0, alto)

    def energia_cinetica(self):
        """Devuelve la energía cinética de la partícula."""
        return 0.5 * self.m * (self.vx**2 + self.vy**2)
EOF

# 3️⃣ Crear archivo simulacion.py
cat > simulacion.py << 'EOF'
import numpy as np
from particula import Particula

def crear_gas(N, ancho, alto, v_media):
    """Genera N partículas con posiciones y velocidades aleatorias."""
    particulas = []
    for _ in range(N):
        x = np.random.uniform(0, ancho)
        y = np.random.uniform(0, alto)
        ang = np.random.uniform(0, 2*np.pi)
        v = v_media * np.random.uniform(0.8, 1.2)
        vx = v * np.cos(ang)
        vy = v * np.sin(ang)
        particulas.append(Particula(x, y, vx, vy))
    return particulas

def paso(particulas, dt, ancho, alto):
    """Avanza un paso temporal en la simulación."""
    for p in particulas:
        p.mover(dt)
        p.colisionar_pared(ancho, alto)

def energia_total(particulas):
    """Calcula la energía total del sistema."""
    return sum(p.energia_cinetica() for p in particulas)

def temperatura(particulas, k_B=1.38e-23):
    """Calcula la temperatura efectiva del gas."""
    E_prom = np.mean([p.energia_cinetica() for p in particulas])
    return (2/2) * E_prom / k_B  # 2 grados de libertad (x,y)
EOF

# 4️⃣ Crear archivo test_gas.py
cat > test_gas.py << 'EOF'
import unittest
import numpy as np
from particula import Particula
from simulacion import crear_gas, paso, energia_total, temperatura

class TestGasIdeal(unittest.TestCase):

    def test_creacion(self):
        gas = crear_gas(10, 10, 10, 1)
        self.assertEqual(len(gas), 10)

    def test_movimiento_y_colisiones(self):
        p = Particula(0.5, 0.5, 1.0, 0.0)
        p.mover(1)
        self.assertGreater(p.x, 0)
        p.colisionar_pared(1, 1)
        self.assertTrue(0 <= p.x <= 1)

    def test_energia_total(self):
        gas = crear_gas(20, 10, 10, 1)
        E = energia_total(gas)
        self.assertGreater(E, 0)

    def test_conservacion_energia(self):
        gas = crear_gas(50, 10, 10, 1)
        E_inicial = energia_total(gas)
        for _ in range(100):
            paso(gas, 0.01, 10, 10)
        E_final = energia_total(gas)
        variacion = abs(E_final - E_inicial) / E_inicial
        self.assertLess(variacion, 0.05)

    def test_temperatura(self):
        gas = crear_gas(10, 10, 10, 2)
        T1 = temperatura(gas)
        gas2 = crear_gas(10, 10, 10, 4)
        T2 = temperatura(gas2)
        self.assertGreater(T2, T1)

if __name__ == '__main__':
    unittest.main()
EOF

# 5️⃣ Crear archivo graficar.py
cat > graficar.py << 'EOF'
import matplotlib.pyplot as plt
from simulacion import crear_gas, paso

def graficar(N=30, ancho=10, alto=10, v_media=1.0, pasos=500, dt=0.05):
    gas = crear_gas(N, ancho, alto, v_media)
    fig, ax = plt.subplots()
    ax.set_xlim(0, ancho)
    ax.set_ylim(0, alto)
    puntos, = ax.plot([], [], 'bo', ms=4)
    ax.set_title("Simulación de Gas Ideal en una Caja")
    ax.set_xlabel("x")
    ax.set_ylabel("y")

    for _ in range(pasos):
        paso(gas, dt, ancho, alto)
        puntos.set_data([p.x for p in gas], [p.y for p in gas])
        plt.pause(0.01)
    plt.show()

if __name__ == "__main__":
    graficar()
EOF

# 6️⃣ Crear archivo README.md
cat > README.md << 'EOF'
# Simulación de un Gas Ideal en una Caja

### Descripción
Este proyecto simula el movimiento aleatorio de N partículas que colisionan elásticamente con las paredes del contenedor, modelando el comportamiento de un gas ideal.

### Requisitos
- Python 3.10+
- Librerías: `numpy`, `matplotlib`

### Estructura
particula.py
simulacion.py
test_gas.py
graficar.py


### Ejecución
```bash
python -m unittest test_gas.py -v
python graficar.py
Autor

Generado automáticamente por crear_taller_gas.sh.
EOF

echo "=============================================="
echo "✅ Archivos creados correctamente."
echo "Ejecuta ahora:"
echo " python -m unittest test_gas.py -v"
echo " python graficar.py"
echo "=============================================="