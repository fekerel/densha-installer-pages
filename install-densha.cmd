@echo off
setlocal EnableExtensions
title densha installer

set "SCRIPT_DIR=%~dp0"
set "INSTALL_ROOT=%SCRIPT_DIR%densha"
set "OTO_PATH=%INSTALL_ROOT%\densha-oto"
set "UI_PATH=%INSTALL_ROOT%\densha-ui"

echo.
echo ==^> Gereksinimler kontrol ediliyor
where git >nul 2>nul || (echo HATA: Git bulunamadi. indir: https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe & goto :fail)
where node >nul 2>nul || (echo HATA: Node.js bulunamadi. indir: https://nodejs.org/dist/v20.19.5/node-v20.19.5-x64.msi & goto :fail)
where npm >nul 2>nul || (echo HATA: npm bulunamadi. Node.js kurulumunu kontrol edin. & goto :fail)

mkdir "%INSTALL_ROOT%" >nul 2>nul

echo.
echo ==^> Repolar clone ediliyor
if exist "%OTO_PATH%" (
  echo Mevcut klasor bulundu, clone atlaniyor: "%OTO_PATH%"
) else (
  git clone --branch master https://github.com/fekerel/densha-oto.git "%OTO_PATH%" || goto :fail
)

if exist "%UI_PATH%" (
  echo Mevcut klasor bulundu, clone atlaniyor: "%UI_PATH%"
) else (
  git clone --branch main https://github.com/fekerel/densha-ui.git "%UI_PATH%" || goto :fail
)

echo.
echo ==^> densha-oto bagimliliklari kuruluyor
pushd "%OTO_PATH%" || goto :fail
call npm install || (popd & goto :fail)
call npx playwright install chromium || (popd & goto :fail)
popd

echo.
echo ==^> densha-ui bagimliliklari kuruluyor
pushd "%UI_PATH%" || goto :fail
call npm install || (popd & goto :fail)
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
