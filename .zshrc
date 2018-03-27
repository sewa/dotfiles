ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export ZSH=$HOME/.oh-my-zsh

# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PATH=$PATH:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/lib/node_modules/npm

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/Cellar/go/1.2/libexec/bin
export PATH="$PATH:/.rvm/bin:$HOME" 

# alias
alias nginx_start='sudo launchctl load -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_stop='sudo launchctl unload -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_restart='nginx_stop; nginx_start;'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PGDATA=$HOME/Postgres
