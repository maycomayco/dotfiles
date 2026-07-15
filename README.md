# dotfiles

> From zero to fully configured Mac in minutes.

Personal Mac setup. From factory reset to coding in one command.

```bash
curl -fsSL https://raw.githubusercontent.com/maycomayco/dotfiles/main/bootstrap.sh | bash
```

This installs Xcode Command Line Tools, clones the repo to `~/.dotfiles`, and runs the installer.

## Manual install

```bash
git clone https://github.com/maycomayco/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's included

- **Zsh** with Oh My Zsh, Starship prompt, autosuggestions, syntax highlighting
- **Homebrew** packages and casks via `Brewfile`
- **NVM** for Node.js version management
- **Git** with delta for syntax-highlighted diffs
- **macOS defaults** for Dock, Finder, keyboard, screenshots
- **Aliases** split into modular files under `home/.config/zsh/`
- **AI config** under `ai/` synced to Cursor and other agents

## Manual install

The script will:

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from `Brewfile`
3. Symlink all dotfiles from `home/` to `~/` (backs up existing files)
4. Install Oh My Zsh
5. Set up mise (runtime version manager)
6. Apply macOS defaults (Dock, Finder, keyboard, dark mode)
7. Install gh-dash, global npm packages, fix permissions

```bash
git clone https://github.com/maycobarale/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## After running install.sh

These steps require human interaction and can't be automated:

- Install **1Password** and sign in first
- Generate SSH key and add to GitHub:
  `ssh-keygen -t ed25519 -C "maycobarale@gmail.com"`
- Run `gh auth login`
- Sign in to Raycast and import settings: `Settings > Advanced > Import Settings`
- Restore Mackup configs: `mackup restore --force`

## Aliases

### Git

| Alias | Command |
|---|---|
| `gs` | git status |
| `gp` | git pull |
| `gpu` | git push |
| `gcm` | git commit -m |
| `gca` | git commit --amend |
| `gd` | git diff |
| `gds` | git diff --staged |
| `glog` | git log --oneline --graph --decorate -10 |

### CLI Replacements

| Alias | Replaces |
|---|---|
| `cat` | bat (syntax highlighted) |

### Navigation

| Alias | Command |
|---|---|
| `dev` | cd ~/code |
| `work` | cd ~/work |
| `..` | cd .. |
| `...` | cd ../.. |
| `....` | cd ../../.. |

### NPM / PNPM

| Alias | Command |
|---|---|
| `nrd` | npm run dev |
| `nrb` | npm run build |
| `nrt` | npm run test |
| `nrl` | npm run lint |
| `prd` | pnpm run dev |
| `prb` | pnpm run build |
| `pri` | pnpm install |

### Utilities

| Alias | Command |
|---|---|
| `ll` | ls -lah |
| `la` | ls -A |
| `l` | ls -CF |
| `bye` | rm -rf |
| `cls` | clear |
| `ports` | lsof -i -P -n \| grep LISTEN |
| `myip` | curl -s ifconfig.me |
| `killport <port>` | Kill process on a port |

### Dotfiles

| Alias | Command |
|---|---|
| `zshconfig` | Open .zshrc in Cursor |
| `zshupdate` | Reload zsh config |
| `zshsecrets` | Open secrets in Cursor |

## CLI Tools

| Tool | Description |
|---|---|
| `bat` | `cat` with syntax highlighting |
| `btop` | Resource monitor |
| `gh` | GitHub CLI |
| `go` | Go language |
| `herdr` | Agent multiplexer |
| `mackup` | Keep app settings in sync |
| `mole` | Deep clean your Mac |
| `node` | JavaScript runtime |
| `pnpm` | Fast package manager |
| `pyenv` | Python version management |
| `starship` | Cross-shell prompt |
| `zsh-autosuggestions` | Fish-like autosuggestions |
| `zsh-syntax-highlighting` | Syntax highlighting in shell |

### Apps (Casks)

| App | Description |
|---|---|
| `1password` | Password manager |
| `betterdisplay` | Display management |
| `bitwarden` | Password vault |
| `brave-browser` | Privacy-focused browser |
| `chromium` | Open-source browser |
| `cmux` | AI coding agent multiplexer |
| `deskpad` | Virtual monitor |
| `figma` | Design tool |
| `ghostty` | Terminal emulator |
| `hiddenbar` | Hide menu bar items |
| `itsycal` | Menu bar calendar |
| `karabiner-elements` | Keyboard customiser |
| `mole-app` | Deep clean app |
| `only-switch` | System switches |
| `opencode-desktop` | AI coding agent desktop |
| `openusage` | AI usage tracker |
| `pearcleaner` | App uninstaller |
| `postman` | API development |
| `shottr` | Screenshot tool |
| `superwhisper` | Dictation with AI |
| `tidal` | Music streaming |
| `vlc` | Multimedia player |
| `warp` | Modern terminal |
| `whatsapp@beta` | WhatsApp desktop |

## Structure

```
dotfiles/
├── bootstrap.sh              # Remote entry point (curl | bash)
├── install.sh                # Local orchestrator
├── Brewfile                  # Homebrew packages and casks
├── scripts/                  # Individual setup steps
│   ├── 01-xcode.sh           # Xcode Command Line Tools
│   ├── 02-homebrew.sh        # Homebrew + Brewfile
│   ├── 03-symlinks.sh        # Symlink home/ → ~/
│   ├── 04-omz.sh             # Oh My Zsh
│   ├── 05-mise.sh            # mise (runtime version manager)
│   ├── 06-macos.sh           # macOS defaults
│   └── 07-post-install.sh    # gh-dash, npm, manual steps
├── home/                     # Dotfiles (mirrored to ~/)
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .warp/
│   │   └── settings.toml
│   └── .config/
│       ├── mise/
│       │   └── config.toml
│       ├── zsh/
│       │   ├── aliases.zsh
│       │   ├── history.zsh
│       │   ├── nvm.zsh
│       │   └── tools.zsh
│       └── starship.toml
└── ai/                       # AI config
    ├── instructions/
    ├── skills/
    └── subagents/
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/.dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
