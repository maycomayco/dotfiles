# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ ⚡ INSTANT PROMPT (debe estar al inicio)                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# Powerlevel10k instant prompt - No mover este bloque
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🎨 OH-MY-ZSH CONFIGURATION                                                   │
# ╰──────────────────────────────────────────────────────────────────────────────╯
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# [MEJORA 1] Plugins optimizados - agregados plugins útiles sin afectar rendimiento
plugins=(
  git                    # Aliases para git (gst, gco, etc.)
  z                      # Saltar a directorios frecuentes (z dirname)
  sudo                   # Presiona ESC dos veces para agregar sudo
  copypath               # Copiar path actual al clipboard
  copyfile               # Copiar contenido de archivo al clipboard
  web-search             # Buscar desde terminal (google query)
  extract                # Extraer cualquier archivo comprimido
  colored-man-pages      # Man pages con colores
)

# [MEJORA 2] Optimización para repositorios grandes
DISABLE_UNTRACKED_FILES_DIRTY="true"

source $ZSH/oh-my-zsh.sh

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 📝 HISTORY CONFIGURATION                                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# [MEJORA 3] Configuración de historial optimizada
HISTSIZE=50000                   # Comandos en memoria
SAVEHIST=50000                   # Comandos guardados en archivo
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Guardar timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Eliminar duplicados primero cuando se llena
setopt HIST_IGNORE_DUPS          # No guardar duplicados consecutivos
setopt HIST_IGNORE_ALL_DUPS      # Eliminar entradas antiguas si hay duplicados
setopt HIST_IGNORE_SPACE         # No guardar comandos que empiezan con espacio
setopt HIST_FIND_NO_DUPS         # No mostrar duplicados al buscar
setopt HIST_SAVE_NO_DUPS         # No escribir duplicados al archivo
setopt SHARE_HISTORY             # Compartir historial entre sesiones

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ ⚙️  ENVIRONMENT VARIABLES                                                    │
# ╰──────────────────────────────────────────────────────────────────────────────╯
export EDITOR="cursor"
export VISUAL="cursor"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Node.js memory optimization
export NODE_OPTIONS="--max-old-space-size=8192"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 📂 PATH CONFIGURATION                                                        │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🚀 NVM (Node Version Manager) - STANDARD LOADING                            │
# ╰──────────────────────────────────────────────────────────────────────────────╯
export NVM_DIR="$HOME/.nvm"

# Cargar NVM al iniciar la shell
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🍺 BUN                                                                       │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# [MEJORA 5] Usar $HOME en lugar de path hardcodeado
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🌐 NGROK                                                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🔧 ALIASES - General                                                         │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# Configuración ZSH
alias config="code ~/.zshrc"
alias reload="code ~/.zshrc"
alias zshsecrets="code ~/.zshrc.secrets"

# Navegación
alias dev="cd ~/dev"
alias dept="cd ~/dept"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# [MEJORA 6] Aliases mejorados para ls
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# Utilidades
alias bye='rm -rf'
alias cls="clear"
alias claudio="claude --allow-dangerously-skip-permissions"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🔧 ALIASES - Development                                                     │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# NPM / PNPM
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrl="npm run lint"
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias pri="pnpm install"

# [MEJORA 7] Aliases útiles para Git (complementan el plugin git)
alias gs="git status"
alias gp="git pull"
alias gpu="git push"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gd="git diff"
alias gds="git diff --staged"
alias glog="git log --oneline --graph --decorate -10"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🛠️  UTILITY FUNCTIONS                                                        │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# [MEJORA 8] Función para crear directorio y entrar
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# [MEJORA 9] Función para buscar en historial
hg() {
  history | grep "$1"
}

# Función para matar proceso por puerto
killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "Killed process on port $1" || echo "No process found on port $1"
}

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🎨 POWERLEVEL10K THEME                                                       │
# ╰──────────────────────────────────────────────────────────────────────────────╯
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🔌 COMPLETIONS & EXTERNAL TOOLS                                              │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# DX CLI completions
[[ -f ~/.dx-zsh-completion.sh ]] && source ~/.dx-zsh-completion.sh

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 🔐 SECRETS (debe estar al final)                                             │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# [MEJORA 10] Secrets en archivo separado - Más seguro y limpio
[[ -f ~/.zshrc.secrets ]] && source ~/.zshrc.secrets

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ 📊 STARTUP TIME (descomenta para debug)                                      │
# ╰──────────────────────────────────────────────────────────────────────────────╯
# Para medir tiempo de carga, ejecuta: time zsh -i -c exit
# Para profiling detallado, agrega al inicio: zmodload zsh/zprof
# Y al final: zprof

# opencode
export PATH=/Users/mayco/.opencode/bin:$PATH

. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
