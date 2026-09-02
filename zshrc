# Zsh portable, sin framework. Configuracion privada: ~/.zshrc.local
[[ -o interactive ]] || return

typeset -U path PATH
# Se recorren de menor a mayor prioridad porque cada entrada se antepone.
for _dir in /usr/local/bin /opt/homebrew/bin "$HOME/.local/bin" "$HOME/bin"; do
  [[ -d "$_dir" ]] && path=("$_dir" $path)
done
if [[ -n "${PNPM_HOME:-}" && -d "$PNPM_HOME" ]]; then
  path=("$PNPM_HOME" $path)
elif [[ -d "$HOME/Library/pnpm" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"; path=("$PNPM_HOME" $path)
elif [[ -d "$HOME/.local/share/pnpm" ]]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"; path=("$PNPM_HOME" $path)
fi
[[ -n "${PNPM_HOME:-}" && -d "$PNPM_HOME/bin" ]] && path=("$PNPM_HOME/bin" $path)
export PATH
unset _dir

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS

autoload -Uz compinit
_comp_dump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -s "$_comp_dump" || "$_comp_dump" -ot "$HOME/.zshrc" ]]; then
  compinit -d "$_comp_dump"
else
  compinit -C -d "$_comp_dump"
fi
unset _comp_dump

bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
case "$OSTYPE" in
  darwin*) alias ls='ls -G' ;;
  linux*) alias ls='ls --color=auto' ;;
esac
alias ll='ls -lah'
alias la='ls -A'

_source_first() {
  local candidate
  for candidate in "$@"; do
    [[ -r "$candidate" ]] && source "$candidate" && return 0
  done
  return 1
}

if [[ -z "${_DOTFILES_AUTOSUGGESTIONS_LOADED:-}" ]]; then
  _source_first \
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    && typeset -g _DOTFILES_AUTOSUGGESTIONS_LOADED=1
fi

if (( $+commands[fzf] )) && [[ -z "${_DOTFILES_FZF_LOADED:-}" ]]; then
  export FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS:---height=60% --layout=reverse --border --info=inline}"
  _fzf_init="$(fzf --zsh 2>/dev/null)"
  if [[ -n "$_fzf_init" ]]; then
    eval "$_fzf_init"
  elif [[ -r "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  else
    _source_first /usr/share/doc/fzf/examples/key-bindings.zsh /usr/share/fzf/key-bindings.zsh || true
    _source_first /usr/share/doc/fzf/examples/completion.zsh /usr/share/fzf/completion.zsh || true
  fi
  typeset -g _DOTFILES_FZF_LOADED=1
  unset _fzf_init
fi

if (( $+commands[starship] )) && [[ -z "${_DOTFILES_STARSHIP_LOADED:-}" ]]; then
  eval "$(starship init zsh)"
  typeset -g _DOTFILES_STARSHIP_LOADED=1
fi
if (( $+commands[zoxide] )) && [[ -z "${_DOTFILES_ZOXIDE_LOADED:-}" ]]; then
  eval "$(zoxide init zsh)"
  typeset -g _DOTFILES_ZOXIDE_LOADED=1
fi

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Debe ser el ultimo plugin: observa todos los widgets definidos antes.
if [[ -z "${_DOTFILES_SYNTAX_HIGHLIGHTING_LOADED:-}" ]]; then
  _source_first \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    && typeset -g _DOTFILES_SYNTAX_HIGHLIGHTING_LOADED=1
fi
unfunction _source_first 2>/dev/null || true
