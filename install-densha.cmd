@echo off
setlocal EnableExtensions
title densha installer

set "SCRIPT_DIR=%~dp0"
set "INSTALL_ROOT=%SCRIPT_DIR%densha"
set "OTO_PATH=%INSTALL_ROOT%\densha-oto"
set "UI_PATH=%INSTALL_ROOT%\densha-ui"
set "TOOLS_DIR=%SCRIPT_DIR%tools"
set "PORTABLE_NODE_DIR=%TOOLS_DIR%\node"
set "PORTABLE_GIT_DIR=%TOOLS_DIR%\git"

set "GIT_CMD="
set "NPM_CMD="
set "NPX_CMD="

echo.
echo ==^> Gereksinimler kontrol ediliyor
if exist "%PORTABLE_GIT_DIR%\cmd\git.exe" (
  set "GIT_CMD=%PORTABLE_GIT_DIR%\cmd\git.exe"
  echo Git: portable paket kullaniliyor.
) else (
  where git >nul 2>nul || (echo HATA: Git bulunamadi. Cozum 1: tools\git altina portable Git koy. Cozum 2: Git kur. & goto :fail)
  set "GIT_CMD=git"
  echo Git: sistem PATH kullaniliyor.
)

if exist "%PORTABLE_NODE_DIR%\npm.cmd" (
  set "NPM_CMD=%PORTABLE_NODE_DIR%\npm.cmd"
  set "NPX_CMD=%PORTABLE_NODE_DIR%\npx.cmd"
  set "PATH=%PORTABLE_NODE_DIR%;%PATH%"
  echo Node/npm: portable paket kullaniliyor.
) else (
  where npm >nul 2>nul || (echo HATA: npm bulunamadi. Cozum 1: tools\node altina portable Node koy. Cozum 2: Node.js kur. & goto :fail)
  set "NPM_CMD=npm"
  set "NPX_CMD=npx"
  echo Node/npm: sistem PATH kullaniliyor.
)

mkdir "%INSTALL_ROOT%" >nul 2>nul

echo.
echo ==^> Repolar clone ediliyor
if exist "%OTO_PATH%" (
  echo Mevcut klasor bulundu, clone atlaniyor: "%OTO_PATH%"
) else (
  "%GIT_CMD%" clone --branch master https://github.com/fekerel/densha-oto.git "%OTO_PATH%" || goto :fail
)

if exist "%UI_PATH%" (
  echo Mevcut klasor bulundu, clone atlaniyor: "%UI_PATH%"
) else (
  "%GIT_CMD%" clone --branch main https://github.com/fekerel/densha-ui.git "%UI_PATH%" || goto :fail
)

echo.
echo ==^> densha-oto bagimliliklari kuruluyor
pushd "%OTO_PATH%" || goto :fail
call "%NPM_CMD%" install || (popd & goto :fail)
call "%NPX_CMD%" playwright install chromium || (popd & goto :fail)
popd

echo.
echo ==^> densha-ui bagimliliklari kuruluyor
pushd "%UI_PATH%" || goto :fail
call "%NPM_CMD%" install || (popd & goto :fail)
popd

echo.
echo ==^> .env sablonlari olusturuluyor
if exist "%OTO_PATH%\.env" (
  echo Mevcut dosya korunuyor: "%OTO_PATH%\.env"
) else (
  >"%OTO_PATH%\.env" (
    echo BOT_HANDLER_URL=https://densha-bot-handler-721944224897.europe-west1.run.app
    echo GENDER=male
    echo DISCARD_TABLE_ADJACENT_SEATS=false
    echo DEBUG_NET=0
  )
)

if exist "%UI_PATH%\.env" (
  echo Mevcut dosya korunuyor: "%UI_PATH%\.env"
) else (
  >"%UI_PATH%\.env" (
    echo TARGET_URL=https://ebilet.tcddtasimacilik.gov.tr
    echo FROM_STATION=
    echo TO_STATION=
    echo TRAVEL_DATE=
    echo TRIP_IDS=
    echo GENDER=male
    echo DISCARD_TABLE_ADJACENT_SEATS=false
  )
)

echo.
echo Kurulum tamamlandi!
echo Proje klasoru: "%INSTALL_ROOT%"
echo Baslatmak icin: start-densha.cmd
echo.
pause
exit /b 0

:fail
echo.
echo Kurulum basarisiz oldu. Hata kodu: %errorlevel%
pause
exit /b 1
