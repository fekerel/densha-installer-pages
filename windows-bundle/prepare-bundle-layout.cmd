@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PAGES_ROOT=%%~fI"
for %%I in ("%PAGES_ROOT%\..") do set "WORKSPACE_ROOT=%%~fI"

set "OTO_ROOT=%WORKSPACE_ROOT%\densha-oto"
set "UI_PORTABLE_EXE=%WORKSPACE_ROOT%\densha-ui\dist\Densha UI.exe"
set "BUNDLE_ROOT=%PAGES_ROOT%\bundle-root"
set "APPS_DIR=%BUNDLE_ROOT%\apps"
set "OTO_BUNDLE_DIR=%APPS_DIR%\densha-oto"
set "BROWSERS_DIR=%BUNDLE_ROOT%\browsers"

REM ── Validate prerequisites ──────────────────────────────────────────────────

if not exist "%OTO_ROOT%\node_modules" (
  echo HATA: densha-oto node_modules bulunamadi. Once "npm install" calistir.
  exit /b 1
)

if not exist "%UI_PORTABLE_EXE%" (
  echo HATA: densha-ui portable exe bulunamadi: "%UI_PORTABLE_EXE%"
  echo Once densha-ui klasoründe "npm run build:portable-win" calistir.
  exit /b 1
)

REM ── Create directory structure ───────────────────────────────────────────────
mkdir "%BUNDLE_ROOT%" >nul 2>&1
mkdir "%APPS_DIR%" >nul 2>&1
mkdir "%OTO_BUNDLE_DIR%" >nul 2>&1
mkdir "%BROWSERS_DIR%" >nul 2>&1

REM ── Copy densha-oto source (server runs via node.exe) ────────────────────────
echo Kopyalaniyor: densha-oto kaynak dosyalari...
for %%D in (actions config error-types scripts server utils) do (
  xcopy /E /I /Y "%OTO_ROOT%\%%D" "%OTO_BUNDLE_DIR%\%%D" >nul
)
copy /y "%OTO_ROOT%\package.json" "%OTO_BUNDLE_DIR%\package.json" >nul
xcopy /E /I /Y "%OTO_ROOT%\node_modules" "%OTO_BUNDLE_DIR%\node_modules" >nul

REM ── Download portable Node.js and embed node.exe ─────────────────────────────
echo Node.js portable indiriliyor...
set "NODE_VERSION=20.19.0"
set "NODE_ZIP=%TEMP%\node-portable.zip"
set "NODE_EXTRACT=%TEMP%\node-portable-extract"

where curl >nul 2>&1
if errorlevel 1 (
  echo HATA: curl bulunamadi.
  exit /b 1
)

curl -fL -o "%NODE_ZIP%" "https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-win-x64.zip"
if errorlevel 1 ( echo HATA: Node.js indirilemedi. & exit /b 1 )

rmdir /s /q "%NODE_EXTRACT%" >nul 2>&1
mkdir "%NODE_EXTRACT%"

tar -xf "%NODE_ZIP%" -C "%NODE_EXTRACT%"
if errorlevel 1 ( echo HATA: Node.js zip acilamadi. & exit /b 1 )

REM node.exe is inside node-v*-win-x64/ subfolder
for /d %%F in ("%NODE_EXTRACT%\node-v*") do (
  copy /y "%%F\node.exe" "%OTO_BUNDLE_DIR%\node.exe" >nul
)

del "%NODE_ZIP%" >nul 2>&1
rmdir /s /q "%NODE_EXTRACT%" >nul 2>&1

echo node.exe: "%OTO_BUNDLE_DIR%\node.exe"

REM ── Copy densha-ui portable exe ──────────────────────────────────────────────
copy /y "%UI_PORTABLE_EXE%" "%APPS_DIR%\densha-ui.exe" >nul
echo densha-ui.exe: "%APPS_DIR%\densha-ui.exe"

REM ── Playwright browsers ──────────────────────────────────────────────────────
echo.
echo UYARI: Playwright Chromium dosyalarini asagidaki klasore kopyalayin:
echo   "%BROWSERS_DIR%"
echo.
echo GitHub Actions kullaniyorsaniz bu adim otomatik yapilir.
echo Manuel yapmak icin: cd densha-oto ^& npx playwright install chromium
echo Sonra %%LOCALAPPDATA%%\ms-playwright klasorunu "%BROWSERS_DIR%" altina kopyalayin.
echo.

echo TAMAM: Bundle layout hazirlandi: "%BUNDLE_ROOT%"
exit /b 0
