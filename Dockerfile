# 1. Imagen base oficial de Python (versión estable y ligera)
FROM python:3.11-slim

# 2. Configuración de variables de entorno
# Previene que Python escriba archivos .pyc y asegura salida de logs inmediata
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# 4. Instalar dependencias del sistema necesarias para psycopg2 y herramientas básicas
# Se limpian los archivos temporales para reducir el tamaño de la imagen
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 5. Instalar las dependencias de Python
# Copiamos primero solo el requirements para aprovechar la caché de Docker
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 6. Copiar el resto del código fuente del proyecto
COPY . .

# 7. Exponer el puerto (Render suele usar el 8000 o 10000 por defecto)
EXPOSE 8000

# 8. Comando para ejecutar la aplicación
# Asumiendo que tu punto de entrada es src/main.py
CMD ["python", "src/main.py"]