# ─── Oh My Zsh ────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  z
  sudo
  copypath
  copyfile
  extract
  colored-man-pages
)

DISABLE_UNTRACKED_FILES_DIRTY="true"
source $ZSH/oh-my-zsh.sh

# ─── Environment ──────────────────────────────────────────────────────────
export EDITOR="code"
export VISUAL="code"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export NODE_OPTIONS="--max-old-space-size=8192"

# ─── PATH ─────────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ─── Shell Modules ────────────────────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do source "$f"; done

# ─── zsh-autosuggestions ──────────────────────────────────────────────────
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ─── zsh-syntax-highlighting (must be before starship) ────────────────────
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Starship Prompt ──────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── Secrets (must be last) ───────────────────────────────────────────────
[[ -f ~/.zshrc.secrets ]] && source ~/.zshrc.secrets
eval "$(mise activate zsh)"
