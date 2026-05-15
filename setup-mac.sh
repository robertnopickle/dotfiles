#!/bin/bash

# setup-mac.sh — Bootstrap a fresh macOS machine with dotfiles and dev tools
# Usage: git clone <repo> && cd dotfiles && ./setup-mac.sh

exec > >(tee -i "$HOME/dotfiles_install_log")
exec 2>&1
set -euo pipefail
set -x

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Detect Homebrew prefix (Apple Silicon vs Intel)
if [[ -f /opt/homebrew/bin/brew ]]; then
  BREW_PREFIX="/opt/homebrew"
elif [[ -f /usr/local/bin/brew ]]; then
  BREW_PREFIX="/usr/local"
else
  echo "❌ Homebrew installation not found"; exit 1
fi
eval "$($BREW_PREFIX/bin/brew shellenv)"

# Persist Homebrew in login shells
ZPROFILE="$HOME/.zprofile"
BREW_SHELLENV_LINE="eval \"\$($BREW_PREFIX/bin/brew shellenv)\""
if ! grep -qF "$BREW_SHELLENV_LINE" "$ZPROFILE" 2>/dev/null; then
  echo "$BREW_SHELLENV_LINE" >> "$ZPROFILE"
  echo "✅ Added brew shellenv to $ZPROFILE"
fi

# ---------------------------------------------------------------------------
# 2. CLI tools
# ---------------------------------------------------------------------------
brew install neovim tmux ripgrep universal-ctags fzf zoxide starship rbenv ruby-build

# ---------------------------------------------------------------------------
# 3. GUI apps
# ---------------------------------------------------------------------------
brew install --cask iterm2 hammerspoon arc google-chrome

# ---------------------------------------------------------------------------
# 4. nvm + Node.js + Copilot CLI
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash
fi
export NVM_DIR="$HOME/.nvm"
\. "$NVM_DIR/nvm.sh"
nvm install 24
npm install -g @github/copilot

# ---------------------------------------------------------------------------
# 5. Symlink dotfiles
# ---------------------------------------------------------------------------
# Replace target with a symlink to the dotfiles version, but only if the
# existing target is not already a symlink to that same path. Keeps reruns
# safe and avoids destroying user-installed plugin/cache state.
link_dotfile() {
  local src="$1"
  local dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    return 0
  fi
  rm -rf "$dest"
  ln -s "$src" "$dest"
}

link_dotfile "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
link_dotfile "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_dotfile "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_dotfile "$DOTFILES_DIR/.ignore"    "$HOME/.ignore"

# Hammerspoon
link_dotfile "$DOTFILES_DIR/.hammerspoon" "$HOME/.hammerspoon"

# Neovim config — only wipe plugin/cache state on first install
mkdir -p "$HOME/.config"
NVIM_FRESH_INSTALL=false
if [[ ! -L "$HOME/.config/nvim" || "$(readlink "$HOME/.config/nvim")" != "$DOTFILES_DIR/.config/nvim" ]]; then
  NVIM_FRESH_INSTALL=true
fi
link_dotfile "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
if [[ "$NVIM_FRESH_INSTALL" == "true" ]]; then
  rm -rf "$HOME/.local/share/nvim" "$HOME/.cache/nvim"
fi

# gh CLI config (only config.yml, not auth hosts)
mkdir -p "$HOME/.config/gh"
ln -sf "$DOTFILES_DIR/.config/gh/config.yml" "$HOME/.config/gh/config.yml"

# iTerm2 — point it at the version-controlled prefs folder in this repo.
# iTerm2 will read on launch and (with selection=2) auto-save changes back.
if [[ -f "$DOTFILES_DIR/.config/iterm2/com.googlecode.iterm2.plist" ]]; then
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/.config/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2
fi

# ---------------------------------------------------------------------------
# 6. tmux plugin manager (TPM)
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ---------------------------------------------------------------------------
# 7. NeoVim plugins
# ---------------------------------------------------------------------------
nvim --headless "+Lazy! restore" +qa

# ---------------------------------------------------------------------------
# 8. Ruby via rbenv
# ---------------------------------------------------------------------------
eval "$(rbenv init - bash)"
rbenv install -s 3.3.0
rbenv global 3.3.0

# ---------------------------------------------------------------------------
# 9. macOS developer defaults
# ---------------------------------------------------------------------------
# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Finder: show hidden files and all extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Dock: auto-hide and set icon size
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Save screenshots to Desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Restart affected apps
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo ""
echo "✅ Mac setup complete! Open a new terminal (iTerm2) for changes to take effect."
echo "   If iTerm2 is already running, fully quit it (⌘Q) and relaunch so it picks up"
echo "   prefs from $DOTFILES_DIR/.config/iterm2."
echo "📋 Log saved to ~/dotfiles_install_log"
