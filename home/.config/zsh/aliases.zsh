# ─── Zsh Config ────────────────────────────────────────────────────────────
alias zshconfig="code ~/.zshrc"
alias zshupdate="source ~/.zshrc"
alias zshsecrets="code ~/.zshrc.secrets"

# ─── Navigation ───────────────────────────────────────────────────────────
alias dev="cd ~/dev"
alias work="cd ~/work"
alias dept="cd ~/dept"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ─── CLI Replacements ──────────────────────────────────────────────────────
alias cat="bat"

# ─── ls ───────────────────────────────────────────────────────────────────
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# ─── Utilities ────────────────────────────────────────────────────────────
alias bye='rm -rf'
alias cls="clear"
alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl -s ifconfig.me"

# ─── Git ──────────────────────────────────────────────────────────────────
alias gs="git status"
alias gp="git pull"
alias gpu="git push"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gd="git diff"
alias gds="git diff --staged"
alias glog="git log --oneline --graph --decorate -10"

# ─── NPM / PNPM ───────────────────────────────────────────────────────────
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrl="npm run lint"
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias pri="pnpm install"

# ─── Claude ───────────────────────────────────────────────────────────────
alias claudio="claude --allow-dangerously-skip-permissions"

# ─── Work: SimpliSafe ─────────────────────────────────────────────────────
alias nrr="dx dev"
alias nrg="npm run shell:clean && npm run shell:develop"
