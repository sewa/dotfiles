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
alias b="bundle exec"

alias nginx_start='sudo launchctl load -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_stop='sudo launchctl unload -w /Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx_restart='nginx_stop; nginx_start;'

export PGDATA=$HOME/Postgres

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# for capybara webkit gem mssngr web apps
export PATH="/Users/severin/Qt5.5.0/5.5/clang_64/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

export PATH="/usr/local/opt/mongodb-community@3.2/bin:$PATH"
