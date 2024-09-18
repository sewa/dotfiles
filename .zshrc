# Prerequisites:
# brew install fzf

export CLICOLOR=1
export EDITOR="nvim"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Mongodb
export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"

# Postgres
export PGDATA=$HOME/Postgres@11
export PATH="/opt/homebrew/opt/postgresql@11/bin:$PATH"

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

# PYTHON
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

# Autocompletion
autoload -Uz compinit && compinit
source "$HOME/Projects/fzf-tab/fzf-tab.plugin.zsh"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/ansible@8/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@11/bin:$PATH"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
