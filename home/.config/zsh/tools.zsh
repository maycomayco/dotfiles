# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# DX CLI completions
[[ -f ~/.dx-zsh-completion.sh ]] && source ~/.dx-zsh-completion.sh

# OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# Local bin
. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
