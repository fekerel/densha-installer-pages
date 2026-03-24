@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PAGES_ROOT=%%~fI"
for %%I in ("%PAGES_ROOT%\..") do set "WORKSPACE_ROOT=%%~fI"
set "OTO_EXE=%WORKSPACE_ROOT%\densha-oto\dist\densha-oto.exe"
set "OTO_WORKER_EXE=%WORKSPACE_ROOT%\densha-oto\dist\densha-oto-worker.exe"
set "UI_EXE=%WORKSPACE_ROOT%\densha-ui\dist\densha-ui.exe"
set "BUNDLE_ROOT=%PAGES_ROOT%\bundle-root"
set "APPS_DIR=%BUNDLE_ROOT%\apps"
set "BROWSERS_DIR=%BUNDLE_ROOT%\browsers"

if not exist "%OTO_EXE%" (
  echo HATA: densha-oto exe bulunamadi: "%OTO_EXE%"
  echo Once densha-oto reposunda npm run build:exe calistir.
  exit /b 1
)

if not exist "%OTO_WORKER_EXE%" (
  echo HATA: densha-oto worker exe bulunamadi: "%OTO_WORKER_EXE%"
  echo Once densha-oto reposunda npm run build:exe calistir.
  exit /b 1
)

if not exist "%UI_EXE%" (
  echo HATA: densha-ui exe bulunamadi: "%UI_EXE%"
  echo Once densha-ui reposunda npm run build:portable-win calistir.
  exit /b 1
)

mkdir "%BUNDLE_ROOT%" >nul 2>&1
mkdir "%APPS_DIR%" >nul 2>&1
mkdir "%BROWSERS_DIR%" >nul 2>&1

copy /y "%OTO_EXE%" "%APPS_DIR%\densha-oto.exe" >nul
copy /y "%OTO_WORKER_EXE%" "%APPS_DIR%\densha-oto-worker.exe" >nul
copy /y "%UI_EXE%" "%APPS_DIR%\densha-ui.exe" >nul

echo.
echo TAMAM: app exe dosyalari bundle layout'a kopyalandi.
echo - "%APPS_DIR%\densha-oto.exe"
echo - "%APPS_DIR%\densha-oto-worker.exe"
echo - "%APPS_DIR%\densha-ui.exe"
echo.
echo Playwright Chromium dosyalarini su klasore koy:
echo - "%BROWSERS_DIR%\chromium\chrome-win\chrome.exe" veya
echo - "%BROWSERS_DIR%\chromium\chrome-win64\chrome.exe"
exit /b 0
