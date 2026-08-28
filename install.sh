#!/usr/bin/env bash
set -euo pipefail
DRY_RUN=0; SKIP_PACKAGES=0
usage() { echo "Uso: ./install.sh [--dry-run] [--skip-packages]"; }
while [[ $# -gt 0 ]]; do
  case "$1" in --dry-run) DRY_RUN=1;; --skip-packages) SKIP_PACKAGES=1;; -h|--help) usage; exit;; *) usage >&2; exit 2;; esac
  shift
done
run() { printf '+ '; printf '%q ' "$@"; echo; (( DRY_RUN )) || "$@"; }
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
timestamp="$(date +%Y%m%d-%H%M%S)"

install_macos() {
  command -v brew >/dev/null || { echo "Instala Homebrew desde https://brew.sh" >&2; exit 1; }
  local p missing=()
  for p in starship zoxide fzf zsh-autosuggestions zsh-syntax-highlighting; do
    brew list --formula "$p" >/dev/null 2>&1 || missing+=("$p")
  done
  ((${#missing[@]} == 0)) || run brew install "${missing[@]}"
  command -v wezterm >/dev/null 2>&1 || run brew install --cask wezterm
  if (( DRY_RUN )); then run "$repo_dir/install-fonts.sh" --dry-run; else run "$repo_dir/install-fonts.sh"; fi
}

install_ubuntu() {
  command -v apt-get >/dev/null || { echo "Linux requiere Ubuntu/Debian con apt." >&2; exit 1; }
  local p missing=()
  for p in zsh fzf zsh-autosuggestions zsh-syntax-highlighting curl ca-certificates gnupg xz-utils fontconfig; do
    dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q 'ok installed' || missing+=("$p")
  done
  if ((${#missing[@]})); then run sudo apt-get update; run sudo apt-get install -y "${missing[@]}"; fi
  if ! command -v starship >/dev/null; then
    if (( DRY_RUN )); then echo "+ instalador oficial Starship -> $HOME/.local/bin"; else
      t="$(mktemp)"; curl -fsSL https://starship.rs/install.sh -o "$t"; sh "$t" --yes --bin-dir "$HOME/.local/bin"; rm -f "$t"
    fi
  fi
  if ! command -v zoxide >/dev/null; then
    if (( DRY_RUN )); then echo "+ instalador oficial zoxide -> $HOME/.local/bin"; else
      t="$(mktemp)"; curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -o "$t"; sh "$t"; rm -f "$t"
    fi
  fi
  if ! command -v wezterm >/dev/null; then
    if (( DRY_RUN )); then echo "+ repo oficial apt.fury.io/wez + apt install wezterm"; else
      t="$(mktemp)"; curl -fsSL https://apt.fury.io/wez/gpg.key -o "$t"
      gpg --dearmor <"$t" | sudo tee /usr/share/keyrings/wezterm-fury.gpg >/dev/null
      echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
      rm -f "$t"; sudo apt-get update; sudo apt-get install -y wezterm
    fi
  fi
  if (( DRY_RUN )); then run "$repo_dir/install-fonts.sh" --dry-run; else run "$repo_dir/install-fonts.sh"; fi
}

link_config() {
  local src="$1" dst="$2" current backup
  run mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]]; then current="$(readlink "$dst")"; [[ "$current" == "$src" ]] && { echo "Ya enlazado: $dst"; return; }; fi
  if [[ -e "$dst" || -L "$dst" ]]; then backup="$dst.backup-$timestamp"; run mv "$dst" "$backup"; echo "Backup: $backup"; fi
  run ln -s "$src" "$dst"
}

if (( ! SKIP_PACKAGES )); then
  case "$(uname -s)" in Darwin) install_macos;; Linux) install_ubuntu;; *) echo "Sistema no soportado" >&2; exit 1;; esac
else echo "Instalacion de paquetes omitida."; fi
link_config "$repo_dir/zshrc" "$HOME/.zshrc"
link_config "$repo_dir/starship.toml" "$HOME/.config/starship.toml"
if [[ "$repo_dir" != "$HOME/.config/wezterm" ]]; then link_config "$repo_dir/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"; else echo "WezTerm ya usa este repo."; fi
echo "Listo. Abri otra terminal o ejecuta: exec zsh"
