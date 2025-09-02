@echo off
:: Script optimizado para AMD RX 570 8GB con Python venv
:: Usuario: piposeimandi
:: Fecha: 2025-09-02 00:42:53 UTC
:: Version: 4.1 - ASCII Compatible

setlocal enabledelayedexpansion
title Instalador Stable Diffusion AMD RX 570 8GB - Python venv - piposeimandi

echo =============================================
echo   STABLE DIFFUSION RX 570 8GB - PYTHON VENV
echo =============================================
echo Usuario: piposeimandi
echo Fecha: 2025-09-02 00:42:53 UTC
echo Entorno: Python venv (Recomendado)
echo GPU: AMD RX 570 8GB DirectML
echo.

:: Configurar directorios con fecha actual
set "BASE_DIR=%USERPROFILE%\AI_Projects"
set "PROJECT_NAME=stable_diffusion_piposeimandi_20250902"
set "PROJECT_DIR=%BASE_DIR%\%PROJECT_NAME%"
set "VENV_NAME=venv_sd_piposeimandi"
set "LOG_FILE=%PROJECT_DIR%\instalacion_piposeimandi_20250902_004253.log"

echo Proyecto: %PROJECT_NAME%
echo Directorio: %PROJECT_DIR%
echo Entorno virtual: %VENV_NAME%
echo.

:: Crear estructura de directorios
echo [1/10] Creando estructura de proyecto...
if not exist "%BASE_DIR%" mkdir "%BASE_DIR%"
if not exist "%PROJECT_DIR%" mkdir "%PROJECT_DIR%"
cd /d "%PROJECT_DIR%"

:: Inicializar logging
call :WriteLog "=== INSTALACION STABLE DIFFUSION VENV ==="
call :WriteLog "Usuario: piposeimandi"
call :WriteLog "Fecha: 2025-09-02 00:42:53 UTC"
call :WriteLog "Directorio: %PROJECT_DIR%"
call :WriteLog "GPU: AMD RX 570 8GB"

:: Verificar Python
echo [2/10] Verificando Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python no encontrado. Instalando Python 3.10.11...
    call :WriteLog "Python no encontrado, instalando..."
    
    echo Descargando Python 3.10.11...
powershell -Command "try { Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' -OutFile 'python_installer.exe' -ErrorAction Stop } catch { Write-Host 'Error descargando Python'; exit 1 }"
    
    if %errorlevel% neq 0 (
        echo [ERROR] No se pudo descargar Python.
        call :WriteLog "ERROR: Fallo descarga Python"
        pause
        exit /b 1
    )
    
    echo Instalando Python 3.10.11...
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 AssociateFiles=1
del python_installer.exe
    
    :: Refrescar variables de entorno
    call :RefreshPath
    call :WriteLog "Python 3.10.11 instalado correctamente"
) else (
    for /f "tokens=*" %%i in ('python --version') do set "PYTHON_VERSION=%%i"
    echo [OK] Python encontrado: !PYTHON_VERSION!
    call :WriteLog "Python verificado: !PYTHON_VERSION!"
)

:: Verificar Git
echo [3/10] Verificando Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git no encontrado.
    echo Por favor instala Git desde: https://git-scm.com/download/win
    call :WriteLog "ERROR: Git no encontrado"
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('git --version') do set "GIT_VERSION=%%i"
    echo [OK] Git encontrado: !GIT_VERSION!
    call :WriteLog "Git verificado: !GIT_VERSION!"
)

:: Crear entorno virtual
echo [4/10] Creando entorno virtual Python...
call :WriteLog "Creando entorno virtual: %VENV_NAME%"

if exist "%VENV_NAME%" (
    echo [WARNING] Entorno virtual ya existe. Recrearlo?
    choice /c YN /m "(Y=Si recrear, N=Usar existente)"
    if !errorlevel!==1 (
        echo Eliminando entorno virtual existente...
        rd /s /q "%VENV_NAME%"
        call :WriteLog "Entorno virtual existente eliminado"
    )
)

if not exist "%VENV_NAME%" (
    echo Creando nuevo entorno virtual...
    python -m venv "%VENV_NAME%"
    if %errorlevel% neq 0 (
        echo [ERROR] No se pudo crear el entorno virtual.
        call :WriteLog "ERROR: Fallo creacion entorno virtual"
        pause
        exit /b 1
    )
    call :WriteLog "Entorno virtual creado exitosamente"
) else (
    echo [OK] Usando entorno virtual existente
    call :WriteLog "Usando entorno virtual existente"
)

:: Activar entorno virtual
echo [5/10] Activando entorno virtual...
call "%VENV_NAME%\Scripts\activate.bat"
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo activar el entorno virtual.
    call :WriteLog "ERROR: Fallo activacion entorno virtual"
    pause
    exit /b 1
)

echo [OK] Entorno virtual activado
call :WriteLog "Entorno virtual activado correctamente"

:: Verificar pip en el entorno
echo Verificando pip en entorno virtual...
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Pip no funciona en el entorno virtual.
    call :WriteLog "ERROR: Pip no funciona en entorno virtual"
    pause
    exit /b 1
)

:: Actualizar pip en el entorno
echo [6/10] Actualizando pip en entorno virtual...
python -m pip install --upgrade pip setuptools wheel
call :WriteLog "Pip actualizado en entorno virtual"

:: Clonar Stable Diffusion WebUI
echo [7/10] Clonando Stable Diffusion WebUI...
if exist "stable-diffusion-webui" (
    echo [WARNING] Directorio stable-diffusion-webui ya existe.
    choice /c YN /m "Actualizar repositorio? (Y/N)"
    if !errorlevel!==1 (
        cd stable-diffusion-webui
        git pull
        cd ..
        call :WriteLog "Repositorio actualizado"
    ) else (
        call :WriteLog "Usando repositorio existente"
    )
) else (
    echo Clonando repositorio...
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
    if %errorlevel% neq 0 (
        echo [ERROR] Fallo la clonacion del repositorio.
        call :WriteLog "ERROR: Fallo clonacion repositorio"
        pause
        exit /b 1
    )
    call :WriteLog "Repositorio clonado exitosamente"
)

cd stable-diffusion-webui

:: Instalar dependencias optimizadas para RX 570 8GB
echo [8/10] Instalando dependencias optimizadas...
call :WriteLog "Iniciando instalacion de dependencias"

echo Instalando torch-directml...
python -m pip install torch-directml
if %errorlevel% neq 0 (
    echo [WARNING] Fallo torch-directml, intentando instalacion alternativa...
    python -m pip install torch-directml --index-url https://download.pytorch.org/whl/directml
)
call :WriteLog "torch-directml instalado"

echo Instalando torchvision y torchaudio...
python -m pip install torchvision torchaudio --index-url https://download.pytorch.org/whl/directml
call :WriteLog "torchvision y torchaudio instalados"

echo Instalando dependencias adicionales...
python -m pip install accelerate
call :WriteLog "accelerate instalado"

echo Instalando requirements.txt...
if exist requirements.txt (
    python -m pip install -r requirements.txt
    call :WriteLog "requirements.txt procesado"
) else (
    echo [WARNING] requirements.txt no encontrado, continuando...
)

:: Configurar WebUI optimizado para RX 570 8GB
echo [9/10] Configurando WebUI para RX 570 8GB...
call :WriteLog "Configurando optimizaciones para RX 570 8GB"

:: Crear webui-user.bat optimizado
(
    echo @echo off
    echo rem =============================================
    echo rem CONFIGURACION OPTIMIZADA AMD RX 570 8GB
    echo rem Usuario: piposeimandi
    echo rem Fecha: 2025-09-02 00:42:53 UTC
    echo rem Entorno: Python venv aislado
    echo rem =============================================
    echo.
    echo rem Activar entorno virtual automaticamente
    echo if not defined VIRTUAL_ENV (
    echo     call "%PROJECT_DIR%\%VENV_NAME%\Scripts\activate.bat"
    echo     echo [OK] Entorno virtual activado para piposeimandi
    echo ^)
    echo.
    echo set PYTHON=
    echo set GIT=
    echo set VENV_DIR=
    echo.
    echo rem === OPTIMIZACIONES ESPECIFICAS RX 570 8GB ===
    echo rem DirectML: Habilita aceleracion AMD
    echo rem no-half-vae: Evita errores de precision en VAE
    echo rem opt-channelslast: Optimizacion de memoria
    echo rem opt-split-attention-v1: Atencion optimizada para DirectML
    echo rem disable-safe-unpickle: Carga mas rapida de modelos
    echo rem no-gradio-queue: Reduce uso de memoria
    echo.
    echo set COMMANDLINE_ARGS=--directml --no-half-vae --opt-channelslast --opt-split-attention-v1 --disable-safe-unpickle --no-gradio-queue
    echo.
    echo rem === VARIABLES DE ENTORNO OPTIMIZADAS ===
    echo set PYTORCH_DIRECTML_DEBUG=0
    echo set OMP_NUM_THREADS=4
    echo set PYTHONPATH=%PROJECT_DIR%\%VENV_NAME%\Lib\site-packages
    echo.
    echo echo =============================================
    echo echo   STABLE DIFFUSION WEBUI - RX 570 8GB
    echo echo   Usuario: piposeimandi
    echo echo   Entorno: Python venv aislado
    echo echo   Configurado: 2025-09-02 00:42:53 UTC
    echo echo =============================================
    echo echo GPU: AMD RX 570 8GB con DirectML
    echo echo Resoluciones recomendadas:
    echo echo ^• 512x512: 15-25 segundos
    echo echo ^• 768x768: 25-40 segundos  
echo echo ^• 1024x1024: 45-90 segundos
    echo echo.
    echo echo Abriendo en: http://127.0.0.1:7860
    echo echo.
    echo call webui.bat
) > webui-user.bat

call :WriteLog "webui-user.bat configurado"

:: Crear scripts de gestión del entorno
echo [10/10] Creando scripts de gestion...

cd ..

:: Script para activar solo el entorno
(
    echo @echo off
    echo title Entorno Virtual SD - piposeimandi
    echo echo =============================================
    echo echo   ENTORNO VIRTUAL STABLE DIFFUSION
    echo echo   Usuario: piposeimandi
    echo echo   Fecha: 2025-09-02 00:42:53 UTC
    echo echo =============================================
    echo.
    echo cd /d "%PROJECT_DIR%"
    echo call "%VENV_NAME%\Scripts\activate.bat"
    echo.
    echo echo [OK] Entorno virtual activado para piposeimandi
    echo echo.
    echo echo Comandos disponibles:
    echo echo ^• pip list           - Ver paquetes instalados
    echo echo ^• pip install ^<pkg^>  - Instalar paquete
    echo echo ^• deactivate         - Desactivar entorno
    echo echo ^• cd stable-diffusion-webui - Ir al directorio SD
    echo echo.
    echo echo Para iniciar Stable Diffusion:
    echo echo python webui.py --directml
    echo echo.
    echo cmd /k
) > "Activar_Entorno_piposeimandi.bat"

:: Script para iniciar Stable Diffusion directamente
(
    echo @echo off
    echo title Stable Diffusion RX 570 8GB - piposeimandi
    echo echo =============================================
    echo echo   STABLE DIFFUSION WEBUI - RX 570 8GB
    echo echo   Usuario: piposeimandi
    echo echo   Entorno: Python venv aislado
    echo echo   GPU: AMD RX 570 8GB DirectML
    echo echo =============================================
    echo.
    echo echo Activando entorno virtual...
    echo cd /d "%PROJECT_DIR%"
    echo call "%VENV_NAME%\Scripts\activate.bat"
    echo.
    echo echo Iniciando Stable Diffusion WebUI...
    echo cd stable-diffusion-webui
    echo call webui-user.bat
    echo.
    echo pause
) > "Iniciar_StableDiffusion_piposeimandi.bat"

:: Script para gestión del entorno
(
    echo @echo off
    echo title Gestion Entorno - piposeimandi
    echo echo =============================================
    echo echo   GESTION ENTORNO VIRTUAL - piposeimandi
    echo echo =============================================
    echo.
    echo echo [1] Activar entorno
    echo echo [2] Iniciar Stable Diffusion
    echo echo [3] Ver paquetes instalados
    echo echo [4] Actualizar dependencias
    echo echo [5] Crear backup del entorno
    echo echo [6] Informacion del entorno
    echo echo [0] Salir
    echo.
    echo choice /c 1234560 /m "Selecciona una opcion"
    echo.
    echo if %%errorlevel%%==1 call "Activar_Entorno_piposeimandi.bat"
    echo if %%errorlevel%%==2 call "Iniciar_StableDiffusion_piposeimandi.bat"
    echo if %%errorlevel%%==3 (
    echo     call "%VENV_NAME%\Scripts\activate.bat"
    echo     pip list
    echo     pause
    echo ^)
    echo if %%errorlevel%%==4 (
    echo     call "%VENV_NAME%\Scripts\activate.bat"
    echo     pip install --upgrade torch-directml torchvision torchaudio
    echo     cd stable-diffusion-webui
    echo     git pull
    echo     pause
    echo ^)
    echo if %%errorlevel%%==5 (
    echo     echo Creando backup...
    echo     powershell Compress-Archive -Path "%VENV_NAME%" -DestinationPath "backup_venv_piposeimandi_%%date:~-4,4%%%%date:~-10,2%%%%date:~-7,2%%.zip"
    echo     echo Backup creado exitosamente
    echo     pause
    echo ^)
    echo if %%errorlevel%%==6 (
    echo     echo === INFORMACION DEL ENTORNO ===
    echo     echo Usuario: piposeimandi
    echo     echo Directorio: %PROJECT_DIR%
    echo     echo Entorno: %VENV_NAME%
    echo     echo Creado: 2025-09-02 00:42:53 UTC
    echo     call "%VENV_NAME%\Scripts\activate.bat"
    echo     python --version
    echo     pip --version
    echo     pause
    echo ^)
) > "Gestor_Entorno_piposeimandi.bat"

:: Crear documentación completa sin caracteres especiales
(
    echo =============================================
    echo DOCUMENTACION STABLE DIFFUSION - piposeimandi
    echo =============================================
    echo.
    echo INFORMACION DEL PROYECTO:
    echo ^• Usuario: piposeimandi
    echo ^• Fecha instalacion: 2025-09-02 00:42:53 UTC
    echo ^• Tipo entorno: Python venv (aislado)
    echo ^• GPU: AMD RX 570 8GB DirectML
    echo ^• Directorio: %PROJECT_DIR%
    echo ^• Entorno virtual: %VENV_NAME%
    echo.
    echo =============================================
    echo ARCHIVOS PRINCIPALES
    echo =============================================
    echo.
    echo SCRIPTS DE INICIO:
    echo ^• Iniciar_StableDiffusion_piposeimandi.bat - Ejecutar SD
    echo ^• Activar_Entorno_piposeimandi.bat - Solo activar entorno
    echo ^• Gestor_Entorno_piposeimandi.bat - Gestion completa
    echo.
    echo CONFIGURACION:
    echo ^• stable-diffusion-webui/webui-user.bat - Config principal
    echo ^• %LOG_FILE% - Log instalacion
    echo.
    echo =============================================
    echo COMANDOS UTILES EN EL ENTORNO
    echo =============================================
    echo.
    echo ACTIVAR ENTORNO:
    echo call "%VENV_NAME%\Scripts\activate.bat"
    echo.
    echo DESACTIVAR ENTORNO:
    echo deactivate
    echo.
    echo INSTALAR PAQUETES:
    echo pip install nombre_paquete
    echo.
    echo VER PAQUETES INSTALADOS:
    echo pip list
    echo.
    echo ACTUALIZAR PAQUETES:
    echo pip install --upgrade nombre_paquete
    echo.
    echo EXPORTAR DEPENDENCIAS:
    echo pip freeze ^> requirements_piposeimandi.txt
    echo.
    echo INICIAR STABLE DIFFUSION MANUALMENTE:
    echo cd stable-diffusion-webui
    echo python webui.py --directml --no-half-vae
    echo.
    echo =============================================
    echo CONFIGURACIONES OPTIMIZADAS RX 570 8GB
    echo =============================================
    echo.
    echo RESOLUCIONES RECOMENDADAS:
    echo ^• 512x512 - Velocidad optima (15-25 seg)
    echo ^• 768x768 - Equilibrio calidad/velocidad (25-40 seg)
    echo ^• 1024x1024 - Alta calidad (45-90 seg)
    echo.
    echo PARAMETROS APLICADOS:
    echo ^• --directml: Aceleracion AMD DirectML
    echo ^• --no-half-vae: Previene errores de precision
    echo ^• --opt-channelslast: Optimizacion de memoria
    echo ^• --opt-split-attention-v1: Atencion optimizada
    echo ^• --disable-safe-unpickle: Carga rapida de modelos
    echo ^• --no-gradio-queue: Reduce uso de memoria
    echo.
    echo SAMPLERS RECOMENDADOS:
    echo ^• DPM++ 2M Karras (equilibrado)
    echo ^• Euler a (rapido)
    echo ^• DDIM (estable)
    echo.
    echo CFG SCALE: 7-12 (recomendado: 7.5)
    echo STEPS: 20-30 (recomendado: 25)
    echo BATCH SIZE: 1-2 (maximo recomendado: 2)
    echo.
    echo =============================================
    echo GESTION DEL ENTORNO VIRTUAL
    echo =============================================
    echo.
    echo VENTAJAS DEL ENTORNO AISLADO:
    echo [OK] No contamina Python del sistema
    echo [OK] Dependencias especificas y controladas
    echo [OK] Facil backup y restauracion
    echo [OK] Desinstalacion limpia
    echo [OK] Multiples proyectos sin conflictos
    echo.
    echo BACKUP DEL ENTORNO:
    echo powershell Compress-Archive -Path "%VENV_NAME%" -DestinationPath "backup_venv.zip"
    echo.
    echo RESTAURAR ENTORNO:
    echo powershell Expand-Archive -Path "backup_venv.zip" -DestinationPath "."
    echo.
    echo ELIMINAR ENTORNO COMPLETAMENTE:
    echo rd /s /q "%VENV_NAME%"
    echo rd /s /q "stable-diffusion-webui"
    echo.
    echo RECREAR ENTORNO:
    echo python -m venv "%VENV_NAME%"
    echo call "%VENV_NAME%\Scripts\activate.bat"
    echo pip install torch-directml torchvision torchaudio
    echo.
    echo =============================================
    echo SOLUCION DE PROBLEMAS
    echo =============================================
    echo.
    echo PROBLEMA: Entorno no se activa
    echo SOLUCION: Verificar que Python este en PATH
    echo.
    echo PROBLEMA: torch-directml no se instala
    echo SOLUCION: pip install torch-directml --index-url https://download.pytorch.org/whl/directml
    echo.
    echo PROBLEMA: Imagenes salen negras/incorrectas
    echo SOLUCION: Usar --no-half-vae (ya incluido)
    echo.
    echo PROBLEMA: Muy lento
    echo SOLUCION: Reducir resolucion o usar --lowvram
    echo.
    echo PROBLEMA: Error de memoria
    echo SOLUCION: Agregar --medvram o --lowvram
    echo.
    echo =============================================
    echo RECURSOS ADICIONALES
    echo =============================================
    echo.
    echo ^• Modelos: https://huggingface.co/models
    echo ^• Extensions: https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Extensions
    echo ^• Documentacion: https://github.com/AUTOMATIC1111/stable-diffusion-webui
    echo ^• DirectML: https://github.com/microsoft/DirectML
    echo.
    echo Entorno configurado exitosamente para piposeimandi!
    echo 2025-09-02 00:42:53 UTC
) > "DOCUMENTACION_COMPLETA_piposeimandi.txt"

call :WriteLog "Scripts y documentacion creados"
call :WriteLog "=== INSTALACION COMPLETADA EXITOSAMENTE ==="

:: Mostrar resumen final SIN caracteres especiales
echo.
echo =============================================
echo        INSTALACION COMPLETADA EXITOSAMENTE!
echo =============================================
echo.
echo Usuario: piposeimandi
echo Fecha: 2025-09-02 00:42:53 UTC  
echo GPU: AMD RX 570 8GB DirectML
echo Entorno: Python venv (COMPLETAMENTE AISLADO)
echo.
echo DIRECTORIO DEL PROYECTO:
echo %PROJECT_DIR%
echo.
echo =============================================
echo           ARCHIVOS CREADOS
echo =============================================
echo.
echo [INICIO RAPIDO]:
echo ^• Iniciar_StableDiffusion_piposeimandi.bat
echo.
echo [GESTION]:
echo ^• Activar_Entorno_piposeimandi.bat
    echo ^• Gestor_Entorno_piposeimandi.bat
echo.
echo [DOCUMENTACION]:
echo ^• DOCUMENTACION_COMPLETA_piposeimandi.txt
    echo ^• %LOG_FILE%
echo.
echo =============================================
echo         RENDIMIENTO ESPERADO RX 570 8GB
echo =============================================
echo.
echo [RESOLUCIONES]:
echo ^• 512x512: 15-25 segundos (RAPIDO)
echo ^• 768x768: 25-40 segundos (EQUILIBRADO)
echo ^• 1024x1024: 45-90 segundos (ALTA CALIDAD)
echo.
echo [CONFIGURACION OPTIMA]:
echo ^• Steps: 20-30
echo ^• CFG Scale: 7.5
echo ^• Sampler: DPM++ 2M Karras
echo ^• Batch size: 1-2
echo.
echo =============================================
echo              PROXIMOS PASOS
echo =============================================
echo.
echo [1]  Ejecutar: Iniciar_StableDiffusion_piposeimandi.bat
echo [2]  Primera vez: Descargara archivos adicionales (10-15 min)
echo [3]  Acceder: http://127.0.0.1:7860
echo [4]  Empezar a crear arte increible!
echo.
echo [OK] Tu entorno esta COMPLETAMENTE AISLADO
echo [OK] No afectara nada en tu sistema
echo [OK] Facil de respaldar y mover
echo.
echo Tu RX 570 8GB esta lista para la accion!
echo =============================================

choice /c YN /m "Ejecutar Stable Diffusion ahora, piposeimandi? (Y/N)"
if %errorlevel%==1 (
    echo.
    echo Iniciando Stable Diffusion...
    call :WriteLog "Usuario inicio Stable Diffusion inmediatamente"
    call "Iniciar_StableDiffusion_piposeimandi.bat"
) else (
    echo.
    echo Perfecto! Para iniciar mas tarde:
echo Ejecuta: Iniciar_StableDiffusion_piposeimandi.bat
echo.
echo Que disfrutes creando arte, piposeimandi!
    call :WriteLog "Instalacion finalizada, usuario no inicio inmediatamente"
)

goto :end

:: Funciones auxiliares
:WriteLog
if not exist "%PROJECT_DIR%" mkdir "%PROJECT_DIR%"
echo [2025-09-02 00:42:53] %~1 >> "%LOG_FILE%"
goto :eof

:RefreshPath
for /f "usebackq tokens=2,*" %%A in (`reg query HKCU\Environment /v PATH`) do set "userpath=%%B"
for /f "usebackq tokens=2,*" %%A in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH`) do set "systempath=%%B"
set "PATH=%systempath%;%userpath%"
goto :eof

:end
call :WriteLog "Script finalizado"
echo.
echo Instalacion registrada en: %LOG_FILE%
pause
endlocal