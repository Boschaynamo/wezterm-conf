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

## Stack y archivos de configuracion

| Componente | Para que sirve | Configuracion en el repo | Ubicacion efectiva |
| --- | --- | --- | --- |
| WezTerm | Emulador de terminal: ventana, colores, fuente, renderer, tabs, panes y keybindings. | `wezterm.lua` | `~/.config/wezterm/wezterm.lua` |
| Zsh | Shell interactiva: historial, completado, aliases, PATH e inicializacion del resto del stack. | `zshrc` | `~/.zshrc` (symlink) |
| Starship | Dibuja el prompt con directorio, estado de Git, runtimes y duracion de comandos. | `starship.toml` | `~/.config/starship.toml` (symlink) |
| fzf | Selector fuzzy interactivo para historial, archivos y directorios. | Se inicializa y ajusta dentro de `zshrc`. | Binario de Homebrew/apt; no necesita otro archivo de configuracion. |
| zoxide | Recuerda directorios visitados y permite volver usando unas pocas palabras. | Se inicializa dentro de `zshrc`. | Su base de datos es local; no necesita un archivo de configuracion manual. |
| zsh-autosuggestions | Sugiere comandos anteriores mientras escribis. | Se carga desde `zshrc`. | Plugin instalado por Homebrew/apt. |
| zsh-syntax-highlighting | Colorea comandos validos, rutas, opciones y errores antes de ejecutarlos. | Se carga al final de `zshrc`. | Plugin instalado por Homebrew/apt. |
| JetBrainsMono Nerd Font | Fuente monoespaciada con los iconos que usa Starship. | Se selecciona en `wezterm.lua`. | Fuente instalada en el sistema. |
| Configuracion local | Ajustes privados o exclusivos de una maquina que no deben versionarse. | No se guarda en el repo. | `~/.zshrc.local` |

Los symlinks permiten editar los archivos del repo y que Zsh/Starship vean el cambio inmediatamente. Se pueden comprobar con:

```sh
readlink ~/.zshrc
readlink ~/.config/starship.toml
```

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
- `Ctrl-T`: busca un archivo o directorio con fzf e inserta su ruta en el comando actual.
- `Alt-C`: busca un directorio con fzf y entra en el.
- `z proyecto`: salta a un directorio aprendido por zoxide.
- `zi`: selector interactivo de directorios.
- Flecha derecha acepta autosuggestions.
- `Alt` + flechas mueve por palabra; `Home`/`End` son consistentes.

Starship muestra Node, Python, Rust o Go solamente cuando el proyecto lo requiere, y duracion para comandos de mas de un segundo.

### Que es fzf

`fzf` significa *fuzzy finder*. Es una interfaz de busqueda: recibe una lista, permite escribir una parte aproximada del nombre y filtra los resultados al instante. No reemplaza comandos como `git`, `cd` o `find`; solamente hace mas comodo elegir un resultado.

El uso mas practico en esta configuracion es `Ctrl-R`:

1. Empeza a escribir un comando o presiona `Ctrl-R` directamente.
2. Escribi cualquier fragmento que recuerdes, aunque no sea el comienzo del comando.
3. Usa las flechas para elegir y `Enter` para recuperar el comando.
4. Editalo si hace falta y presiona `Enter` otra vez para ejecutarlo.

Por ejemplo, si alguna vez ejecutaste `docker compose up --build`, podes presionar `Ctrl-R`, escribir `compose build` y recuperarlo sin recorrer todo el historial.

`Ctrl-T` hace algo parecido con archivos. Por ejemplo, escribi `cat `, presiona `Ctrl-T`, busca un archivo y fzf insertara su ruta en la linea actual.

### Que es zoxide

`zoxide` es una ayuda para navegar entre directorios. Observa los directorios que visitas con `cd` y mantiene una base local ordenada por frecuencia y uso reciente. `cd` sigue funcionando normalmente.

Ejemplo: despues de visitar algunas veces `~/Projects/cloud-ai-dev`, alcanza con ejecutar:

```sh
z cloud
```

Otros ejemplos:

```sh
z wezterm       # vuelve a este repo
z cloud dev     # combina varias palabras para desambiguar
z ..            # tambien acepta rutas normales
zi              # muestra los directorios aprendidos en un selector interactivo
```

Durante los primeros dias zoxide tiene pocos datos; se vuelve mas util a medida que navegas normalmente.

### Diferencia entre fzf y zoxide

- **fzf** es la interfaz generica para buscar y elegir elementos.
- **zoxide** recuerda y ordena especificamente los directorios que usas.
- `Alt-C` usa fzf para buscar directorios recorriendo el filesystem desde la ubicacion actual.
- `zi` combina ambos: zoxide aporta los directorios aprendidos y fzf permite elegir uno visualmente.

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
