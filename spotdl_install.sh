#!/usr/bin/env bash
# Date: 2022-01-21
# Instalador para el gestor de descargas de Spotify (spotdl)

echo "+ Comprobando dependencias..."

if ! command -v pip3 &>/dev/null; then
    echo "Dependencias incumplidas: python3-pip..."
    echo "+ Actualizando fuentes..."
    (
        sudo apt update &> /dev/null
        echo "+ Instalando dependencias (python3-pip)..."
        sudo apt install -y python3-pip
    )
fi

uso[0]="Reiniciar la sesión y abrir un Terminal."
uso[1]="Abrir un Terminal."

[[ -d "${HOME}/.local/bin/" ]] && index=1

echo "+ Instalando paquete spotdl..."
python3 -m pip install --upgrade --user spotdl

echo "+ Instalando paquete testresources..."
python3 -m pip install --upgrade --user testresources
echo "Instalando paquete requests..."
python3 -m pip install --upgrade --user requests

echo "+ Creando alias para spotdl -> spotify..."
echo 'alias spotify="${HOME}/.local/bin/spotdl"' >> "${HOME}/.bash_aliases"
source "${HOME}/.bash_aliases"

cat <<EOF

===========================================
Instrucciones de uso:
  ${uso[${index:-0}]}

Crear una carpeta y entrar en ella:
  mkdir spotify_music && cd spotify_music
  
Descargar una playlist:
  spotify <url_playlist>
===========================================

EOF

echo "Instalación finalizada."

