#!/usr/bin/env bash
# Date: 2022-11-30
# Instalador para el gestor de descargas de Spotify (spotdl)

echo "[·] Comprobando dependencias..."

if ! command -v pip3 &>/dev/null; then
    echo "Dependencias incumplidas: python3-pip..."
    echo "[+] Actualizando fuentes..."
    (
        sudo apt update &> /dev/null
        echo "[+] Instalando dependencias (python3-pip)..."
        sudo apt install -y python3-pip
    )
fi

warning="\e[1m\e[4mDebe reinicar la sesión para completar la instalación.\e[0m"

[[ ! -d "${HOME}/.local/bin/" ]] && not_local_bin=true

export PATH="${HOME}/.local/bin:${PATH}"

echo "[+] Actualizando PIP..."
python3 -m pip install --upgrade --user pip

echo "[+] Instalando paquete requests..."
python3 -m pip install --upgrade --user requests

echo "[+] Instalando paquete testresources..."
python3 -m pip install --upgrade --user testresources

echo "[+] Instalando paquete spotdl..."
python3 -m pip install --upgrade --user spotdl

# Abre spotDL Web para poder acceder al icono de la aplicación
echo -e "\n[!] Ahora se abrirá la interfaz web de spotDL, debe cerrar la pestaña para finalizar la instalación."
echo "    Si no desea proseguir con la instalación del lanzador, pulse n para finalizar."

while true; do
    read -rp "    Desea continuar [S/n]: "
    case "$REPLY" in
        [Ss]) break
            ;;
        [Nn]) [ $not_local_bin ] && echo -e "$warning"
              echo "Instalación finalizada."
              exit
            ;;
        *) echo "  Seleccione una opción válida S/n."
            ;;
    esac
done

"${HOME}"/.local/bin/spotdl web

mkdir -pv "${HOME}"/.local/share/{applications,icons}
logo=("${HOME}"/.spotdl/dist/assets/spotdl*svg)
cp -v "$logo" "${HOME}"/.local/share/icons/spotdl.svg

echo "[+] Creando lanzador para la interfaz web..."
cat <<EOF > "${HOME}/.local/share/applications/spotdl.desktop"
[Desktop Entry]
Version=1.0
Name=SpotDL
Name[es]=SpotDL
Name[ca_ES.UTF-8@valencia]=SpotDL
Name[ca_ES@valencia]=SpotDL
Name[ca]=SpotDL
Name[ca_ES]=SpotDL
Comment=Download songs from Spotify
Comment[es]=Descarga canciones de Spotify
Comment[ca_ES.UTF-8@valencia]=Descarrega cançons de Spotify
Comment[ca_ES@valencia]=Descarrega cançons de Spotify
Comment[ca]=Descarrega cançons de Spotify
Comment[ca_ES]=Descarrega cançons de Spotify
Exec=spotdl web
Terminal=false
Icon=spotdl
Type=Application
Categories=Network;
TryExec=${HOME}/.local/bin/spotdl
EOF

[ $not_local_bin ] && echo -e "$warning"

cat <<EOF

===========================================
Instrucciones de uso:
  
Descargar una playlist:
  spotdl <url_playlist>

Lanzador spotDL en:
  Menú de aplicaciones > Internet
===========================================

EOF

echo "Instalación finalizada."

