#!/usr/bin/env bash
set -euo pipefail
THEME_NAME="nexyoncloud"
printf '\n  _   _ _____  _______  ___  _   _  _____ _   _  _____ _   _ _____\n'
printf ' | \ | | ____| \_   _/ / _ \| \ | |/ ____| | | | ____| \ | |\n'
printf ' |  \| |  _|    | |  | | | |  \| | |    | |_| |  _| |  \| |\n'
printf ' | |\  | |___   | |  | | |_| | |\  | |____|  _  | |___| |\  |\n'
printf ' |_| \_|_____|  |_|   \___/|_| \_|\_____|_| |_|_____|_| \_|\n'
printf '\n             PAYMENTER THEME UNINSTALLER\n\n'
printf 'Choose uninstall mode:\n'
printf '  1) Remove only NexyonCloud CSS overrides (safer)\n'
printf '  2) Remove the entire themes/%s folder\n' "$THEME_NAME"
printf '  3) Cancel\n'
read -r -p 'Choice [1-3]: ' choice
[[ "$choice" == "3" || -z "$choice" ]] && { echo 'Cancelled.'; exit 0; }
read -r -p 'Paymenter root folder (the directory containing artisan): ' PAYMENTER_ROOT
PAYMENTER_ROOT="${PAYMENTER_ROOT%/}"
if [[ ! -f "$PAYMENTER_ROOT/artisan" ]]; then echo "ERROR: artisan not found at $PAYMENTER_ROOT/artisan"; exit 1; fi
THEME_DIR="$PAYMENTER_ROOT/themes/$THEME_NAME"
if [[ ! -d "$THEME_DIR" ]]; then echo "Theme folder not found: $THEME_DIR"; exit 1; fi
case "$choice" in
  1)
    read -r -p 'CSS file path relative to theme folder [resources/css/app.css]: ' rel
    rel="${rel:-resources/css/app.css}"
    css="$THEME_DIR/$rel"
    [[ -f "$css" ]] || { echo "CSS file not found: $css"; exit 1; }
    backup="$css.bak.$(date +%Y%m%d%H%M%S)"
    cp "$css" "$backup"
    python3 - "$css" <<'PYCODE'
import pathlib, re, sys
p=pathlib.Path(sys.argv[1]); s=p.read_text()
s=re.sub(r'\n?\s*/\* NexyonCloud Paymenter theme overrides \*/\s*.*?(?=\n/\*|\Z)', '\n', s, flags=re.S)
p.write_text(s)
PYCODE
    echo "Removed the NexyonCloud override block. Backup: $backup"
    echo 'If you had customized the CSS after installation, review the file manually.'
    ;;
  2)
    echo "WARNING: this deletes the whole theme folder: $THEME_DIR"
    read -r -p 'Type DELETE to confirm: ' confirm
    [[ "$confirm" == "DELETE" ]] || { echo 'Cancelled.'; exit 0; }
    rm -rf -- "$THEME_DIR"
    echo "Removed $THEME_DIR"
    ;;
  *) echo 'Invalid choice.'; exit 1 ;;
esac
if [[ -f "$PAYMENTER_ROOT/package.json" ]]; then
  echo 'Attempting to rebuild Paymenter assets...'
  (cd "$PAYMENTER_ROOT" && npm run build -- "$THEME_NAME") || echo 'Build failed; check the Paymenter theme docs for your version.'
fi
echo 'Uninstall step finished. If active, switch to another theme in Paymenter Admin first.'
