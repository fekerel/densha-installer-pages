#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PLAYWRIGHT_BUNDLED_BROWSER_DIR="$SCRIPT_DIR/browsers"
export PATH="$SCRIPT_DIR/tools/node/bin:$SCRIPT_DIR/tools/git/bin:$PATH"

cd "$SCRIPT_DIR"

# Run installer
bash ./install.sh

# Launch app
bash ./launcher.sh
