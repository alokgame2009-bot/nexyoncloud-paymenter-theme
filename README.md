# NexyonCloud Paymenter Theme

A blue-and-white styling layer for the existing Paymenter Blade theme. It styles the storefront and customer dashboard while retaining Paymenter's own Laravel Blade templates and product/account functionality. This is not a React replacement.

## Install on the VPS

Run from your Paymenter root (the folder containing `artisan`). Make a backup first.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/alokgame2009-bot/nexyoncloud-paymenter-theme/main/install-paymenter-theme.sh)
```

When asked, enter the Paymenter root path, e.g. `/var/www/paymenter`. If the theme generator prompts for name, enter `nexyoncloud`; author can be `NexyonCloud <alok.game.2009@gmail.com>`. Ensure Node.js/npm are installed and run `npm install` in the Paymenter root if dependencies are missing. Then build with `npm run build nexyoncloud` and activate it in Paymenter admin theme settings.

## Uninstall

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/alokgame2009-bot/nexyoncloud-paymenter-theme/main/uninstall-paymenter-theme.sh)
```

Choose CSS-only removal or full theme-folder removal carefully. Back up first and switch to another theme before deleting the active theme.

## Notes

This package applies CSS styling to Paymenter's existing Blade-rendered storefront and account pages. It does not replace or invent Laravel routes, billing logic, or Blade pages. Verify against your installed Paymenter version before production use.
