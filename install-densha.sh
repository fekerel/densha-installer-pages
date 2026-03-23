#!/usr/bin/env bash

set -euo pipefail

INSTALL_ROOT="${1:-$PWD/densha-santiye}"

step() {
  printf '\n==> %s\n' "$1"
}

assert_command() {
  local command_name="$1"
  local hint="$2"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf '%s\n' "$command_name bulunamadi. $hint" >&2
    exit 1
  fi
}

sync_repo() {
  local repo_url="$1"
  local target_path="$2"
  local branch="$3"

  if [ -d "$target_path" ]; then
    printf 'Mevcut klasor bulundu, clone atlaniyor: %s\n' "$target_path"
    return
  fi

  git clone --branch "$branch" "$repo_url" "$target_path"
}

install_node_project() {
  local project_path="$1"
  local playwright_project_path="${2:-}"

  cd "$project_path"
  npm install

  if [ -n "$playwright_project_path" ]; then
    cd "$playwright_project_path"
    npx playwright install chromium
  fi
}

ensure_file() {
  local file_path="$1"
  local file_content="$2"

  if [ -f "$file_path" ]; then
    printf 'Mevcut dosya korunuyor: %s\n' "$file_path"
    return
  fi

  printf '%s' "$file_content" > "$file_path"
}

assert_command git 'Xcode Command Line Tools veya Homebrew git kurun.'
assert_command node 'Node.js 20+ kurun.'
assert_command npm 'Node.js kurulumu npm ile birlikte gelmelidir.'

INSTALL_ROOT="$(cd "$(dirname "$INSTALL_ROOT")" && pwd)/$(basename "$INSTALL_ROOT")"
mkdir -p "$INSTALL_ROOT"

OTO_PATH="$INSTALL_ROOT/densha-oto"
UI_PATH="$INSTALL_ROOT/densha-ui"

step 'Repolar clone ediliyor'
sync_repo 'https://github.com/fekerel/densha-oto.git' "$OTO_PATH" 'master'
sync_repo 'https://github.com/fekerel/densha-ui.git' "$UI_PATH" 'main'

step 'densha-oto bagimliliklari kuruluyor'
install_node_project "$OTO_PATH" "$OTO_PATH"

step 'densha-ui bagimliliklari kuruluyor'
install_node_project "$UI_PATH"

step '.env sablonlari olusturuluyor'
OTO_ENV_CONTENT='BOT_HANDLER_URL=https://densha-bot-handler-721944224897.europe-west1.run.app
GENDER=male
DISCARD_TABLE_ADJACENT_SEATS=false
DEBUG_NET=0
'

UI_ENV_CONTENT='TARGET_URL=https://ebilet.tcddtasimacilik.gov.tr
FROM_STATION=
TO_STATION=
TRAVEL_DATE=
TRIP_IDS=
GENDER=male
DISCARD_TABLE_ADJACENT_SEATS=false
'

ensure_file "$OTO_PATH/.env" "$OTO_ENV_CONTENT"
ensure_file "$UI_PATH/.env" "$UI_ENV_CONTENT"

printf '\nKurulum tamamlandi.\n'
printf 'Proje klasoru: %s\n' "$INSTALL_ROOT"
printf 'Sonraki adimlar:\n'
printf '  1. Gerekirse densha-oto/.env ve densha-ui/.env dosyalarini duzenleyin\n'
printf '  2. start-densha.sh scripti ile iki projeyi birlikte baslatin\n'
printf '  3. Manuel calistirma isterseniz densha-ui icin npm run start, densha-oto icin npm run server\n'