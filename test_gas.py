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
