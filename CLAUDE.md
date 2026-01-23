# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for macOS development environment. Manages configuration for Neovim, Zsh, Tmux, and Karabiner.

## Repository Structure

- `nvim/` - Neovim configuration (Lua-based)
  - `init.lua` - Entry point, loads modules and sets up lazy.nvim
  - `lua/packages.lua` - Plugin definitions using lazy.nvim
  - `lua/lsp.lua` - Language Server Protocol setup with Mason
  - `lua/keymap.lua` - All keybindings organized by category
  - `lua/claude.lua` - Terminal management for Claude Code integration
  - `lua/options.lua` - Editor settings
  - `lsp/` - Server-specific LSP configurations
- `karabiner/` - Keyboard customization for macOS
- `.zshrc` - Shell configuration with AI-powered git commit (`gcm`)
- `.tmux.conf` - Tmux with vim keybindings, prefix: `C-space`
- `.gitconfig` - Git config with aliases (st, co, br, ci, graph)

## Neovim Architecture

**Plugin Manager:** lazy.nvim with lockfile (`lazy-lock.json`)

**Key Subsystems:**
- LSP: Mason manages server installation; lspconfig handles setup
- Completion: nvim-cmp with LuaSnip snippets
- Formatting: Conform.nvim (Prettier for web filetypes only)
- Fuzzy Finding: fzf-lua for all search operations
- AI: GitHub Copilot suggestions (C-l to accept, C-n/C-p to cycle)

**Leader Key:** Space

**Keymap Categories:**
- `<leader>l*` - LSP operations (hover, definition, references, rename, format)
- `<leader>f*` - File operations (find files, recent files)
- `<leader>s*` - Search (grep, buffer lines)
- `<leader>g*` - Git (status, log, blame, diff)
- `<leader>t*` - Testing (vim-test)
- `<leader>m*` - Terminal (Claude Code, shell)
- `<leader>p*` - File tree (nvim-tree)
- `<leader>x*` - Diagnostics (Trouble)

## Prerequisites

```bash
# Required for fzf-lua
brew install fzf fd rg bat delta

# Font
brew tap homebrew/cask-fonts
brew install --cask font-sauce-code-pro-nerd-font

# AI commit messages (for gcm function)
# https://llm.datasette.io/en/stable/
```

## Tmux Keybindings (prefix: C-space)

- `v` - Vertical split (current path)
- `s` - Horizontal split (current path)
- `h/j/k/l` - Pane navigation
- `H/J/K/L` - Pane resize
- `r` - Reload config

## Shell Commands

- `gcm` - AI-powered git commit message generator using `llm` CLI
