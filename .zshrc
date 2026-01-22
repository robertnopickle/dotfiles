# Enable persistent history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# Move to directories without cd
setopt autocd

# # Initialize completion
# autoload -U compinit; compinit

# Aliases
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'

alias n='nvim .'

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gcb='git checkout -b'
alias gcmsg='git commit -m'
alias gd='git diff'
alias gl="git pull"
alias glog='git log --oneline --decorate --graph'
alias gm='git merge'
alias gma='git merage --abort'
alias gp='git push'
alias gst='git status'
unalias ggl 2>/dev/null
unalias ggp 2>/dev/null

current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

ggl() {
  local branch
  branch=$(current_branch) || return
  git pull origin "$branch"
}

ggp() {
  local branch
  branch=$(current_branch) || return
  git push --set-upstream origin "$branch"
}

export PATH="$HOME/.fzf/bin:$PATH"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide to move between folders efficiently
eval "$(zoxide init zsh)"

# Set up the Starship prompt
eval "$(starship init zsh)"

# rbenv shim
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
