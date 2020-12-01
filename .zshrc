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

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/Cellar/go/1.2/libexec/bin
export PATH="$PATH:/.rvm/bin:$HOME"

alias b="bundle exec"

alias nginx_start='sudo launchctl load -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_stop='sudo launchctl unload -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_restart='nginx_stop; nginx_start;'

# Postgres
export PGDATA=$HOME/Postgres@11
export PATH="/usr/local/opt/postgresql@11/bin:$PATH"

# Mongodb
export PATH="/usr/local/opt/mongodb-community@3.4/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# for capybara webkit gem mssngr web apps
export PATH="/Users/severin/Qt5.5.0/5.5/clang_64/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# System node
export PATH="/usr/local/opt/node@10/bin:$PATH"

# NVM node
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
