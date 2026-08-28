# Terminal portable: WezTerm + Zsh + Starship

Configuracion moderna, minimalista y sin frameworks para una UX consistente en macOS y Ubuntu: WezTerm, Zsh, Starship, fzf, zoxide, autosuggestions, syntax highlighting y JetBrainsMono Nerd Font.

## Auditoria inicial

En macOS ya estaban WezTerm y Homebrew; faltaban Starship, zoxide, fzf y los dos plugins de Zsh. Se instalaron solamente esos componentes y JetBrainsMono Nerd Font. Se conservaron la paleta Clear Dark, blur 20, WebGPU, 120 FPS y todos los keybindings locales. WebGPU/blur quedan limitados a macOS y Windows conserva OpenGL.

## Estructura

- `wezterm.lua`: aspecto y teclas portables.
- `zshrc`: shell sin Oh My Zsh; se enlaza a `~/.zshrc`.
- `starship.toml`: prompt corto con directorio, Git y runtimes contextuales.
- `install.sh`: bootstrap idempotente para macOS/Ubuntu.
- `install-fonts.sh`: instala JetBrainsMono Nerd Font.

Configuraciones privadas, tokens, SDKs y aliases de una maquina van en `~/.zshrc.local`.

## Instalacion

```sh
git clone https://github.com/Boschaynamo/wezterm-conf.git ~/.config/wezterm
cd ~/.config/wezterm
./install.sh --dry-run
./install.sh
```

En macOS requiere Homebrew e instala solo formulas/casks faltantes. En Ubuntu usa apt para Zsh, fzf y plugins; los instaladores oficiales para Starship/zoxide, y el repo oficial de WezTerm si falta. Destinos existentes se respaldan como `*.backup-AAAAMMDD-HHMMSS`. Si el repo esta en otra ruta, solo enlaza `~/.config/wezterm/wezterm.lua`, sin reemplazar el directorio.

Solo enlaces, sin paquetes ni fuentes:

```sh
./install.sh --skip-packages
```

El script no cambia la shell de login. En Ubuntu se puede hacer explicitamente:

```sh
chsh -s "$(command -v zsh)"
```

## Uso

- `Ctrl-R`: historial interactivo con fzf.
- `z proyecto`: salta a un directorio aprendido por zoxide.
- `zi`: selector interactivo de directorios.
- Flecha derecha acepta autosuggestions.
- `Alt` + flechas mueve por palabra; `Home`/`End` son consistentes.

Starship muestra Node, Python, Rust o Go solamente cuando el proyecto lo requiere, y duracion para comandos de mas de un segundo.

## Verificacion

```sh
zsh -lic 'echo "Zsh OK: $ZSH_VERSION"'
starship --version
fzf --version
zoxide --version
wezterm --version
zsh -lic 'typeset -p _DOTFILES_AUTOSUGGESTIONS_LOADED _DOTFILES_FZF_LOADED _DOTFILES_SYNTAX_HIGHLIGHTING_LOADED'
```

Probar manualmente una sugerencia de historial, syntax highlighting, `Ctrl-R`, `z` y un repo Git. Si falta una herramienta, `zshrc` omite su inicializacion sin imprimir errores.

## Actualizacion

```sh
cd ~/.config/wezterm
git pull --ff-only
./install.sh
```

El arranque usa `compinit` cacheado, PATH deduplicado, plugins desde rutas Homebrew/apt y syntax-highlighting al final. Recarga WezTerm con `Ctrl-Shift-R` y Zsh con `exec zsh`.
