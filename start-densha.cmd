@echo off
setlocal EnableExtensions
title densha starter

set "SCRIPT_DIR=%~dp0"
set "INSTALL_ROOT=%SCRIPT_DIR%densha"
set "OTO_PATH=%INSTALL_ROOT%\densha-oto"
set "UI_PATH=%INSTALL_ROOT%\densha-ui"

if not exist "%OTO_PATH%" (
  echo HATA: "%OTO_PATH%" bulunamadi. Once install-densha.cmd calistirin.
  pause
  exit /b 1
)

if not exist "%UI_PATH%" (
  echo HATA: "%UI_PATH%" bulunamadi. Once install-densha.cmd calistirin.
  pause
  exit /b 1
)

start "densha-oto" cmd /k "cd /d "%OTO_PATH%" && npm run server"
start "densha-ui" cmd /k "cd /d "%UI_PATH%" && npm run start"

echo Iki proje ayri pencerelerde baslatildi.
pause
exit /b 0
