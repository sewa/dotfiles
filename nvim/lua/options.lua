local opt = vim.opt

-- Files
opt.swapfile      = true
opt.directory     = vim.fn.stdpath('state') .. '/swap//'
opt.hidden        = true

-- Search
opt.hlsearch      = false
opt.incsearch     = true
opt.inccommand    = 'split'
opt.ignorecase    = true
opt.smartcase     = true

opt.mouse         = 'a'

--Editing
opt.showmatch     = true
opt.scrolloff     = 12
opt.history       = 500
opt.timeoutlen    = 500
opt.autoread      = true
opt.lazyredraw    = true
opt.magic         = true
opt.clipboard     = 'unnamedplus'
opt.completeopt   = 'menuone,noinsert,noselect'
opt.splitbelow    = true
opt.splitright    = true
opt.termguicolors = true
opt.background    = 'dark'
opt.wildmode      = "longest"
opt.wildmenu      = true
opt.undofile      = true
opt.list          = true

-- Margin
opt.foldcolumn     = "2"
opt.number         = true
opt.relativenumber = false
opt.wrap           = false
opt.signcolumn     = 'yes'

-- Indent
opt.expandtab      = true
opt.smarttab       = true
opt.autoindent     = true
opt.smartindent    = true
opt.shiftwidth     = 2
opt.tabstop        = 2
opt.softtabstop    = 2

opt.switchbuf      = "useopen"
opt.cmdheight      = 0
