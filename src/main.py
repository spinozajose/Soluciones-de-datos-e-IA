import time

print("--- Iniciando Solución de IA en CachyOS ---")


try:
    while True:
        print("IA activa y esperando... (Presiona Ctrl+C para detener)")
        time.sleep(30) # Imprime cada 30 segundos para no saturar el log
except KeyboardInterrupt:
    print("Cerrando contenedor de forma segura.")