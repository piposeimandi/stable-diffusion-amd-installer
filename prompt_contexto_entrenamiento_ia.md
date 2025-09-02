# Contexto y objetivos del proyecto

Se está trabajando en la automatización e instalación optimizada de Stable Diffusion (en su versión WebUI AUTOMATIC1111) para tarjetas gráficas AMD RX 570 8GB, utilizando un entorno aislado de Python (venv) en Windows, dirigido a usuarios técnicos que desean una experiencia controlada, reproducible y fácil de restaurar.

## Detalles técnicos y de proceso

- El usuario principal es “piposeimandi”, y el objetivo es lograr que cualquier usuario con una RX 570 8GB pueda instalar y correr Stable Diffusion WebUI en su equipo, usando DirectML para aprovechar la aceleración AMD, sin contaminar el sistema y con scripts de gestión completos.
- El flujo contempla:
  - Verificación e instalación automática de Python 3.10.11 (si no está presente).
  - Verificación de Git (y aviso si falta).
  - Creación de directorios de proyecto bajo %USERPROFILE%\AI_Projects con nombres fechados para identificar cada setup.
  - Creación y activación de entorno virtual Python aislado.
  - Instalación y actualización automática de pip, setuptools y wheel en el venv.
  - Clonado (o actualización) del repositorio AUTOMATIC1111/stable-diffusion-webui.
  - Instalación de dependencias optimizadas para DirectML: torch-directml, torchvision, torchaudio y accelerate (usando el índice oficial de DirectML).
  - Instalación de requirements.txt si está presente.
  - Generación automática de scripts batch para:
    - Activar el entorno virtual.
    - Iniciar Stable Diffusion WebUI con parámetros optimizados para RX 570 8GB (--directml, --no-half-vae, etc.).
    - Gestión y backup del entorno (gestor interactivo por batch).
    - Documentación completa del entorno, pasos de troubleshooting, parámetros recomendados y recursos útiles.
- Todos los scripts y documentación se generan en el directorio del proyecto y están nombrados con el sufijo “piposeimandi” y la fecha de la instalación para facilitar la trazabilidad.
- Los scripts están escritos en batch (Windows) y no usan caracteres especiales para máxima compatibilidad.
- La finalidad es obtener un entorno completamente aislado, fácil de borrar, respaldar, restaurar o migrar entre máquinas, sin afectar la instalación global de Python o requerir privilegios de administrador, salvo para instalar Python si es necesario.
- El proceso está pensado para ser robusto: con logs de cada paso, gestión de errores y avisos claros al usuario.
- Al finalizar, se ofrecen recomendaciones de parámetros para Batch Size, CFG Scale, Steps y samplers recomendados, además de links a recursos de modelos y extensiones.
- Se provee documentación y scripts para troubleshooting frecuente (problemas de activación, errores de torch-directml, etc.).

## Objetivo del entrenamiento de la IA

La IA debe:
- Comprender el flujo y los objetivos del proyecto.
- Poder explicar, guiar y generar scripts o documentación para usuarios que quieran reproducir o adaptar este setup.
- Responder dudas técnicas sobre los pasos, dependencias o configuraciones.
- Sugerir mejoras, troubleshooting y personalizaciones para otros modelos AMD similares.
- Mantener el enfoque en la robustez, aislamiento y reproducibilidad del entorno.

# Ejemplo de workflow resumido

1. Ejecutar el instalador batch principal.
2. El script verifica Python/Git, instala lo necesario.
3. Configura el entorno, clona el repo y prepara todo.
4. El usuario puede iniciar Stable Diffusion con un script dedicado, gestionar el entorno o leer la documentación generada.

# Tono y estilo esperado para la IA

- Profesional, técnico, claro y didáctico.
- Las respuestas deben ser detalladas, pero sin tecnicismos innecesarios para usuarios avanzados.
- Siempre debe priorizar la compatibilidad, la reproducibilidad y la facilidad de respaldo/migración del entorno.

# Palabras clave

Stable Diffusion, AMD RX 570 8GB, DirectML, Python venv, entorno aislado, batch script, instalación automatizada, reproducibilidad, troubleshooting, piposeimandi.