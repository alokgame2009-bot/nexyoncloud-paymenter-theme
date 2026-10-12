@echo off
setlocal
cd /d "%~dp0"
where git >nul 2>nul
if errorlevel 1 (
  echo Git is not installed. Install it from https://git-scm.com/download/win
  pause
  exit /b 1
)
 git add .
set /p MSG=Enter update message: 
if "%MSG%"=="" set MSG=Update NexyonCloud Paymenter theme
git commit -m "%MSG%"
if errorlevel 1 echo No new changes to commit, or commit failed.
git push
pause
