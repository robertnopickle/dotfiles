#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install_log)
exec 2>&1
set -x

# Install Packages
sudo apt-get update -y
sudo apt-get --assume-yes install fuse ripgrep universal-ctags

# Install Neovim
sudo modprobe fuse
sudo groupadd fuse
sudo usermod -a -G fuse "$(whoami)"
wget https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.appimage
sudo chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# Install tmux
wget https://github.com/nelsonenzo/tmux-appimage/releases/download/3.2a/tmux.appimage
sudo chmod u+x tmux.appimage
sudo mv tmux.appimage /usr/local/bin/tmux

# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install fzf
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Copy zsh config
rm -f $HOME/.zshrc
ln -sf $(pwd)/.zshrc $HOME/.zshrc

# Install node + npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24

# Install Copilot CLI
npm install -g @github/copilot

# TODO: add install for hammerspoon if MacOS
# Copy hammerspoon config and spoons if MacOS
# rm -f $HOME/.hammerspoon
# ln -sf $(pwd)/.hammerspoon $HOME/.hammerspoon

# Dotfiles..
mkdir -p "$HOME/.config"

#TODO: add install for kitty terminal if MacOS
# curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Copy kitty config if MacOS
# rm -f $HOME/.config/kitty
# ln -sf $(pwd)/.config/kitty $HOME/.config/kitty

ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf

rm -rf "$HOME/.config/nvim"
ln -s "$(pwd)/.config/nvim" "$HOME/.config/nvim"
ls -la "$HOME/.config/nvim/lazy-lock.json"
rm -rf "$HOME/.local/share/nvim" "$HOME/.cache/nvim"
ln -sf $(pwd)/.gitconfig $HOME/.gitconfig
ln -sf $(pwd)/.ignore $HOME/.ignore


# Install NeoVim plugins
nvim --headless "+Lazy! restore" +qa

# If this is a github/github codespace, lets add /workspaces/github/bin to the PATH
if [ -d "/workspaces/github/bin" ]; then
  echo 'export PATH="/workspaces/github/bin:$PATH"' >> $HOME/.zshrc
fi

# Install Ruby 3.3.0
rbenv install 3.3.0
rbenv global 3.3.0

sudo chsh -s "$(which zsh)" "$(whoami)"
