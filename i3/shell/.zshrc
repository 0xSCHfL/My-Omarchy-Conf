[[ -o interactive ]] || return

# Source shared aliases (bash + zsh compatible)
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"

# Zsh-specific aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

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
export HISTTIMEFORMAT="%F %T"

# Completion
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33
zstyle ':completion:*' squeeze-slashes false

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

function chpwd() { ls; }

# Key bindings
bindkey -e
bindkey '^f' "zi\n"

# Allow ctrl-S for history navigation
[[ -o interactive ]] && stty -ixon

# Ignore case on auto-completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Exports
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR=nvim
export VISUAL=nvim

export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"
export PATH=$PATH:/home/sohaib/.spicetify
export TERMINAL=kitty

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

# Dark mode for all applications
export GTK_THEME=Adwaita-dark
export GTK_APPLICATIONS_PREFER_DARK_THEME=1
export QT_STYLE_OVERRIDE=adwaita-dark
export QT_QPA_PLATFORMTHEME=qt5ct

#######################################################
# PACKAGE MANAGER FUNCTIONS
#######################################################
pacf() {
  if [ $# -eq 0 ]; then
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' --preview-window=down:75% --prompt='Install packages: ' | xargs -ro sudo pacman -S --noconfirm --needed
  else
    sudo pacman -S --noconfirm --needed "$@"
  fi
}

paci() {
  if [ $# -eq 0 ]; then
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' --preview-window=down:75% --prompt='Install packages: ' | xargs -ro sudo pacman -S --noconfirm --needed
  else
    sudo pacman -S --noconfirm --needed "$@"
  fi
}

pacd() {
  if [ $# -eq 0 ]; then
    pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' --preview-window=down:75% --prompt='Remove packages: ' | xargs -ro sudo pacman -Rns --noconfirm
  else
    sudo pacman -Rns --noconfirm "$@"
  fi
}

yayf() {
  if [ $# -eq 0 ]; then
    yay -Slq | fzf --multi --preview 'yay -Si {1}' --preview-window=down:75% --prompt='Install packages: ' | xargs -ro yay -S --noconfirm --needed
  else
    command yay -S --noconfirm --needed "$@"
  fi
}

yayi() {
  if [ $# -eq 0 ]; then
    yay -Slq | fzf --multi --preview 'yay -Si {1}' --preview-window=down:75% --prompt='Install packages: ' | xargs -ro yay -S --noconfirm --needed
  else
    command yay -S --noconfirm --needed "$@"
  fi
}

yayd() {
  if [ $# -eq 0 ]; then
    yay -Qq | fzf --multi --preview 'yay -Qi {1}' --preview-window=down:75% --prompt='Remove packages: ' | xargs -ro yay -Rns --noconfirm
  else
    command yay -Rns --noconfirm "$@"
  fi
}

yayc() {
  echo "Cleaning yay cache..."
  yay -Scc
}

pacc() {
  echo "Cleaning pacman cache..."
  sudo pacman -Scc
}

#######################################################
# HELPER FUNCTIONS
#######################################################
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
      *.tar.bz2) tar xvjf $archive ;;
      *.tar.gz) tar xvzf $archive ;;
      *.bz2) bunzip2 $archive ;;
      *.rar) rar x $archive ;;
      *.gz) gunzip $archive ;;
      *.tar) tar xvf $archive ;;
      *.tbz2) tar xvjf $archive ;;
      *.tgz) tar xvzf $archive ;;
      *.zip) unzip $archive ;;
      *.Z) uncompress $archive ;;
      *.7z) 7z x $archive ;;
      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

ftext() {
  grep -iIHrn --color=always "$1" . | less -r
}

cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
  awk '{
    count += $NF
    if (count % 10 == 0) {
      percent = count / total_size * 100
      printf "%3d%% [", percent
      for (i=0;i<=percent;i++)
        printf "="
      printf ">"
      for (i=percent;i<100;i++)
        printf " "
      printf "]\r"
    }
  }
  END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

cpg() {
  if [ -d "$2" ]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

pwdtail() {
  pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

whatsmyip() {
  if command -v ip &> /dev/null; then
    echo -n "Internal IP: "
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
  else
    echo -n "Internal IP: "
    ifconfig wlan0 | grep "inet " | awk '{print $2}'
  fi
  echo -n "External IP: "
  curl -4 ifconfig.me
}

distribution() {
  local dtype="unknown"
  if [ -r /etc/os-release ]; then
    source /etc/os-release
    case $ID in
      fedora|rhel|centos) dtype="redhat" ;;
      sles|opensuse*) dtype="suse" ;;
      ubuntu|debian) dtype="debian" ;;
      gentoo) dtype="gentoo" ;;
      arch|manjaro) dtype="arch" ;;
      slackware) dtype="slackware" ;;
      *)
        if [ -n "$ID_LIKE" ]; then
          case $ID_LIKE in
            *fedora*|*rhel*|*centos*) dtype="redhat" ;;
            *sles*|*opensuse*) dtype="suse" ;;
            *ubuntu*|*debian*) dtype="debian" ;;
            *gentoo*) dtype="gentoo" ;;
            *arch*) dtype="arch" ;;
            *slackware*) dtype="slackware" ;;
          esac
        fi
        ;;
    esac
  fi
  echo $dtype
}

ver() {
  local dtype
  dtype=$(distribution)
  case $dtype in
    "redhat") [ -s /etc/redhat-release ] && cat /etc/redhat-release || cat /etc/issue; uname -a ;;
    "suse") cat /etc/SuSE-release ;;
    "debian") lsb_release -a ;;
    "gentoo") cat /etc/gentoo-release ;;
    "arch") cat /etc/os-release ;;
    "slackware") cat /etc/slackware-version ;;
    *) [ -s /etc/issue ] && cat /etc/issue || echo "Error: Unknown distribution" ;;
  esac
}

apachelog() {
  if [ -f /etc/httpd/conf/httpd.conf ]; then
    cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
  else
    cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
  fi
}

apacheconfig() {
  if [ -f /etc/httpd/conf/httpd.conf ]; then
    sudoedit /etc/httpd/conf/httpd.conf
  elif [ -f /etc/apache2/apache2.conf ]; then
    sudoedit /etc/apache2/apache2.conf
  else
    echo "Error: Apache config file could not be found."
    echo "Searching for possible locations:"
    sudo updatedb && locate httpd.conf && locate apache2.conf
  fi
}

phpconfig() {
  if [ -f /etc/php.ini ]; then
    sudoedit /etc/php.ini
  elif [ -f /etc/php/php.ini ]; then
    sudoedit /etc/php/php.ini
  elif [ -f /etc/php5/php.ini ]; then
    sudoedit /etc/php5/php.ini
  elif [ -f /usr/bin/php5/bin/php.ini ]; then
    sudoedit /usr/bin/php5/bin/php.ini
  elif [ -f /etc/php5/apache2/php.ini ]; then
    sudoedit /etc/php5/apache2/php.ini
  else
    echo "Error: php.ini file could not be found."
  fi
}

mysqlconfig() {
  if [ -f /etc/my.cnf ]; then
    sudoedit /etc/my.cnf
  elif [ -f /etc/mysql/my.cnf ]; then
    sudoedit /etc/mysql/my.cnf
  elif [ -f /usr/local/etc/my.cnf ]; then
    sudoedit /usr/local/etc/my.cnf
  elif [ -f /usr/bin/mysql/my.cnf ]; then
    sudoedit /usr/bin/mysql/my.cnf
  elif [ -f ~/my.cnf ]; then
    sudoedit ~/my.cnf
  elif [ -f ~/.my.cnf ]; then
    sudoedit ~/.my.cnf
  else
    echo "Error: my.cnf file could not be found."
  fi
}

trim() {
  local var=$*
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

gcom() {
  git status
  git add .
  git commit -m "$1"
  git push
}

dotfiles_update() {
  echo "Pulling latest changes from dotfiles repo..."
  git -C ~/Work/dotfiles pull origin main || { echo "Git pull failed"; return 1; }
  echo "Restowing dotfiles symlinks..."
  stow -R -t ~ bash starship tmux nvim fontconfig wal waybar || { echo "Stow failed"; return 1; }
  echo "Dotfiles updated and restowed successfully!"
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

hb() {
  if [ $# -eq 0 ]; then
    echo "No file path specified."
    return
  elif [ ! -f "$1" ]; then
    echo "File path does not exist."
    return
  fi
  uri="http://bin.christitus.com/documents"
  response=$(curl -s -X POST -d @"$1" "$uri")
  if [ $? -eq 0 ]; then
    hasteKey=$(echo $response | jq -r '.key')
    echo "http://bin.christitus.com/$hasteKey"
  else
    echo "Failed to upload the document."
  fi
}
