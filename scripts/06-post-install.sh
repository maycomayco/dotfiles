#!/usr/bin/env zsh

# ─── gh-dash extension ───────────────────────────────────────────────────────
if command -v gh &>/dev/null; then
  echo "Installing gh-dash extension..."
  gh extension install dlvhdr/gh-dash 2>/dev/null || echo "gh-dash already installed or gh not authenticated yet"
fi

# ─── Global npm packages ─────────────────────────────────────────────────────
if command -v npm &>/dev/null; then
  echo "Installing global npm packages..."
  npm install -g @augmentcode/auggie @playwright/cli corepack
else
  echo "npm not available yet — skipping global packages. Run 'nvm use' first."
fi

# ─── Fix .netrc permissions ──────────────────────────────────────────────────
if [[ -f "$HOME/.netrc" ]]; then
  chmod 600 "$HOME/.netrc"
  echo ".netrc permissions fixed."
fi

# ─── mackup ──────────────────────────────────────────────────────────────────
if command -v pipx &>/dev/null; then
  echo "Installing mackup via pipx..."
  pipx install mackup 2>/dev/null || echo "mackup already installed"
  echo "Restoring mackup configs..."
  mackup restore --force 2>/dev/null || echo "mackup restore skipped (no backup found yet)"
else
  echo "pipx not available — skipping mackup."
fi

# ─── Manual steps ────────────────────────────────────────────────────────────
echo ""
echo "======================================"
echo "  Manual Steps Required"
echo "======================================"
echo ""
echo "1. Install 1Password and sign in"
echo "2. Generate SSH key and add to GitHub:"
echo "   ssh-keygen -t ed25519 -C 'maycobarale@gmail.com'"
echo "   https://github.com/settings/keys"
echo "3. Run 'gh auth login'"
echo "4. Sign in to Raycast to restore extensions"
echo ""
