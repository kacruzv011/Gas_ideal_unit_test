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
