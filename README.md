# NexyonCloud — Paymenter Billing Theme

A blue/white CSS theme layer for **Paymenter** (Laravel/Blade/Vite), not a standalone React storefront. It is intended to be installed into an existing Paymenter instance while preserving Paymenter's real dashboard, services, invoices, support flows, and authentication.

## What's included

- `assets/nexyoncloud-overrides.css` — blue/white styling layer.
- `install-paymenter-theme.sh` — ASCII-banner installer for AWS VPS; invokes Paymenter's theme generator, adds CSS overrides, and builds assets.
- `uninstall-paymenter-theme.sh` — ASCII-banner uninstaller with a safer CSS-only option and a separately confirmed full-theme removal option.
- `setup-github.bat` — initialize and push this theme repository from Windows CMD.
- `update-github.bat` — commit and push later changes.
- `theme.php.example` — reference only; the official generator creates the actual version-compatible `theme.php`.

## A. Upload this folder to GitHub from Windows

1. Install Git for Windows: https://git-scm.com/download/win
2. On https://github.com/new create an **empty** repository named `nexyoncloud-paymenter-theme`. Do not initialize it with README, license, or `.gitignore`.
3. Extract this ZIP. Open the extracted `nexyoncloud-paymenter-theme` folder.
4. Double-click `setup-github.bat` and paste your repository URL, for example `https://github.com/YOUR-USERNAME/nexyoncloud-paymenter-theme.git`.
5. For later changes, double-click `update-github.bat`.

## B. Install on the AWS VPS

> Back up your Paymenter files first. Do not replace or delete `themes/default`. Test on a staging copy if possible.

1. SSH into the VPS.
2. Ensure Paymenter's normal requirements and Node dependencies are installed. See https://paymenter.org/development/theme/ and https://paymenter.org/development/theme/assets.
3. Clone your GitHub repository into a separate working folder, for example:

   ```bash
   cd /tmp
   git clone https://github.com/YOUR-USERNAME/nexyoncloud-paymenter-theme.git
   cd nexyoncloud-paymenter-theme
   chmod +x install-paymenter-theme.sh
   ./install-paymenter-theme.sh
   ```

4. When asked, enter the Paymenter root folder — the directory containing `artisan`, often `/var/www/paymenter`.
5. When Paymenter's theme generator asks for a theme name, enter `nexyoncloud`.
6. After the build finishes, open Paymenter Admin and activate the NexyonCloud theme. Exact menu wording may vary by Paymenter version.

## Important notes

- This is a CSS theme layer; Paymenter continues to provide the actual billing functionality and server-rendered pages.
- The script expects Paymenter's theme generator to create `themes/nexyoncloud` and a CSS entry file. Review the script output and build result on your exact Paymenter version.
- The official theme generator copies the installed version's default theme, which helps maintain compatibility. Admin-configurable colors and other settings come from the copied theme's `theme.php`; use the theme settings screen to customize them.
- If your Paymenter release changes its theme build commands or file structure, follow the official docs for that installed version before applying the script.
- Do not put `.env`, database credentials, API keys, payment secrets, or customer data in GitHub.


## C. Uninstall

SSH into the VPS, enter the repository folder, then run:

```bash
chmod +x uninstall-paymenter-theme.sh
./uninstall-paymenter-theme.sh
```

Choose **1** to back up the selected CSS file and remove the NexyonCloud override block, or **2** to remove the entire `themes/nexyoncloud` folder (requires typing `DELETE`). Choose another active theme in Paymenter Admin before uninstalling. Back up your files first. The uninstaller cannot know which edits you made manually; review the CSS backup after option 1.
