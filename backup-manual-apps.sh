#!/bin/bash
# backup-manual-apps.sh
# Backup de apps que Mackup no cubre y no tienen export nativo

BACKUP_DIR="$HOME/custom-config/app-backups"
mkdir -p "$BACKUP_DIR"

echo "🔄 Iniciando backup manual..."

# Hidden Bar
# No tiene plist visible, configurar manualmente
echo "⚠️  Hidden Bar: configurar manualmente"

# Shottr
if [ -d ~/Library/Application\ Scripts/cc.ffitch.shottr ]; then
    cp -R ~/Library/Application\ Scripts/cc.ffitch.shottr "$BACKUP_DIR/"
    echo "✅ Shottr"
else
    echo "⚠️  Shottr: config no encontrado"
fi

# DeskPad
# No tiene plist visible, configurar manualmente
echo "⚠️  DeskPad: configurar manualmente"

# Pearcleaner
if [ -f ~/Library/Preferences/com.alienator88.Pearcleaner.plist ]; then
    cp ~/Library/Preferences/com.alienator88.Pearcleaner.plist "$BACKUP_DIR/"
    echo "✅ Pearcleaner"
else
    echo "⚠️  Pearcleaner: plist no encontrado"
fi

# Only Switch
if [ -f ~/Library/Preferences/jacklandrin.OnlySwitch.plist ]; then
    cp ~/Library/Preferences/jacklandrin.OnlySwitch.plist "$BACKUP_DIR/"
    echo "✅ Only Switch"
else
    echo "⚠️  Only Switch: plist no encontrado"
fi

# OpenUsage
if [ -d ~/Library/Application\ Support/com.sunstory.openusage ]; then
    cp -R ~/Library/Application\ Support/com.sunstory.openusage "$BACKUP_DIR/"
    echo "✅ OpenUsage"
else
    echo "⚠️  OpenUsage: config no encontrado"
fi

# Superwhisper (config + licencia, sin modelos ML)
if [ -f ~/Library/Preferences/com.superduper.superwhisper.plist ]; then
    cp ~/Library/Preferences/com.superduper.superwhisper.plist "$BACKUP_DIR/"
    echo "✅ Superwhisper preferences"
else
    echo "⚠️  Superwhisper: plist no encontrado"
fi
if [ -d ~/Library/Application\ Support/com.superduper.superwhisper ]; then
    cp -R ~/Library/Application\ Support/com.superduper.superwhisper "$BACKUP_DIR/"
    echo "✅ Superwhisper license"
else
    echo "⚠️  Superwhisper: license no encontrada"
fi

echo ""
echo "✅ Backup completado en $BACKUP_DIR"
ls -la "$BACKUP_DIR"
