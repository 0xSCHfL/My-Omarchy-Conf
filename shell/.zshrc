# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Source shared aliases (bash + zsh compatible)
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"

# Source global definitions
[ -f /etc/zshrc ] && source /etc/zshrc

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Completion
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -U colors && colors

# cmp opts
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33
zstyle ':completion:*' squeeze-slashes false

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Auto ls on dir change
function chpwd() { ls; }

# Key bindings
bindkey -e

# Ctrl+f to insert "zi" + newline (like bashrc)
bindkey '^f' "zi\n"

# Fastfetch at shell start
if command -v fastfetch &>/dev/null; then
  fastfetch
fi

# Starship prompt
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# Automatically startx on tty1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx
fi
