@echo off
echo =============================================
echo   STABLE DIFFUSION WEBUI - RX 570 8GB
echo   (DirectML - AMD)
echo =============================================
cd /d "%~dp0stable-diffusion-webui"
call webui.bat --no-half-vae --opt-channelslast --opt-split-attention-v1 --disable-safe-unpickle --no-gradio-queue --skip-torch-cuda-test
pause
