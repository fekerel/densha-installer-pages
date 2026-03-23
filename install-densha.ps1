param(
  [string]$InstallRoot = "$PWD\densha-santiye"
)

$ErrorActionPreference = 'Stop'

function Write-Step($message) {
  Write-Host "`n==> $message" -ForegroundColor Cyan
}

function Assert-Command($command, $hint) {
  if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
    throw "$command bulunamadi. $hint"
  }
}

function Sync-Repo($repoUrl, $targetPath, $branch) {
  if (Test-Path $targetPath) {
    Write-Host "Mevcut klasor bulundu, clone atlanıyor: $targetPath" -ForegroundColor Yellow
    return
  }

  git clone --branch $branch $repoUrl $targetPath
}

function Install-NodeProject($projectPath, $playwrightProjectPath) {
  Push-Location $projectPath
  try {
    npm install
    if ($playwrightProjectPath) {
      Push-Location $playwrightProjectPath
      try {
        npx playwright install chromium
      } finally {
        Pop-Location
      }
    }
  } finally {
    Pop-Location
  }
}

function Ensure-File($filePath, $content) {
  if (Test-Path $filePath) {
    Write-Host "Mevcut dosya korunuyor: $filePath" -ForegroundColor Yellow
    return
  }

  Set-Content -Path $filePath -Value $content -Encoding UTF8
}

Assert-Command git 'Git for Windows kurup PowerShelli yeniden açın.'
Assert-Command node 'Node.js 20+ kurup PowerShelli yeniden açın.'
Assert-Command npm 'Node.js kurulumu npm ile birlikte gelmelidir.'

$resolvedRoot = [System.IO.Path]::GetFullPath($InstallRoot)
New-Item -ItemType Directory -Force -Path $resolvedRoot | Out-Null

$otoPath = Join-Path $resolvedRoot 'densha-oto'
$uiPath = Join-Path $resolvedRoot 'densha-ui'

Write-Step 'Repolar clone ediliyor'
Sync-Repo 'https://github.com/fekerel/densha-oto.git' $otoPath 'master'
Sync-Repo 'https://github.com/fekerel/densha-ui.git' $uiPath 'main'

Write-Step 'densha-oto bagimliliklari kuruluyor'
Install-NodeProject $otoPath $otoPath

Write-Step 'densha-ui bagimliliklari kuruluyor'
Install-NodeProject $uiPath $null

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
Ensure-File (Join-Path $uiPath '.env') $uiEnv

Write-Host "`nKurulum tamamlandi." -ForegroundColor Green
Write-Host "Proje klasoru: $resolvedRoot"
Write-Host "Sonraki adimlar:"
Write-Host "  1. Gerekirse densha-oto/.env ve densha-ui/.env dosyalarini duzenleyin"
Write-Host "  2. start-densha.ps1 scripti ile iki projeyi birlikte baslatin"
Write-Host "  3. Manuel calistirma isterseniz densha-ui icin npm run start, densha-oto icin npm run server"