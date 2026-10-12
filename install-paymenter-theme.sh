#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="nexyoncloud"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

printf '\n'
printf '  _   _ _____  _______  ___  _   _  _____ _   _  _____ _   _ _____\n'
printf ' | \ | | ____| \_   _/ / _ \| \ | |/ ____| | | | ____| \ | |\n'
printf ' |  \| |  _|    | |  | | | |  \| | |    | |_| |  _| |  \| |\n'
printf ' | |\  | |___   | |  | | |_| | |\  | |____|  _  | |___| |\  |\n'
printf ' |_| \_|_____|  |_|   \___/|_| \_|\_____|_| |_|_____|_| \_|\n'
printf '\n          PAYMENTER THEME INSTALLER  |  ASCII MODE\n\n'
printf 'Enter the Paymenter application root (folder containing artisan), e.g. /var/www/paymenter: '
read -r PAYMENTER_ROOT
PAYMENTER_ROOT="${PAYMENTER_ROOT%/}"

if [[ ! -f "$PAYMENTER_ROOT/artisan" ]]; then
  echo "ERROR: artisan not found at $PAYMENTER_ROOT/artisan"
  echo "Enter your actual Paymenter root directory and run again."
  exit 1
fi

cd "$PAYMENTER_ROOT"
echo "Creating a theme using Paymenter's built-in theme generator..."
echo "When prompted, use theme name: $THEME_NAME"
php artisan app:theme:create

THEME_DIR="$PAYMENTER_ROOT/themes/$THEME_NAME"
if [[ ! -d "$THEME_DIR" ]]; then
  echo "ERROR: Expected $THEME_DIR was not created. Check the theme name you entered."
  echo "If you used a different name, edit THEME_NAME at the top of this script and rerun."
  exit 1
fi

mkdir -p "$THEME_DIR/resources/css"
TARGET_CSS=""
for candidate in \
  "$THEME_DIR/resources/css/app.css" \
  "$THEME_DIR/resources/css/main.css" \
  "$THEME_DIR/resources/css/style.css"; do
  if [[ -f "$candidate" ]]; then TARGET_CSS="$candidate"; break; fi
done
if [[ -z "$TARGET_CSS" ]]; then
  TARGET_CSS="$THEME_DIR/resources/css/app.css"
  touch "$TARGET_CSS"
fi

if ! grep -q 'NexyonCloud Paymenter theme' "$TARGET_CSS"; then
  printf '\n\n/* NexyonCloud Paymenter theme overrides */\n' >> "$TARGET_CSS"
  if [[ -f "$SCRIPT_DIR/assets/nexyoncloud-overrides.css" ]]; then
    cat "$SCRIPT_DIR/assets/nexyoncloud-overrides.css" >> "$TARGET_CSS"
  else
    echo "Downloading NexyonCloud CSS from GitHub..."
    curl -fLsS "https://raw.githubusercontent.com/alokgame2009-bot/nexyoncloud-paymenter-theme/main/assets/nexyoncloud-overrides.css" -o /tmp/nexyoncloud-overrides.css
    cat /tmp/nexyoncloud-overrides.css >> "$TARGET_CSS"
  fi
fi

echo "\nBuilding theme assets..."
if [[ -f "$PAYMENTER_ROOT/package.json" ]]; then
  npm run build -- "$THEME_NAME"
else
  echo "ERROR: package.json not found in Paymenter root. Install Paymenter frontend dependencies first."
  exit 1
fi

echo "\nDONE. Open Paymenter Admin -> Settings/Theme (or Appearance) and activate '$THEME_NAME'."
echo "Menu names can vary by Paymenter version. Do not delete themes/default."
