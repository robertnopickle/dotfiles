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
ln -sf "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.tmux.conf"  "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.ignore"     "$HOME/.ignore"

# Hammerspoon (directory — remove any existing dir/symlink first)
rm -rf "$HOME/.hammerspoon"
ln -sf "$DOTFILES_DIR/.hammerspoon" "$HOME/.hammerspoon"

# Neovim config
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
rm -rf "$HOME/.local/share/nvim" "$HOME/.cache/nvim"

# gh CLI config (only config.yml, not auth hosts)
mkdir -p "$HOME/.config/gh"
ln -sf "$DOTFILES_DIR/.config/gh/config.yml" "$HOME/.config/gh/config.yml"

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
echo "📋 Log saved to ~/dotfiles_install_log"
