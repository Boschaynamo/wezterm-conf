#!/usr/bin/env bash
set -euo pipefail
DRY_RUN=0
[[ "${1:-}" == --dry-run ]] && DRY_RUN=1 || { [[ $# -eq 0 ]] || { echo "Uso: $0 [--dry-run]" >&2; exit 2; }; }
run() { printf '+ '; printf '%q ' "$@"; echo; (( DRY_RUN )) || "$@"; }

case "$(uname -s)" in
  Darwin)
    command -v brew >/dev/null || { echo "Error: Homebrew es necesario." >&2; exit 1; }
    if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
      echo "JetBrainsMono Nerd Font ya esta instalada."; exit 0
    fi
    run brew install --cask font-jetbrains-mono-nerd-font
    ;;
  Linux)
    if command -v fc-list >/dev/null && fc-list : family 2>/dev/null | grep -Eqi 'JetBrainsMono Nerd Font|JetBrainsMono NF'; then
      echo "JetBrainsMono Nerd Font ya esta instalada."; exit 0
    fi
    command -v curl >/dev/null && command -v tar >/dev/null || { echo "Error: faltan curl o tar." >&2; exit 1; }
    font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerdFont"
    url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    if (( DRY_RUN )); then
      echo "+ descargar $url, extraer TTF en $font_dir y ejecutar fc-cache"; exit 0
    fi
    tmp_dir="$(mktemp -d)"; trap 'rm -rf "$tmp_dir"' EXIT
    run curl -fL --retry 3 --connect-timeout 15 -o "$tmp_dir/font.tar.xz" "$url"
    run mkdir -p "$font_dir"
    run tar -xJf "$tmp_dir/font.tar.xz" -C "$font_dir" --wildcards '*.ttf'
    run fc-cache -f "$font_dir"
    ;;
  *) echo "Sistema no soportado." >&2; exit 1 ;;
esac
