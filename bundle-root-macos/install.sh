#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/densha-repo"

# Check if git is available
if ! command -v git &> /dev/null; then
  echo "⚠️  Git yüklü değil"
  echo "https://git-scm.com/download/mac adresinden indir"
  exit 1
fi

# Check if node is available
if ! command -v node &> /dev/null; then
  echo "⚠️  Node.js yüklü değil"
  echo "https://nodejs.org adresinden indir"
  exit 1
fi

# Check if Chromium is downloaded
CHROME_DIR="$SCRIPT_DIR/browsers/chromium/chrome-mac"
if [ ! -f "$CHROME_DIR/Chromium.app/Contents/MacOS/Chromium" ]; then
  echo "📥 Chromium indiriliyor..."
  bash "$SCRIPT_DIR/download-chromium.sh"
fi

export PLAYWRIGHT_BUNDLED_BROWSER_DIR="$SCRIPT_DIR/browsers"
export PATH="$SCRIPT_DIR/tools/node/bin:$SCRIPT_DIR/tools/git/bin:$PATH"

# Clone repos if not exist
if [ ! -d "$REPO_DIR" ]; then
  mkdir -p "$REPO_DIR"
  cd "$REPO_DIR"
  git clone https://github.com/fekerel/densha-oto.git
  git clone https://github.com/fekerel/densha-ui.git
fi

# Install densha-oto
cd "$REPO_DIR/densha-oto"
npm install

# Install densha-ui
cd "$REPO_DIR/densha-ui"
npm install

echo ""
echo "✓ Kurulum tamamlandı"
echo ""
echo "Başlatmak için: ./launcher.sh"
