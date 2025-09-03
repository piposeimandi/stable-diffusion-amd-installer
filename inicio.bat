@echo off
title Instalador Stable Diffusion AMD RX 570 8GB - DirectML
echo =============================================
echo   STABLE DIFFUSION RX 570 8GB - DirectML
echo =============================================
echo.

:: 1. Verificar Python y Git
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python no encontrado. Instala Python 3.10.x y reinicia este script.
    pause
    exit /b 1
)
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git no encontrado. Instala Git y reinicia este script.
    pause
    exit /b 1
)

:: 2. Clonar repositorios si no existen

if not exist "stable-diffusion-webui" (
    echo Clonando Stable Diffusion WebUI (DirectML fork)...
    git clone https://github.com/microsoft/DirectML.git --branch main --single-branch --depth 1 stable-diffusion-webui
    if exist "stable-diffusion-webui\StableDiffusionWebUI" (
        echo Moviendo archivos de StableDiffusionWebUI...
        pushd "stable-diffusion-webui\StableDiffusionWebUI"
        for %%F in (*) do move "%%F" "..\"
        for /d %%D in (*) do move "%%D" "..\"
        popd
        rmdir /s /q "stable-diffusion-webui\StableDiffusionWebUI"
    )
) else (
    echo [OK] stable-diffusion-webui ya existe.
)

if not exist "stable-diffusion-webui\extensions\deforum-for-automatic1111-webui" (
    echo Clonando extensión Deforum...
    git clone https://github.com/deforum-art/deforum-for-automatic1111-webui.git "stable-diffusion-webui/extensions/deforum-for-automatic1111-webui"
) else (
    echo [OK] Deforum ya está instalado.
)


:: 2.5. Cambiar a la carpeta del proyecto si existe
if exist "stable-diffusion-webui" (
    cd stable-diffusion-webui
) else (
    echo [ERROR] No se encontró la carpeta stable-diffusion-webui. Abortando.
    pause
    exit /b 1
)

:: 3. Parchear requirements.txt para DirectML y pydantic
if exist requirements.txt (
    copy requirements.txt requirements.txt.bak
    powershell -Command "(Get-Content requirements.txt) -replace 'torch==.*', 'torch-directml' | ForEach-Object { $_ -replace 'torchvision==.*', 'torchvision' } | ForEach-Object { $_ -replace 'torchaudio==.*', '' } | Where-Object { \\$_ -notmatch '^\\s*$' } | Set-Content requirements.txt"
    powershell -Command "if (-not (Select-String -Path requirements.txt -Pattern '^pydantic==1.10.14$')) { Add-Content requirements.txt 'pydantic==1.10.14' }"
    echo [OK] requirements.txt modificado para DirectML y pydantic 1.10.14
) else (
    echo [WARNING] requirements.txt no encontrado.
)

:: 4. Instalar dependencias usando el venv del repo

echo Instalando dependencias y entorno virtual...
:: Llama al instalador principal del repo, que creará el venv y resolverá dependencias
call webui.bat --no-half-vae --opt-channelslast --opt-split-attention-v1 --disable-safe-unpickle --no-gradio-queue --skip-torch-cuda-test

echo =============================================
echo Instalación automatizada finalizada.
echo Si hay errores de dependencias, revisa requirements.txt y repite el proceso.
echo =============================================
pause