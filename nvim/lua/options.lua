local opt = vim.opt

-- Files
opt.swapfile = true
opt.undofile = true

-- Search
opt.hlsearch   = false
opt.inccommand = 'split'
opt.ignorecase = true
opt.smartcase  = true

-- Mouse
opt.mouse = 'a'

-- Editing
opt.scrolloff     = 12
opt.timeoutlen    = 500
opt.updatetime    = 250
opt.clipboard     = 'unnamedplus'
opt.splitbelow    = true
opt.splitright    = true
opt.background    = 'dark'
opt.wildmode      = 'longest:full,full'
opt.confirm       = true
opt.virtualedit   = 'block'
opt.smoothscroll  = true

-- UI
opt.cursorline    = true
opt.list          = true
opt.listchars     = { tab = '» ', trail = '·', nbsp = '␣' }
opt.fillchars     = { eob = ' ' }
opt.pumheight     = 15
opt.winborder     = 'rounded'
opt.shortmess:append('cWsI')

-- Margin
opt.foldcolumn     = '0'
opt.number         = true
opt.relativenumber = false
opt.wrap           = false
opt.signcolumn     = 'yes'

-- Folds from treesitter; foldlevel 99 opens files unfolded. Filetypes without
-- a parser get foldexpr 0, i.e. no folds. Empty foldtext keeps the folded
-- line syntax-highlighted instead of the "+-- N lines" summary.
opt.foldmethod = 'expr'
opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext   = ''
opt.foldlevel  = 99

-- Indent
opt.expandtab   = true
opt.smartindent = true
opt.shiftwidth  = 2
opt.tabstop     = 2
opt.softtabstop = 2

-- Treesitter highlighting. nvim-treesitter's `main` branch never enables this
-- itself, so every filetype with an installed parser needs an explicit start.
-- pcall keeps filetypes without a parser silent.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- Command line
opt.cmdheight  = 0

-- Experimental 0.12 message/cmdline UI. With cmdheight=0, route messages to
-- the ephemeral msg window instead of expanding the cmdline (and no more
-- "Press ENTER" prompts). Remove this line to go back to the legacy UI.
require('vim._core.ui2').enable({ msg = { targets = 'msg' } })
opt.switchbuf  = 'useopen'
