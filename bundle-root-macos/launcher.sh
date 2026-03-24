#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PLAYWRIGHT_BUNDLED_BROWSER_DIR="$SCRIPT_DIR/browsers"
export PATH="$SCRIPT_DIR/tools/node/bin:$SCRIPT_DIR/tools/git/bin:$PATH"

cd "$SCRIPT_DIR"

# Start densha-ui (Electron)
if [ -d "densha-ui.app" ]; then
  open -a "$SCRIPT_DIR/densha-ui.app" 2>/dev/null &
else
  echo "densha-ui.app not found"
fi

# Start densha-oto server
if [ -f "densha-oto" ]; then
  chmod +x ./densha-oto
  ./densha-oto &
elif [ -d "densha-oto" ]; then
  cd densha-oto && npm start &
else
  echo "densha-oto not found"
fi

wait
