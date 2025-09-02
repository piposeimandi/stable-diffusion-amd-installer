# Stable Diffusion AMD Installer

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Python Version](https://img.shields.io/badge/python-3.10.11-blue)

## Performance on AMD RX 570 8GB

| Metric                | Value                   |
|-----------------------|-------------------------|
| Inference Time        | X ms                    |
| FPS                   | Y FPS                   |
| Latency               | Z ms                    |
| Memory Usage          | A MB                    |


## Instalación y uso rápido

### 1. Clona este repositorio
```bash
git clone https://github.com/piposeimandi/stable-diffusion-amd-installer.git
cd stable-diffusion-amd-installer
```

### 2. Ejecuta el instalador automático

Abre una terminal (CMD o PowerShell) en la carpeta del repositorio y ejecuta:

```bat
inicio.bat
```
o, si usas PowerShell:
```powershell
cmd /c inicio.bat
```

### ¿Qué hace el script `inicio.bat`?

- Crea una carpeta de proyecto aislada en el mismo directorio donde lo ejecutas.
- Crea y activa un entorno virtual de Python (no afecta tu sistema).
- Verifica e instala Python 3.10.11 si es necesario.
- Verifica la presencia de Git.
- Clona (o actualiza) el repositorio AUTOMATIC1111/stable-diffusion-webui.
- Instala dependencias optimizadas para AMD RX 570 8GB y DirectML.
- Instala la extensión Deforum para generación de video.
- Genera scripts batch para activar el entorno, iniciar Stable Diffusion y gestionar el entorno.
- Crea documentación y logs de la instalación.

Al finalizar, tendrás todo listo para usar Stable Diffusion WebUI y Deforum en tu GPU AMD RX 570 8GB, de forma aislada y portable.

### Para iniciar Stable Diffusion

Ejecuta el script generado:
```bat
Iniciar_StableDiffusion.bat
```
Esto activará el entorno y lanzará la WebUI optimizada para tu GPU.

### Para gestión avanzada

Usa el script:
```bat
Gestor_Entorno.bat
```
Tendrás opciones para activar el entorno, actualizar dependencias, crear backups, ver información, etc.

---

## Troubleshooting

- **Issue: Installation Fails**
  - Solution: Ensure you have the correct version of Python and that all dependencies are installed.

- **Issue: Low Performance**
  - Solution: Verify that DirectML is installed and configured correctly.

- **Issue: Compatibility Errors**
  - Solution: Check for updates to the dependencies and ensure they are compatible with your system.

## Author

- **Name**: piposeimandi
- **Date**: 2025-09-02 01:48:59 UTC
