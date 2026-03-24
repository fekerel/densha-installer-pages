@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PAGES_ROOT=%%~fI"
for %%I in ("%PAGES_ROOT%\..") do set "WORKSPACE_ROOT=%%~fI"
set "OTO_ROOT=%WORKSPACE_ROOT%\densha-oto"
set "UI_ROOT=%WORKSPACE_ROOT%\densha-ui"

echo [1/5] densha-oto bagimliliklari kontrol ediliyor...
if not exist "%OTO_ROOT%\node_modules" (
  pushd "%OTO_ROOT%"
  call npm install || exit /b 1
  popd
)

echo [2/5] densha-oto exe paketleniyor...
pushd "%OTO_ROOT%"
call npm run build:exe || (popd & exit /b 1)
popd

echo [3/5] densha-ui exe paketleniyor...
pushd "%UI_ROOT%"
call npm install || (popd & exit /b 1)
call npm run build:portable-win || (popd & exit /b 1)
popd

echo [4/5] root launcher exe paketleniyor...
call "%SCRIPT_DIR%build-launcher.cmd" || exit /b 1

echo [5/5] bundle layout hazirlaniyor...
call "%SCRIPT_DIR%prepare-bundle-layout.cmd" || exit /b 1

echo.
echo TAMAM: bundle-root klasoru dagitim icin hazir.
echo Icinden zip olusturup dagitabilirsiniz.
exit /b 0
