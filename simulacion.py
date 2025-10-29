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
