# dotfiles

Personal configuration files for development environments.

## Quick Start

### macOS (fresh Mac)

```bash
git clone https://github.com/robertnopickle/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
chmod +x setup-mac.sh
./setup-mac.sh
```

### Linux / Codespaces

```bash
git clone https://github.com/robertnopickle/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
chmod +x setup.sh
./setup.sh
```

## What Gets Installed

| Tool | macOS | Linux |
|------|-------|-------|
| Neovim | brew | appimage |
| tmux | brew | appimage |
| fzf, ripgrep, zoxide, starship | brew | apt / curl |
| Node.js (via nvm) | ✅ | ✅ |
| Ruby (via rbenv) | ✅ | ✅ |
| Copilot CLI | ✅ | ✅ |
| iTerm2, Hammerspoon, Arc, Chrome | brew cask | — |

## Scripts

- **`setup-mac.sh`** — Full bootstrap for a fresh Mac (Homebrew, tools, apps, symlinks, macOS defaults)
- **`setup.sh`** — Full bootstrap for Linux / Codespaces
- **`sync.sh`** — Copy current local configs back into this repo (for committing changes)