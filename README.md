# dotfiles

Personal dotfiles for macOS development. Configuration for Neovim, Zsh, Tmux, Karabiner, and Git.

## Installation

```bash
# Clone repository
git clone git@github.com:sewa/dotfiles.git ~/Projects/dotfiles

# Required dependencies
brew install fzf fd rg bat delta neovim tmux

# Font (required for icons)
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
│   │   └── ai_terminal.lua   # AI (Claude, Codex) and shell terminals
├── karabiner/
│   └── karabiner.json        # Keyboard customization
├── .tmux.conf
├── .zshrc
├── .gitconfig
├── .rspec
└── ansible.cfg
```

## Neovim

**Leader Key:** `Space`

### Plugins

| Category | Plugin | Purpose |
|----------|--------|---------|
| Plugin Manager | lazy.nvim | With lockfile |
| LSP | mason.nvim, nvim-lspconfig | Auto-install and configure LSPs |
| Completion | blink.cmp, friendly-snippets | Autocomplete with snippets |
| Formatting | conform.nvim | Prettier for web files |
| Fuzzy Finding | fzf-lua | Files, grep, buffers, git |
| Testing | vim-test | Run tests from editor |
| Git | gitsigns.nvim, unified.nvim | Signs, blame, inline diff |
| File Tree | nvim-tree | File explorer |
| Syntax | nvim-treesitter, nvim-treesitter-context | Highlighting, folds, text objects, sticky context |
| Editing | vim-surround, vim-unimpaired, vim-repeat | Surround, bracket mappings, `.` for plugins |
| UI | github-nvim-theme, lualine, which-key | Dark theme, statusline, keymap hints |
| Diagnostics | trouble.nvim | Diagnostics list |
| TypeScript | better-ts-errors.nvim | Readable TypeScript errors |
| Elixir | elixir-tools.nvim | NextLS, Credo |

### Keybindings

#### LSP (`<leader>l`)

| Key | Action |
|-----|--------|
| `lh` | Hover documentation |
| `lg` | Go to definition |
| `lG` | Go to declaration |
| `li` | Go to implementation |
| `lt` | Type definition |
| `lH` | Signature help |
| `lr` | Rename symbol |
| `lR` | Find references |
| `lws` | Workspace symbols |
| `lwl/lwa/lwr` | List/add/remove workspace folder |
| `la` | Code action (normal and visual) |
| `lf` | Format buffer |
| `lI` | Toggle inlay hints |
| `lo` | Line diagnostics |
| `ln/lp` | Next/prev diagnostic (opens its float) |
| `le/ld` | Toggle TS error / go to definition (better-ts-errors) |

Neovim's built-in LSP maps also work: `grn`, `gra`, `grr`, `gri`, `grt`, `K`, `[d`/`]d`.

#### Completion (Insert Mode)

| Key | Action |
|-----|--------|
| `<CR>` | Accept |
| `<Tab>/<S-Tab>` | Next/prev item, or jump in snippet |
| `<C-n>/<C-p>` | Open menu / next/prev item (tmux-safe) |
| `<C-space>` | Open menu / toggle docs (outside tmux) |
| `<C-e>` | Hide menu |
| `<C-b>/<C-f>` | Scroll docs |

#### Files & Search (`<leader>f`, `<leader>s`)

| Key | Action |
|-----|--------|
| `ff` | Find files |
| `fo` | Recent files |
| `fl` | Location list |
| `fs` | Save file |
| `/` | Live grep |
| `sw` | Grep word under cursor |
| `sb` | Search buffer lines |
| `sl` | Repeat last grep |

#### History & Info (`<leader>h`, `<leader>i`)

| Key | Action |
|-----|--------|
| `hc` | Command history |
| `hs` | Search history |
| `hr` | Registers |
| `ih` | Help tags |
| `ic` | Commands |
| `ik` | Keymaps |
| `im` | Man pages |

#### Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `gs` | Git status |
| `gl` | Git log |
| `gc` | Buffer commits |
| `gb` | Blame line |
| `gtb` | Toggle blame |
| `gtd` | Gitsigns diff this |
| `gd` | Toggle inline diff vs HEAD (hides nvim-tree) |
| `gD` | Inline diff vs commit |
| `gr` | Refresh inline diff |
| `gF` | Inline diff of file A vs file B |

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
| `mc` | Toggle AI terminal |
| `mo` | Open AI terminal |
| `md` | Close AI terminal |
| `mf` | Focus AI terminal |
| `mn` | Cycle AI terminal (Claude ↔ Codex) |
| `mz` | Zoom AI terminal (fullscreen) |
| `ms` | Send selection to AI terminal (visual) |
| `mr` | Send selection to the other AI terminal (visual) |
| `mt` | Toggle shell terminal |

#### Other

| Key | Action |
|-----|--------|
| `pt` | Toggle file tree |
| `pf` | Find in tree |
| `pr` | Refresh tree |
| `cl` | Toggle comment |
| `xx` | Toggle Trouble |
| `xd` | Buffer diagnostics (Trouble) |
| `xw` | Workspace diagnostics |
| `ed` | Toggle diagnostics |
| `bb` | List buffers |
| `bd` | Delete buffer |
| `w/` | Split vertical |
| `wd` | Close window |
| `qq` | Quit all |
| `eq` | Force quit all |

#### Treesitter Text Objects

| Key | Action |
|-----|--------|
| `af/if` | Function outer/inner |
| `ab/ib` | Block outer/inner |
| `ac/ic` | Call outer/inner |
| `<leader>a` | Swap next parameter |
| `<leader>A` | Swap prev parameter |

#### Terminal Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows (works in terminal) |
| `<C-s>` | Enter/exit scroll mode (terminal) |
| `i` | Exit scroll mode |
| `q` | Close terminal window (scroll mode) |
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
- **Folds:** Treesitter-based, files open unfolded
- **Floats:** Rounded borders everywhere (`winborder`)
- **Messages:** Experimental ui2 with `cmdheight=0` (no "Press ENTER" prompts)
- **On save:** Trailing whitespace stripped (except Markdown)

### LSP Servers

- **TypeScript:** ts_ls (auto-installed)
- **Lua:** lua_ls (auto-installed)
- **Ruby:** ruby-lsp (`gem install ruby-lsp` per Ruby version via asdf, not Mason)
- **Elixir:** NextLS and Credo via elixir-tools (ElixirLS available but disabled)

### Formatting

`<leader>lf` formats with Prettier (prettierd if installed) via conform.nvim for:
- JavaScript, TypeScript, JSX, TSX
- JSON, CSS, SCSS
- Markdown, YAML

Everything else falls back to the language server's formatter.

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

Includes: Homebrew, PostgreSQL 12, MongoDB, Python 3, asdf, Java 17, Android SDK, `~/.local/bin`

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
| `H/L` | Previous/next track |
| `K` | Play/pause |

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

- ruby-lsp, which runs RuboCop for diagnostics and formatting when the project uses it
- Spring binstub for tests
- PostgreSQL 12

### Elixir

- NextLS and Credo
- With ElixirLS enabled only: pipe manipulation `<leader>lfp` (from) / `<leader>ltp` (to), macro expansion `<leader>lem`

### JavaScript/TypeScript

- ts_ls with inlay hints
- Prettier formatting
- better-ts-errors for enhanced error display

### Lua

- lua_ls with 4-space indentation
