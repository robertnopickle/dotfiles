#!/bin/bash

# this script syncs the current dotfiles on the local machine
# with the files in this repo folder, essentially updating
# the files here with whatever the current local setup is.

set -euo pipefail
HOME_DIR="$HOME"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN="${DRY_RUN:-false}"

cp_cmd="cp -a"

if [[ "$DRY_RUN" == "true" ]]; then
  cp_cmd="cp -av --no-preserve=links"
fi

copy_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    echo "⚠️  Skipping missing file: $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  $cp_cmd "$src" "$dest"
  echo "✅ Copied $src → $dest"
}

echo "📁 Syncing selected ~/.config files"

CONFIG_FILES=(
  ".gitconfig"
  ".tmux.conf"
  ".zshrc"
  ".config/gh"
  ".hammerspoon"
  ".config/nvim/init.lua"
  ".config/nvim/lua"
  ".config/tmux/tmux.conf"
)

for path in "${CONFIG_FILES[@]}"; do
  src="$HOME_DIR/$path"
  dest="$DOTFILES_DIR/$path"

  if [[ -d "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    $cp_cmd "$src/." "$dest"
    echo "✅ Copied directory $src → $dest"
  else
    copy_file "$src" "$dest"
  fi
done

