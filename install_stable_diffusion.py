import os
import subprocess
import sys
from pathlib import Path

# Configuración global
PROJECT_DIR = Path(__file__).parent
REPO_URL = "https://github.com/lshqqytiger/stable-diffusion-webui-directml.git"
PYTHON_VERSION = "3.10"
DEPENDENCIES = [
    "torch-directml",
    "torchvision",
    "torchaudio",
    "accelerate"
]


def check_python_version():
    if not sys.version.startswith(PYTHON_VERSION):
        print(f"[ERROR] Python {PYTHON_VERSION} es requerido. Versión actual: {sys.version}")
        sys.exit(1)

def check_git():
    try:
        subprocess.run(["git", "--version"], check=True, stdout=subprocess.PIPE)
    except FileNotFoundError:
        print("[ERROR] Git no está instalado. Por favor, instálalo y vuelve a intentar.")
        sys.exit(1)

def create_project_directory():
    # Crear el directorio dentro del proyecto actual
    PROJECT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"[INFO] Directorio de proyecto: {PROJECT_DIR}")

def clone_repository():
    repo_path = PROJECT_DIR / "stable-diffusion-webui-directml"
    if repo_path.exists():
        print("[INFO] El repositorio ya existe. Actualizando...")
        subprocess.run(["git", "-C", str(repo_path), "pull"], check=True)
    else:
        print("[INFO] Clonando el repositorio optimizado para DirectML...")
        subprocess.run(["git", "clone", REPO_URL, str(repo_path)], check=True)

def create_virtual_environment():
    venv_path = PROJECT_DIR / "stable-diffusion-webui-directml" / "venv"
    if not venv_path.exists():
        print("[INFO] Creando entorno virtual...")
        subprocess.run([sys.executable, "-m", "venv", str(venv_path)], check=True)
    else:
        print("[INFO] El entorno virtual ya existe.")
    return venv_path

def install_dependencies(venv_path):
    python_path = venv_path / "Scripts" / "python.exe"
    print("[INFO] Actualizando pip, setuptools y wheel...")
    subprocess.run([str(python_path), "-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel"], check=True)

    print("[INFO] Instalando dependencias optimizadas para AMD RX 570...")
    
    # Desinstalar todo relacionado con torch
    subprocess.run([str(python_path), "-m", "pip", "uninstall", "-y", "torch", "torchvision", "torchaudio", "torch-directml"], check=False)
    
    # Instalar torch-directml sin dependencias
    subprocess.run([str(python_path), "-m", "pip", "install", "--no-deps", "torch-directml==0.2.5.dev240914"], check=True)
    
    # Instalar otras dependencias necesarias
    subprocess.run([str(python_path), "-m", "pip", "install", "filelock", "typing_extensions", "sympy", "networkx", "jinja2", "fsspec", "numpy"], check=True)
    
    # Instalar versiones compatibles con torch 2.4.1 (requerido por torch-directml)
    subprocess.run([str(python_path), "-m", "pip", "install", "--no-deps", "torchvision==0.19.1"], check=True)
    subprocess.run([str(python_path), "-m", "pip", "install", "--no-deps", "torchaudio==2.4.1"], check=True)
    
    # Instalar accelerate con --no-deps para evitar que instale torch incompatible
    subprocess.run([str(python_path), "-m", "pip", "install", "--no-deps", "accelerate"], check=True)
    
    # Verificar que no exista torch estándar
    result = subprocess.run([str(python_path), "-m", "pip", "list"], capture_output=True, text=True, check=True)
    if "torch 2" in result.stdout and "torch-directml" not in result.stdout:
        print("[ADVERTENCIA] Se detectó torch estándar instalado. Desinstalando...")
        subprocess.run([str(python_path), "-m", "pip", "uninstall", "-y", "torch"], check=False)
        subprocess.run([str(python_path), "-m", "pip", "install", "torch-directml"], check=True)

def modify_requirements():
    requirements_path = PROJECT_DIR / "stable-diffusion-webui-directml" / "requirements.txt"
    if requirements_path.exists():
        print("[INFO] Modificando requirements.txt para compatibilidad con AMD RX 570...")
        # Leer el contenido actual
        with open(requirements_path, "r") as f:
            content = f.read()
        
        # Reemplazar cualquier referencia a torch estándar
        content = content.replace("torch==", "# torch==")
        content = content.replace("torch>=", "# torch>=")
        
        # Escribir el contenido modificado
        with open(requirements_path, "w") as f:
            f.write(content)
            f.write("\n# Dependencias para AMD RX 570\n")
            f.write("torch-directml\n")

def modify_webui_user_bat():
    print("[INFO] Modificando webui-user.bat para compatibilidad con AMD RX 570...")
    webui_bat_path = PROJECT_DIR / "stable-diffusion-webui-directml" / "webui-user.bat"
    if webui_bat_path.exists():
        with open(webui_bat_path, "r") as f:
            content = f.read()
        
        # Actualizar de --directml a --use-directml
        if "set COMMANDLINE_ARGS=" not in content:
            with open(webui_bat_path, "a") as f:
                f.write("\nset COMMANDLINE_ARGS=--skip-torch-cuda-test --no-half --use-directml\n")
            print("[INFO] Argumentos de línea de comando añadidos a webui-user.bat.")
        elif "--directml" in content:
            # Reemplazar --directml por --use-directml
            content = content.replace("--directml", "--use-directml")
            with open(webui_bat_path, "w") as f:
                f.write(content)
            print("[INFO] Argumentos de línea de comando actualizados en webui-user.bat.")
        else:
            print("[INFO] Los argumentos ya están configurados en webui-user.bat.")
    else:
        print("[WARNING] No se encontró el archivo webui-user.bat para modificar.")

def main():
    print("[INFO] Iniciando instalación de Stable Diffusion para AMD RX 570...")
    check_python_version()
    check_git()
    create_project_directory()
    clone_repository()
    modify_webui_user_bat()
    venv_path = create_virtual_environment()
    install_dependencies(venv_path)
    modify_requirements()
    print("[INFO] Instalación completada. Intentando iniciar Stable Diffusion...")

    # Verificar si launch.py existe
    launch_py = PROJECT_DIR / "stable-diffusion-webui-directml" / "launch.py"
    if not launch_py.exists():
        print("[ERROR] No se encontró el archivo launch.py. Verifica la clonación del repositorio.")
        sys.exit(1)

    # Ejecutar directamente launch.py con el intérprete de Python del entorno virtual
    python_path = venv_path / "Scripts" / "python.exe"
    try:
        # Cambiar al directorio de trabajo correcto
        os.chdir(str(PROJECT_DIR / "stable-diffusion-webui-directml"))
        # Agregar los argumentos necesarios para optimizar memoria de forma más agresiva
        cmd_args = [
            "--skip-torch-cuda-test", 
            "--no-half-vae",         # Evita problemas con VAE
            "--use-directml",        # Para AMD DirectML
            "--lowvram",             # Opción más agresiva que --medvram
            "--opt-channelslast",    # Optimiza disposición de memoria
            "--disable-nan-check",   # Ahorra memoria adicional
            "--disable-opt-split-attention", # Desactiva optimización problemática
            "--opt-sdp-no-mem-attention"     # Usa atención SDP que consume menos memoria
        ]
        print(f"[INFO] Ejecutando: {python_path} {launch_py} {' '.join(cmd_args)}")
        subprocess.run([str(python_path), str(launch_py)] + cmd_args, check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Falló al intentar ejecutar launch.py: {e}")
        print("[INFO] Puedes intentar iniciar manualmente con:")
        print(f"cd {PROJECT_DIR / 'stable-diffusion-webui-directml'}")
        print(f"{python_path} {launch_py} --skip-torch-cuda-test --no-half-vae --use-directml --lowvram --opt-channelslast --disable-nan-check --disable-opt-split-attention --opt-sdp-no-mem-attention")

if __name__ == "__main__":
    main()
