#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSERS_DIR="$SCRIPT_DIR/browsers"
CHROME_DIR="$BROWSERS_DIR/chromium/chrome-mac"

mkdir -p "$CHROME_DIR"

echo "Downloading macOS Chromium..."
echo "Bu işlem biraz zaman alabilir (~300MB)"

# MacOS'ta en son Chromium versiyonunu download et
# ms-playwright kullandığı versiyonu al
CHROMIUM_VERSION="1208"

# Download URL (playwright CDN'den)
URL="https://playwright.azureedge.net/builds/chromium/$CHROMIUM_VERSION/chrome-mac.zip"

cd "$BROWSERS_DIR/chromium"

if command -v wget &> /dev/null; then
  wget "$URL" -O chrome-mac.zip
elif command -v curl &> /dev/null; then
  curl -L "$URL" -o chrome-mac.zip
else
  echo "Error: wget or curl not found"
  exit 1
fi

if [ -f "chrome-mac.zip" ]; then
  unzip -q chrome-mac.zip
  rm chrome-mac.zip
  echo "✓ Chromium indirildi: $CHROME_DIR"
else
  echo "✗ Download başarısız"
  exit 1
fi
