## Windows
```
git clone

New-Item -ItemType SymbolicLink `
  -Path "C:\Users\$USER\.config\wezterm" `
  -Target "$PATH-TO-REPO\wezterm-conf"
```
## Ubuntu
```
ln -s $PATH-TO-REPO/wezterm-conf ~/.config/wezterm
```

## Fuente (SF Mono)

`wezterm.lua` usa **SF Mono**. Es propietaria de Apple, por eso no esta
versionada en el repo; cada plataforma la instala aparte:

- **macOS:** `brew install --cask font-sf-mono`
- **Linux:** `./install-fonts.sh` (descarga los `.otf` y los instala en
  `~/.local/share/fonts`, idempotente)
- **Windows:** descargar SF Mono e instalarla con doble clic.

Tras instalarla, reinicia WezTerm o recarga la config con `Ctrl+Shift+R`.
