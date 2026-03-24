@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "ROOT_DIR=%%~fI"
set "OUT_DIR=%ROOT_DIR%\bundle-root"
set "BUILD_DIR=%ROOT_DIR%\windows-bundle\.build"

where py >nul 2>&1
if not errorlevel 1 (
  set "PYTHON_CMD=py -3"
) else (
  where python >nul 2>&1
  if errorlevel 1 (
    echo HATA: Python bulunamadi.
    exit /b 1
  )
  set "PYTHON_CMD=python"
)

%PYTHON_CMD% -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
  echo PyInstaller bulunamadi, kuruluyor...
  %PYTHON_CMD% -m pip install --user pyinstaller
  if errorlevel 1 exit /b 1
)

mkdir "%OUT_DIR%" >nul 2>&1
mkdir "%BUILD_DIR%" >nul 2>&1

echo Densha-Launcher.exe uretiliyor...
%PYTHON_CMD% -m PyInstaller --noconfirm --clean --onefile --noconsole ^
  --name Densha-Launcher ^
  --distpath "%OUT_DIR%" ^
  --workpath "%BUILD_DIR%\work" ^
  --specpath "%BUILD_DIR%" ^
  "%SCRIPT_DIR%launcher.py"
if errorlevel 1 exit /b 1

echo TAMAM: "%OUT_DIR%\Densha-Launcher.exe"
exit /b 0
