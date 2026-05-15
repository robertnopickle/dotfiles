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
  ".config/kitty"
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

# iTerm2 — convert binary plist to XML for git-friendly diffs.
# Note: with iTerm2 configured to use a custom prefs folder, it auto-writes to the
# repo on quit; this step is a safety net for cases where iTerm2 hasn't been quit.
ITERM_PLIST_SRC="$HOME_DIR/Library/Preferences/com.googlecode.iterm2.plist"
ITERM_PLIST_DEST="$DOTFILES_DIR/.config/iterm2/com.googlecode.iterm2.plist"
if [[ -f "$ITERM_PLIST_SRC" ]]; then
  mkdir -p "$(dirname "$ITERM_PLIST_DEST")"
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "DRY_RUN: plutil -convert xml1 -o $ITERM_PLIST_DEST $ITERM_PLIST_SRC"
  else
    plutil -convert xml1 -o "$ITERM_PLIST_DEST" "$ITERM_PLIST_SRC"
  fi
  echo "✅ Exported iTerm2 prefs → $ITERM_PLIST_DEST"
else
  echo "⚠️  Skipping iTerm2: $ITERM_PLIST_SRC not found"
fi

