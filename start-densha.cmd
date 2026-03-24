@echo off
setlocal EnableExtensions
title densha starter

set "SCRIPT_DIR=%~dp0"
set "INSTALL_ROOT=%SCRIPT_DIR%densha"
set "OTO_PATH=%INSTALL_ROOT%\densha-oto"
set "UI_PATH=%INSTALL_ROOT%\densha-ui"
set "TOOLS_DIR=%SCRIPT_DIR%tools"
set "PORTABLE_NODE_DIR=%TOOLS_DIR%\node"
set "PATH_PREFIX="

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

if exist "%PORTABLE_NODE_DIR%\npm.cmd" (
  set "PATH_PREFIX=%PORTABLE_NODE_DIR%;"
  echo Node/npm: portable paket kullaniliyor.
) else (
  where npm >nul 2>&1
  if errorlevel 1 (
    echo HATA: npm bulunamadi. Cozum 1: tools\node altina portable Node koy. Cozum 2: Node.js kurup tekrar deneyin.
    pause
    exit /b 1
  )
  echo Node/npm: sistem PATH kullaniliyor.
)

start "densha-oto" cmd /k "set PATH=%PATH_PREFIX%%%PATH%% && cd /d "%OTO_PATH%" && npm run server"
start "densha-ui" cmd /k "set PATH=%PATH_PREFIX%%%PATH%% && cd /d "%UI_PATH%" && npm run start"

echo Iki proje ayri pencerelerde baslatildi.
pause
exit /b 0
