param(
  [string]$InstallRoot = "$PWD\densha"
)

$ErrorActionPreference = 'Stop'

function Assert-Path($pathValue, $message) {
  if (-not (Test-Path $pathValue)) {
    throw $message
  }
}

$resolvedRoot = [System.IO.Path]::GetFullPath($InstallRoot)
$otoPath = Join-Path $resolvedRoot 'densha-oto'
$uiPath = Join-Path $resolvedRoot 'densha-ui'

Assert-Path $otoPath 'densha-oto klasoru bulunamadi. Once install-densha.ps1 calistirin.'
Assert-Path $uiPath 'densha-ui klasoru bulunamadi. Once install-densha.ps1 calistirin.'

Start-Process powershell -ArgumentList '-NoExit', '-Command', "Set-Location '$otoPath'; npm run server"
Start-Process powershell -ArgumentList '-NoExit', '-Command', "Set-Location '$uiPath'; npm run start"

Write-Host 'Iki proje ayri PowerShell pencerelerinde baslatildi.' -ForegroundColor Green