# Prerequisites:
# brew install fzf
# brew install exa

export CLICOLOR=1
export EDITOR="nvim"

# Homebrew
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Mongodb
export PATH="/usr/local/opt/mongodb-community@3.4/bin:$PATH"

# Postgres
export PGDATA=$HOME/Postgres@11
export PATH="/usr/local/opt/postgresql@11/bin:$PATH"

# History
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY

# Prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats " > %b"
precmd() {
    vcs_info
}
setopt prompt_subst
PROMPT='%F{blue}%2/%F{yellow}${vcs_info_msg_0_} > %F{reset}'

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin"

# NVM
source $(brew --prefix nvm)/nvm.sh --no-use

# Autocompletion
autoload -Uz compinit && compinit
source ../fzf-tab/fzf-tab.plugin.zsh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'

# Alias
alias ll='exa --long --git'
