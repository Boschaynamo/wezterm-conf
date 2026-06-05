#!/usr/bin/env bash
# Instala la fuente SF Mono (la que usa wezterm.lua) en Linux.
#
# SF Mono es propietaria de Apple, por eso NO se commitea al repo.
#   - macOS:  brew install --cask font-sf-mono
#   - Linux:  ./install-fonts.sh   (este script la descarga e instala)
#
# Fuente: repo comunitario con los .otf extraidos del instalador oficial.
set -euo pipefail

FONT_DIR="${HOME}/.local/share/fonts"
ARCHIVE_URL="https://github.com/supercomputra/SF-Mono-Font/archive/refs/heads/master.zip"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

if fc-list : family | grep -i "sf mono" >/dev/null 2>&1; then
	echo "SF Mono ya esta instalada. Nada que hacer."
	exit 0
fi

echo "Descargando SF Mono..."
curl -sL --max-time 120 -o "${TMP_DIR}/sfmono.zip" "${ARCHIVE_URL}"

echo "Extrayendo..."
unzip -o -q "${TMP_DIR}/sfmono.zip" -d "${TMP_DIR}"

echo "Instalando en ${FONT_DIR}..."
install -d "${FONT_DIR}"
find "${TMP_DIR}" -iname "SFMono-*.otf" -exec cp {} "${FONT_DIR}/" \;

echo "Refrescando cache de fuentes..."
fc-cache -f "${FONT_DIR}" >/dev/null

if fc-list : family | grep -i "sf mono" >/dev/null 2>&1; then
	echo "Listo. SF Mono instalada. Reinicia WezTerm (o Ctrl+Shift+R)."
else
	echo "ERROR: la instalacion no quedo registrada." >&2
	exit 1
fi
