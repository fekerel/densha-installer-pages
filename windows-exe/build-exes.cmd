@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "ROOT_DIR=%%~fI"
set "OUT_DIR=%ROOT_DIR%\dist"
set "BUILD_DIR=%ROOT_DIR%\windows-exe\.build"

if not exist "%ROOT_DIR%\install-densha.cmd" (
  echo HATA: "%ROOT_DIR%\install-densha.cmd" bulunamadi.
  exit /b 1
)

if not exist "%ROOT_DIR%\start-densha.cmd" (
  echo HATA: "%ROOT_DIR%\start-densha.cmd" bulunamadi.
  exit /b 1
)

where py >nul 2>&1
if not errorlevel 1 (
  set "PYTHON_CMD=py -3"
) else (
  where python >nul 2>&1
  if errorlevel 1 (
    echo HATA: Python bulunamadi. PyInstaller ile EXE uretimi icin Python gerekli.
    exit /b 1
  )
  set "PYTHON_CMD=python"
)

echo Python: %PYTHON_CMD%
%PYTHON_CMD% -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
  echo PyInstaller bulunamadi, kuruluyor...
  %PYTHON_CMD% -m pip install --user pyinstaller
  if errorlevel 1 (
    echo HATA: PyInstaller kurulumu basarisiz.
    exit /b 1
  )
)

mkdir "%OUT_DIR%" >nul 2>&1
mkdir "%BUILD_DIR%" >nul 2>&1

echo [1/2] Densha-Install.exe uretiliyor...
%PYTHON_CMD% -m PyInstaller --noconfirm --clean --onefile ^
  --name Densha-Install ^
  --distpath "%OUT_DIR%" ^
  --workpath "%BUILD_DIR%\install-work" ^
  --specpath "%BUILD_DIR%" ^
  --add-data "%ROOT_DIR%\install-densha.cmd;." ^
  "%SCRIPT_DIR%launch_install.py"
if errorlevel 1 (
  echo HATA: Densha-Install.exe uretilemedi.
  exit /b 1
)

echo [2/2] Densha-Start.exe uretiliyor...
%PYTHON_CMD% -m PyInstaller --noconfirm --clean --onefile ^
  --name Densha-Start ^
  --distpath "%OUT_DIR%" ^
  --workpath "%BUILD_DIR%\start-work" ^
  --specpath "%BUILD_DIR%" ^
  --add-data "%ROOT_DIR%\start-densha.cmd;." ^
  "%SCRIPT_DIR%launch_start.py"
if errorlevel 1 (
  echo HATA: Densha-Start.exe uretilemedi.
  exit /b 1
)

echo.
echo TAMAM: EXE dosyalari olustu.
echo - "%OUT_DIR%\Densha-Install.exe"
echo - "%OUT_DIR%\Densha-Start.exe"
exit /b 0
