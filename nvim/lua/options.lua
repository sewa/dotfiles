local opt = vim.opt

-- Files
opt.swapfile  = true
opt.directory = vim.fn.stdpath('state') .. '/swap//'
opt.undofile  = true

-- Search
opt.hlsearch   = false
opt.incsearch  = true
opt.inccommand = 'split'
opt.ignorecase = true
opt.smartcase  = true

-- Mouse
opt.mouse = 'a'

-- Editing
opt.scrolloff     = 12
opt.history       = 500
opt.timeoutlen    = 500
opt.updatetime    = 250
opt.clipboard     = 'unnamedplus'
opt.completeopt   = 'menuone,noinsert,noselect'
opt.splitbelow    = true
opt.splitright    = true
opt.termguicolors = true
opt.background    = 'dark'
opt.wildmode      = 'longest'
opt.confirm       = true
opt.virtualedit   = 'block'
opt.smoothscroll  = true

-- UI
opt.cursorline    = true
opt.list          = true
opt.listchars     = { tab = '» ', trail = '·', nbsp = '␣' }
opt.fillchars     = { eob = ' ' }
opt.pumheight     = 15
opt.shortmess:append('cWsI')

-- Margin
opt.foldcolumn     = '0'
opt.number         = true
opt.relativenumber = false
opt.wrap           = false
opt.signcolumn     = 'yes'

-- Indent
opt.expandtab   = true
opt.smarttab    = true
opt.autoindent  = true
opt.smartindent = true
opt.shiftwidth  = 2
opt.tabstop     = 2
opt.softtabstop = 2

-- Command line
opt.cmdheight  = 0
opt.switchbuf  = 'useopen'
