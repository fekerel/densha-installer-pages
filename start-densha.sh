#!/usr/bin/env bash

set -euo pipefail

INSTALL_ROOT="${1:-$PWD/densha-santiye}"
INSTALL_ROOT="$(cd "$(dirname "$INSTALL_ROOT")" && pwd)/$(basename "$INSTALL_ROOT")"

OTO_PATH="$INSTALL_ROOT/densha-oto"
UI_PATH="$INSTALL_ROOT/densha-ui"

if [ ! -d "$OTO_PATH" ]; then
  printf 'densha-oto klasoru bulunamadi. Once install-densha.sh calistirin.\n' >&2
  exit 1
fi

if [ ! -d "$UI_PATH" ]; then
  printf 'densha-ui klasoru bulunamadi. Once install-densha.sh calistirin.\n' >&2
  exit 1
fi

if ! command -v osascript >/dev/null 2>&1; then
  printf 'Bu script macOS Terminal otomasyonu icin osascript bekliyor.\n' >&2
  exit 1
fi

osascript <<EOF
tell application "Terminal"
  do script "cd '$OTO_PATH' && npm run server"
  do script "cd '$UI_PATH' && npm run start"
  activate
end tell
EOF

printf 'Iki proje Terminal pencerelerinde baslatildi.\n'