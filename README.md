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

`setup-mac.sh` is idempotent — re-running it will not lose Neovim plugin state or
overwrite existing dotfile symlinks that already point at this repo.

## iTerm2 settings

`setup-mac.sh` configures iTerm2 to load preferences from `.config/iterm2/` in
this repo (via the built-in *Load preferences from a custom folder* feature) and
to auto-save changes back on quit. To pick up edits made through iTerm2's UI in
the repo immediately, run `./sync.sh` (or quit iTerm2).

## Scripts

- **`setup-mac.sh`** — Full bootstrap for a fresh Mac (Homebrew, tools, apps, symlinks, macOS defaults). Re-runnable.
- **`setup.sh`** — Full bootstrap for Linux / Codespaces
- **`sync.sh`** — Copy current local configs back into this repo (for committing changes)