@echo off
echo === Verificando instalación de Stable Diffusion ===
python --version
if %errorlevel% neq 0 (
    echo Python no encontrado.
    exit /b 1
)
python -c "import torch; print('torch OK')"
if %errorlevel% neq 0 (
    echo PyTorch no instalado correctamente.
    exit /b 1
)
echo Instalacion verificada correctamente.
pause
