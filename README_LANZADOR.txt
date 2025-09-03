# Lanzador rápido Stable Diffusion WebUI (DirectML)

Ejecuta `Iniciar_StableDiffusion.bat` para iniciar la WebUI con la configuración recomendada para AMD RX 570 8GB y DirectML.

No es necesario activar ningún entorno virtual externo. Todo se gestiona dentro del propio repositorio.

---

**Comando equivalente manual:**

    cd stable-diffusion-webui
    call webui.bat --no-half-vae --opt-channelslast --opt-split-attention-v1 --disable-safe-unpickle --no-gradio-queue --skip-torch-cuda-test

---

Si tienes problemas, revisa el archivo `requirements.txt` dentro de la carpeta del repo.
