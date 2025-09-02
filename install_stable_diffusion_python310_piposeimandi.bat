@echo off
REM MIT License
REM 
REM Copyright (c) 2025 piposeimandi
REM 
REM Permission is hereby granted, free of charge, to any person obtaining a copy
REM of this software and associated documentation files (the "Software"), to deal
REM in the Software without restriction, including without limitation the rights
REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM copies of the Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:
REM 
REM The above copyright notice and this permission notice shall be included in all
REM copies or substantial portions of the Software.
REM 
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM SOFTWARE.

echo ========================================
echo Instalador Stable Diffusion para AMD RX 570 8GB
echo    Python 3.10.11 - piposeimandi
echo ========================================
echo.

REM Comprobar instalacion de Python 3.10
python --version | findstr "3.10.11" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python 3.10.11 no esta instalado o no esta en PATH.
    echo Por favor instala Python 3.10.11 y reinicia este script.
    pause
    exit /b 1
)

REM Instalar/actualizar pip
python -m ensurepip --upgrade
python -m pip install --upgrade pip

REM Instalar PyTorch ROCm (AMD) y demas dependencias principales
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/rocm5.4.2
pip install diffusers transformers

echo.
echo Instalacion completada exitosamente.
pause
