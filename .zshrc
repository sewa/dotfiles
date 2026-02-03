# Prerequisites:
# brew install fzf

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# used to store sensitive information
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

export CLICOLOR=1
export EDITOR="nvim"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Mongodb
export PATH="/opt/homebrew/opt/mongodb-community/bin:$PATH"

# Postgres
export PGDATA=$HOME/Postgres@12
export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# jdk
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# Shell options
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats " > %b"
precmd() {
    vcs_info
}
setopt prompt_subst
PROMPT='%F{blue}%2/%F{yellow}${vcs_info_msg_0_} > %F{reset}'

# Python
export PATH="/opt/homebrew/opt/python@3/libexec/bin:$PATH"

# -----------------------------------------------------------------------------
# AI-powered Git Commit Function using Claude Code
# 1) gets the current staged changed diff
# 2) sends them to Claude to write the git commit message
# 3) allows you to easily accept, edit, regenerate, cancel
gcm() {
    # Check for staged changes
    if git diff --cached --quiet; then
        echo "No staged changes to commit."
        return 1
    fi

    # Check claude is available
    if ! command -v claude &> /dev/null; then
        echo "Error: 'claude' CLI not found."
        return 1
    fi

    # Function to generate commit message
    generate_commit_message() {
        git diff --cached | claude -p "Generate a commit message for this diff. Use conventional commit format (feat:, fix:, docs:, refactor:, test:, chore:). Keep the first line under 72 characters. Be specific. Output only the commit message, no trailers or co-authored-by lines."
    }

    # Function to read user input compatibly with both Bash and Zsh
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            echo -n "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # Show staged files
    echo "Staged files:"
    git diff --cached --name-status
    echo ""

    # Main script
    echo "Generating commit message..."
    commit_message=$(generate_commit_message)

    while true; do
        echo -e "\nProposed commit message:"
        echo "$commit_message"

        read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, or (c)ancel? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    echo "Changes committed successfully!"
                    return 0
                else
                    echo "Commit failed. Please check your changes and try again."
                    return 1
                fi
                ;;
            e|E )
                local tmpfile=$(mktemp)
                echo "$commit_message" > "$tmpfile"
                nvim "$tmpfile"
                commit_message=$(cat "$tmpfile")
                rm -f "$tmpfile"
                if [ -z "$commit_message" ]; then
                    echo "Empty commit message. Aborting."
                    return 1
                fi
                if git commit -m "$commit_message"; then
                    echo "Changes committed successfully with your message!"
                    return 0
                else
                    echo "Commit failed. Please check your message and try again."
                    return 1
                fi
                ;;
            r|R )
                echo "Regenerating commit message..."
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                echo "Commit cancelled."
                return 1
                ;;
            * )
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
}
# Autocompletion (with caching for faster startup)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
source "$HOME/Projects/fzf-tab/fzf-tab.plugin.zsh"

# FZF
source <(fzf --zsh)

zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Java
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
