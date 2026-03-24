@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PAGES_ROOT=%%~fI"
for %%I in ("%PAGES_ROOT%\..") do set "WORKSPACE_ROOT=%%~fI"
set "OTO_ROOT=%WORKSPACE_ROOT%\densha-oto"
set "UI_ROOT=%WORKSPACE_ROOT%\densha-ui"

echo [1/4] densha-oto bagimliliklari yukleniyor...
pushd "%OTO_ROOT%"
call npm install || (popd & exit /b 1)
popd

echo [2/4] densha-ui bagimliliklari yukleniyor ve portable exe üretiliyor...
pushd "%UI_ROOT%"
call npm install || (popd & exit /b 1)
call npm run build:portable-win || (popd & exit /b 1)
popd

echo [3/4] Densha-Launcher.exe uretiliyor...
call "%SCRIPT_DIR%build-launcher.cmd" || exit /b 1

echo [4/4] bundle layout hazirlaniyor...
call "%SCRIPT_DIR%prepare-bundle-layout.cmd" || exit /b 1

echo.
echo TAMAM: bundle-root klasoru dagitim icin hazir.
echo Icinden zip olusturup dagitabilirsiniz.
exit /b 0
