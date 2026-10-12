@echo off
setlocal
cd /d "%~dp0"
echo ================================================
echo NexyonCloud Paymenter Theme - GitHub Upload
echo ================================================
where git >nul 2>nul
if errorlevel 1 (
  echo Git is not installed. Install Git for Windows from https://git-scm.com/download/win
  pause
  exit /b 1
)
if not exist .git git init
 git add .
git commit -m "Initial NexyonCloud Paymenter theme"
if errorlevel 1 echo Note: if there is nothing to commit, continuing...
git branch -M main
echo.
set /p REPO_URL=Paste your EMPTY GitHub repository HTTPS URL: 
if "%REPO_URL%"=="" (
  echo No repository URL entered.
  pause
  exit /b 1
)
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
) else (
  git remote set-url origin "%REPO_URL%"
)
git push -u origin main
if errorlevel 1 (
  echo.
  echo Upload failed. Check the repo URL, GitHub login, and whether the repo is empty.
) else (
  echo.
  echo Upload complete. Open your GitHub repository in the browser.
)
pause
