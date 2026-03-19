### Introduccion
Este repositorio se trata de documentar la elaboracion y desarrollo de contenerizacion de entornos.
```bash

```
### 1. Fase de configuracion de entorno y repositorio.
Antes de escribir una sola línea de lógica, debemos preparar el ecosistema.
Como mi equipo personal es Cachy OS basado en arch Linux, me propuse a crear los archivos requeridos para el proyecto.

```bash
mkdir proyecto-ia-data && cd proyecto-ia-data
mkdir -p src tests docs .github/workflows
touch src/main.py src/utils.py .env .env.example .gitignore README.md Dockerfile requirements.txt
```

Luego inicializamos nuestro proyecto git en nuestra terminal de vs code.
```bash
git init
# Se inicializa el repositorio como proyecto-ia-data

git remote add origin https://github.com/spinozajose/Soluciones-de-datos-e-IA.git
```

### 2. Fase de desarrollo, logica y dependencias.
Para poder trabajar de forma segura y replicable debemos crear un entorno virtual.
```bash
python -m venv Entorno_Gestion_IA

~/Escritorio/Gestion de datos para IA/Soluciones de datos e IA
❯ source Entorno_Gestion_IA/bin/activate.fish
```
se podria crear de otra manera, pero ya habia trabajo de esta forma.

Preparamos las dependencias a partir de un archivo de requerimientos como (requeriments.txt)

```bash
# --- Core y Servidor ---
python-dotenv==1.0.1      # Gestión de variables de entorno (.env)
psycopg2-binary==2.9.9    # Driver para conexión a PostgreSQL (Supabase)

# --- Análisis de Datos e IA ---
pandas==2.2.1             # Manipulación de estructuras de datos
numpy==1.26.4             # Cálculos numéricos
scikit-learn==1.4.1       # Algoritmos de Machine Learning básicos

# --- Utilidades y Pruebas ---
requests==2.31.0          # Peticiones HTTP (Scraping o APIs externas)
pytest==8.0.2             # Framework para pruebas unitarias (CI/CD)
```
### 3. Preparamos el archivo docker.
Este archivo está configurado para ser ligero (usando una imagen slim) porque reduce la superficie de ataque (seguridad) y acelera el despliegue en la nube al ser mucho más pequeña que la versión completa. Ahora instalaremos las dependencias necesarias para que Python pueda comunicarse con la base de datos relacional.
```bash
# 1. Imagen base oficial de Python (versión estable y ligera)
FROM python:3.11-slim

# 2. Configuración de variables de entorno
# Previene que Python escriba archivos .pyc y asegura salida de logs inmediata
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

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
```

### Instrucciones de uso local.
En entornos linux, se puede probar rapidamente desde la terminal con:
```bash
# Construir la imagen
docker build -t proyecto-ia-data .
```


```bash
# Ejecutar el contenedor (cargando las variables de entorno):
docker run --env-file .env -p 8000:8000 proyecto-ia-data
```