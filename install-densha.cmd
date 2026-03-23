<# 2>nul
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~f0"
pause
exit /b
#>

$ErrorActionPreference = 'Stop'
$installRoot = Join-Path $PSScriptRoot 'densha'

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

function Assert-Command($cmd, $hint) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Write-Host "HATA: $cmd bulunamadi. $hint" -ForegroundColor Red
    exit 1
  }
}

function Sync-Repo($url, $path, $branch) {
  if (Test-Path $path) {
    Write-Host "Mevcut klasor bulundu, clone atlanıyor: $path" -ForegroundColor Yellow
    return
  }
  git clone --branch $branch $url $path
}

function Ensure-File($filePath, $content) {
  if (Test-Path $filePath) {
    Write-Host "Mevcut dosya korunuyor: $filePath" -ForegroundColor Yellow
    return
  }
  Set-Content -Path $filePath -Value $content -Encoding UTF8
}

Assert-Command git 'Git for Windows kurup bu pencereyi yeniden acin: https://git-scm.com/downloads'
Assert-Command node 'Node.js 20+ kurup bu pencereyi yeniden acin: https://nodejs.org'
Assert-Command npm  'Node.js kurulumu npm ile birlikte gelir.'

New-Item -ItemType Directory -Force -Path $installRoot | Out-Null
$otoPath = Join-Path $installRoot 'densha-oto'
$uiPath  = Join-Path $installRoot 'densha-ui'

Write-Step 'Repolar clone ediliyor'
Sync-Repo 'https://github.com/fekerel/densha-oto.git' $otoPath 'master'
Sync-Repo 'https://github.com/fekerel/densha-ui.git'  $uiPath  'main'

Write-Step 'densha-oto bagimliliklari kuruluyor'
Push-Location $otoPath
npm install
npx playwright install chromium
Pop-Location

Write-Step 'densha-ui bagimliliklari kuruluyor'
Push-Location $uiPath
npm install
Pop-Location

Write-Step '.env sablonlari olusturuluyor'
$otoEnv = @"
BOT_HANDLER_URL=https://densha-bot-handler-721944224897.europe-west1.run.app
GENDER=male
DISCARD_TABLE_ADJACENT_SEATS=false
DEBUG_NET=0
"@

$uiEnv = @"
TARGET_URL=https://ebilet.tcddtasimacilik.gov.tr
FROM_STATION=
TO_STATION=
TRAVEL_DATE=
TRIP_IDS=
GENDER=male
DISCARD_TABLE_ADJACENT_SEATS=false
"@

Ensure-File (Join-Path $otoPath '.env') $otoEnv
Ensure-File (Join-Path $uiPath  '.env') $uiEnv

Write-Host "`nKurulum tamamlandi!" -ForegroundColor Green
Write-Host "Proje klasoru: $installRoot"
Write-Host "Baslatmak icin: start-densha.cmd"
