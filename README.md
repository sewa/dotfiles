# dotfiles

Personal dotfiles for macOS development. Configuration for Neovim, Zsh, Tmux, Karabiner, and Git.

## Installation

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/Projects/dotfiles

# Required dependencies
brew install fzf fd rg bat delta neovim tmux

# Font (required for icons)
brew tap homebrew/cask-fonts
brew install --cask font-sauce-code-pro-nerd-font

# fzf-tab (zsh plugin)
git clone https://github.com/Aloxaf/fzf-tab ~/Projects/fzf-tab

# Claude Code CLI (for gcm and terminal integration)
# https://docs.anthropic.com/en/docs/claude-code
```

### Symlinks

```bash
ln -s ~/Projects/dotfiles/nvim ~/.config/nvim
ln -s ~/Projects/dotfiles/.zshrc ~/.zshrc
ln -s ~/Projects/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Projects/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Projects/dotfiles/karabiner ~/.config/karabiner
```

## Repository Structure

```
dotfiles/
├── nvim/
│   ├── init.lua              # Entry point, lazy.nvim bootstrap
│   ├── lazy-lock.json        # Plugin lockfile
│   ├── lua/
│   │   ├── packages.lua      # Plugin definitions
│   │   ├── lsp.lua           # LSP setup with Mason
│   │   ├── keymap.lua        # All keybindings
│   │   ├── options.lua       # Editor settings
│   │   ├── claude.lua        # Terminal management
│   │   └── keymap_helpers.lua
│   └── lsp/
│       └── solargraph.lua    # Ruby LSP config
├── karabiner/
│   └── karabiner.json        # Keyboard customization
├── .tmux.conf
├── .zshrc
├── .gitconfig
└── .rspec
```

## Neovim

**Leader Key:** `Space`

### Plugins

| Category | Plugin | Purpose |
|----------|--------|---------|
| Plugin Manager | lazy.nvim | With lockfile |
| LSP | mason.nvim, nvim-lspconfig | Auto-install and configure LSPs |
| Completion | nvim-cmp, LuaSnip | Autocomplete with snippets |
| Formatting | conform.nvim | Prettier for web files |
| Fuzzy Finding | fzf-lua | Files, grep, buffers, git |
| AI | copilot.lua | GitHub Copilot |
| Testing | vim-test | Run tests from editor |
| Git | gitsigns.nvim, unified.nvim | Signs, blame, inline diff |
| File Tree | nvim-tree | File explorer |
| Syntax | nvim-treesitter | Highlighting, text objects |
| UI | github-nvim-theme, lualine | Dark theme, statusline |
| Diagnostics | trouble.nvim | Diagnostics list |
| Elixir | elixir-tools.nvim | NextLS, Credo, ElixirLS |

### Keybindings

#### LSP (`<leader>l`)

| Key | Action |
|-----|--------|
| `lh` | Hover documentation |
| `lg` | Go to definition |
| `lG` | Go to declaration |
| `li` | Go to implementation |
| `lt` | Type definition |
| `lr` | Rename symbol |
| `lR` | Find references |
| `la` | Code action |
| `lf` | Format buffer |
| `lI` | Toggle inlay hints |
| `lo` | Line diagnostics |
| `ln/lp` | Next/prev diagnostic |

#### Files & Search (`<leader>f`, `<leader>s`)

| Key | Action |
|-----|--------|
| `ff` | Find files |
| `fo` | Recent files |
| `fs` | Save file |
| `/` | Live grep |
| `sw` | Grep word under cursor |
| `sb` | Search buffer lines |

#### Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `gs` | Git status |
| `gl` | Git log |
| `gc` | Buffer commits |
| `gb` | Blame line |
| `gtb` | Toggle blame |
| `gd` | Diff vs HEAD |
| `gD` | Diff vs commit |

#### Testing (`<leader>t`)

| Key | Action |
|-----|--------|
| `tt` | Run nearest test |
| `tb` | Run test file |
| `ta` | Run test suite |
| `tl` | Run last test |
| `tv` | Visit test file |

#### Terminal (`<leader>m`)

| Key | Action |
|-----|--------|
| `mc` | Toggle Claude terminal |
| `mo` | Open Claude terminal |
| `md` | Close Claude terminal |
| `mf` | Focus Claude terminal |
| `mz` | Zoom Claude (fullscreen) |
| `ms` | Send selection to Claude |
| `mt` | Toggle shell terminal |

#### Other

| Key | Action |
|-----|--------|
| `pt` | Toggle file tree |
| `pf` | Find in tree |
| `cl` | Toggle comment |
| `xx` | Toggle diagnostics list |
| `bb` | List buffers |
| `bd` | Delete buffer |
| `w/` | Split vertical |
| `wd` | Close window |
| `qq` | Quit all |

#### Copilot (Insert Mode)

| Key | Action |
|-----|--------|
| `<C-l>` | Accept suggestion |
| `<C-n>` | Next suggestion |
| `<C-p>` | Previous suggestion |
| `<C-h>` | Dismiss |

#### Treesitter Text Objects

| Key | Action |
|-----|--------|
| `af/if` | Function outer/inner |
| `ab/ib` | Block outer/inner |
| `ac/ic` | Call outer/inner |
| `grr` | Smart rename |
| `<leader>a` | Swap next parameter |
| `<leader>A` | Swap prev parameter |

#### Terminal Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows (works in terminal) |
| `<C-s>` | Enter scroll mode (terminal) |
| `i` | Exit scroll mode |
| `<Esc>` | Pass to terminal app |

### Editor Settings

- **Theme:** github_dark
- **Indentation:** 2 spaces (4 for Lua)
- **Line numbers:** Absolute
- **Sign column:** Always visible
- **Scrolloff:** 12 lines
- **Mouse:** Enabled
- **Clipboard:** System clipboard
- **Search:** Case-insensitive, smart-case
- **Swap/Undo:** Enabled with persistent undo

### LSP Servers

- **TypeScript:** ts_ls (auto-installed)
- **Lua:** lua_ls (auto-installed)
- **Ruby:** Solargraph (via bundle exec)
- **Elixir:** NextLS, ElixirLS, Credo

### Formatting

Web files use Prettier via conform.nvim:
- JavaScript, TypeScript, JSX, TSX
- JSON, CSS, SCSS
- Markdown, YAML

## Tmux

**Prefix:** `C-space` (Ctrl+Space)

| Key | Action |
|-----|--------|
| `v` | Vertical split |
| `s` | Horizontal split |
| `c` | New window |
| `h/j/k/l` | Navigate panes |
| `H/J/K/L` | Resize panes |
| `r` | Reload config |

### Settings

- **History:** 50,000 lines
- **Mouse:** Enabled
- **True color:** Enabled
- **Vi copy mode:** `v` to select, `y` to copy

## Shell (Zsh)

### Features

- **Prompt:** `path > branch >` (blue path, yellow branch)
- **History:** 1M entries, shared across sessions, no duplicates
- **Completion:** fzf-tab with space to accept
- **Auto-pushd:** Directory stack management

### PATH

Includes: Homebrew, PostgreSQL 12, MongoDB, Python 3, asdf, Java 17, Android SDK

### Functions

#### `gcm` - AI Git Commit

Generates commit messages using Claude Code CLI:

```bash
gcm
# Shows staged files
# Generates conventional commit message
# Options: (a)ccept, (e)dit, (r)egenerate, (c)ancel
```

Uses conventional commit format: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`

## Git

### Aliases

| Alias | Command |
|-------|---------|
| `st` | status |
| `co` | checkout |
| `br` | branch |
| `ci` | commit |
| `unstage` | reset HEAD -- |
| `last` | log -1 HEAD |
| `graph` | log --graph --oneline --all |

### Settings

- **Diff algorithm:** histogram
- **Merge conflicts:** zdiff3 (three-way)
- **Color moved:** Highlights moved code blocks
- **Auto-stash:** On rebase
- **Auto-prune:** On fetch
- **Auto-setup remote:** On push

## Karabiner

### System-Wide

- **Caps Lock** → Left Control

### Media Controls (Ctrl+Cmd)

| Key | Action |
|-----|--------|
| `N/M` | Brightness down/up |
| `U/O` | Volume down/up |
| `I` | Mute |
| `P` | Play/pause |

### Space Navigation (Opt)

| Key | Action |
|-----|--------|
| `Opt+H` | Previous desktop/space |
| `Opt+L` | Next desktop/space |

### Vi Mode

Hold `S` + movement key to navigate. Works system-wide.

| Key | Action |
|-----|--------|
| `h/j/k/l` | Arrow keys |
| `w/b` | Word forward/backward |
| `0/4` | Line start/end (Ctrl+A/E) |
| `f` | Globe/fn key |

### Visual Mode

Hold `V` + movement key to select text. Excluded from terminals and editors (where native vi works).

| Key | Action |
|-----|--------|
| `h/j/k/l` | Select char/line |
| `w/b` | Select word forward/backward |
| `0/4` | Select to line start/end |

## Language Support

### Ruby/Rails

- Solargraph LSP via bundler
- Spring binstub for tests
- PostgreSQL 12

### Elixir

- NextLS, ElixirLS, Credo
- Pipe manipulation: `<leader>lfp` (from), `<leader>ltp` (to)
- Macro expansion: `<leader>lem`

### JavaScript/TypeScript

- ts_ls with inlay hints
- Prettier formatting
- better-ts-errors for enhanced error display

### Lua

- lua_ls with 4-space indentation
