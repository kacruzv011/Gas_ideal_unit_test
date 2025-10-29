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
