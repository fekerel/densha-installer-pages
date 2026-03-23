<# 2>nul
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~f0"
exit /b
#>

$ErrorActionPreference = 'Stop'
$installRoot = Join-Path $PSScriptRoot 'densha'
$otoPath = Join-Path $installRoot 'densha-oto'
$uiPath  = Join-Path $installRoot 'densha-ui'

if (-not (Test-Path $otoPath)) {
  Write-Host "HATA: $otoPath bulunamadi. Once install-densha.cmd calistirin." -ForegroundColor Red
  pause; exit 1
}
if (-not (Test-Path $uiPath)) {
  Write-Host "HATA: $uiPath bulunamadi. Once install-densha.cmd calistirin." -ForegroundColor Red
  pause; exit 1
}

Start-Process powershell -ArgumentList '-NoExit', '-Command', "Set-Location '$otoPath'; npm run server"
Start-Process powershell -ArgumentList '-NoExit', '-Command', "Set-Location '$uiPath'; npm run start"

Write-Host 'Iki proje ayri PowerShell pencerelerinde baslatildi.' -ForegroundColor Green
