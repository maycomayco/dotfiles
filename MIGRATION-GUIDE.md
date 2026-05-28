# Guía de Migración — Mac Setup

## Apps cubiertas por Mackup ✅

Estas apps se restauran automáticamente con `mackup restore`:

| App | Configuración respaldada |
|-----|-------------------------|
| 1Password | `~/Library/Group Containers/*.1password/` |
| Brave | `~/Library/Application Support/BraveSoftware/` |
| Cursor | `~/.cursor/` (settings, keybindings, snippets) |
| DBeaver | `~/Library/DBeaverData/` |
| Docker | `~/.docker/` (config.json, daemon.json) |
| GitHub CLI | `~/.config/gh/` |
| Insomnia | `~/Library/Application Support/Insomnia/` |
| iTerm2 | `~/Library/Preferences/com.googlecode.iterm2.plist` + AppSupport |
| Itsycal | `~/Library/Preferences/com.mowglii.ItsycalApp.plist` |
| Karabiner-Elements | `~/.config/karabiner/` |
| Logitech Options | `~/Library/Preferences/com.Logitech.Logi.Options.plist` |
| Mole | configs de mole |
| ngrok | `~/.ngrok2/` |
| Telegram | `~/Library/Preferences/ru.keepcoder.Telegram.plist` |
| VS Code | `~/Library/Application Support/Code/User/` (settings, keybindings, snippets) |
| Warp | `~/.warp/` |
| Zoom | `~/Library/Preferences/us.zoom.*.plist` |
| Zsh | `~/.zshrc` + `~/.zprofile` |

---

## Apps con Export Nativo 📤

Estas apps tienen función de export/import integrada:

### Raycast
- **Export**: Settings → Advanced → Export Settings
- **Import**: Settings → Advanced → Import Settings
- **Archivo guardado**: `Raycast 2026-02-27 10.40.46.rayconfig` (en el repo)

### Superwhisper
- **Export**: Settings → Export
- **Import**: Settings → Import
- **Ubicación**: `~/Library/Application Support/com.superwhisper.app/`

### Postman
- **Export**: Settings → Data → Export Data
- **Import**: Settings → Data → Import Data
- **Ubicación**: `~/Library/Application Support/Postman/`

### BetterDisplay
- **Export**: Settings → Export/Import → Export
- **Import**: Settings → Export/Import → Import
- **Ubicación**: `~/Library/Preferences/pro.betterdisplay.plist`

---

## Apps sin Export (Backup Manual) 🔧

Estas apps no tienen export nativo. Backup manual de sus plist/config:

### Hidden Bar
```bash
# No tiene plist visible, configurar manualmente en la nueva máquina
```

### Shottr
```bash
cp -R ~/Library/Application\ Scripts/cc.ffitch.shottr ~/custom-config/app-backups/
```

### DeskPad
```bash
# No tiene plist visible, configurar manualmente en la nueva máquina
```

### Pearcleaner
```bash
cp ~/Library/Preferences/com.alienator88.Pearcleaner.plist ~/custom-config/app-backups/
```

### Only Switch
```bash
cp ~/Library/Preferences/jacklandrin.OnlySwitch.plist ~/custom-config/app-backups/
```

### OpenUsage
```bash
cp -R ~/Library/Application\ Support/com.sunstory.openusage ~/custom-config/app-backups/
```

---

## Apps Cloud (solo login) ☁️

Estas apps sincronizan por cuenta, solo necesitás loguearte:

| App | Acción |
|-----|--------|
| Figma | Login con cuenta |
| Slack | Login con workspace |
| Tidal | Login con cuenta |
| Chrome | Login con cuenta Google (sync) |
| Firefox | Login con Firefox Sync |
| Notion | Login con cuenta |

---

## Apps que Requieren Instalación Manual 📦

### Adobe Creative Cloud + Lightroom
1. Descargar de [adobe.com](https://www.adobe.com)
2. Instalar Creative Cloud
3. Desde CC, instalar Lightroom

### Xcode
1. App Store → buscar "Xcode" → Instalar
2. Opcionalmente: `xcode-select --install` para Command Line Tools

### Apps de Apple (App Store)
- GarageBand
- iMovie
- Keynote
- Numbers
- Pages

### Otras apps manuales
- **Flow**: [flowapp.com](https://flowapp.com)
- **Lightshot**: [lightshot.com](https://app.prntscr.com)
- **Unsplash Wallpapers**: [unsplash.com/wallpapers](https://unsplash.com/wallpapers)
- **WinDiskWriter**: buscar en GitHub

### Apps corporativas (MDM)
Estas las gestiona tu empresa, no las instalás vos:
- IBM Notifier
- Jamf Protect
- DEPT Self Service
- Okta Verify
- Privileges

---

## Script de Backup Manual

```bash
#!/bin/bash
# backup-manual-apps.sh

BACKUP_DIR="$HOME/custom-config/app-backups"
mkdir -p "$BACKUP_DIR"

# Hidden Bar
cp ~/Library/Preferences/aaron.hiddenbar.plist "$BACKUP_DIR/" 2>/dev/null

# Shottr
cp ~/Library/Preferences/com.fightfultool.shottr.plist "$BACKUP_DIR/" 2>/dev/null

# DeskPad
cp ~/Library/Preferences/com.andyhan.DeskPad.plist "$BACKUP_DIR/" 2>/dev/null

# Pearcleaner
cp ~/Library/Preferences/com.alienator88.Pearcleaner.plist "$BACKUP_DIR/" 2>/dev/null

# Only Switch
cp ~/Library/Preferences/OnlySwitch.plist "$BACKUP_DIR/" 2>/dev/null

# OpenUsage
cp ~/Library/Preferences/com.openusage.plist "$BACKUP_DIR/" 2>/dev/null

echo "✅ Backup completado en $BACKUP_DIR"
ls -la "$BACKUP_DIR"
```

---

## Proceso de Migración Completo

### En la máquina actual:
```bash
# 1. Mackup backup
mackup backup --force

# 2. Backup manual de apps sin Mackup
./backup-manual-apps.sh

# 3. Exportar configs nativas
# - Raycast: Settings → Export
# - Superwhisper: Settings → Export
# - BetterDisplay: Settings → Export

# 4. Commitear todo
cd ~/custom-config
git add .
git commit -m "Migration backup $(date +%Y-%m-%d)"
git push
```

### En la nueva máquina:
```bash
# 1. Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clonar repo
git clone https://github.com/tu-usuario/custom-config.git ~/custom-config

# 3. Instalar todo
brew bundle --file=~/custom-config/Brewfile

# 4. Restaurar Mackup
mackup restore --force

# 5. Restaurar backups manuales
cp ~/custom-config/app-backups/*.plist ~/Library/Preferences/

# 6. Importar configs nativas
# - Raycast: importar .rayconfig
# - Superwhisper: Settings → Import
# - BetterDisplay: Settings → Import

# 7. Loguearse en apps cloud
# - Figma, Slack, Tidal, Chrome, Firefox
```
