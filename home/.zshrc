# ─── Oh My Zsh ────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=()

DISABLE_UNTRACKED_FILES_DIRTY="true"
source $ZSH/oh-my-zsh.sh

# ─── Environment ──────────────────────────────────────────────────────────
export EDITOR="code"
export VISUAL="code"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export NODE_OPTIONS="--max-old-space-size=8192"

# ─── PATH ─────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

# ─── Shell Modules ────────────────────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do source "$f"; done

# ─── zsh-autosuggestions ──────────────────────────────────────────────────
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ─── zsh-syntax-highlighting (must be before starship) ────────────────────
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Secrets (must be last) ───────────────────────────────────────────────
[[ -f ~/.zshrc.secrets ]] && source ~/.zshrc.secrets

# TOOLS

# mise (replaces pyenv, rbenv, nodenv, etc.)
eval "$(mise activate zsh)"

# fzf
eval "$(fzf --zsh)"

# zoxide (replaces cd)
eval "$(zoxide init zsh)"

# ─── Starship Prompt ──────────────────────────────────────────────────────
eval "$(starship init zsh)"