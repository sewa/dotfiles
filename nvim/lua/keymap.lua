local helpers = require("keymap_helpers")
local options = { noremap = true, silent = true }

vim.keymap.set('n', '<Space>', '', options)

-- Editor Keymaps
-- General editor commands for quitting and toggling diagnostics
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', options)
vim.keymap.set('n', '<leader>eq', '<cmd>qa!<cr>', options)
vim.keymap.set('n', '<leader>ed', helpers.toggle_diagnostics, options)

-- Tree Keymaps
-- File explorer toggling and navigation
vim.keymap.set('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', options)
vim.keymap.set('n', '<leader>pf', '<cmd>NvimTreeFindFile<cr>', options)
vim.keymap.set('n', '<leader>pr', '<cmd>NvimTreeRefresh<cr>', options)

-- Comment Keymaps
-- Toggle comments in normal and visual modes
vim.keymap.set('n', '<leader>cl', '<cmd>CommentToggle<cr>', options)
vim.keymap.set('v', '<leader>cl', '<cmd>CommentToggle<cr>', options)

-- File Keymaps
-- File operations and searches
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr>', {})
vim.keymap.set('n', '<leader>ff', "<cmd>FzfLua files<cr>", options)
vim.keymap.set('n', '<leader>fl', "<cmd>FzfLua loclist<cr>", options)
vim.keymap.set('n', '<leader>fo', "<cmd>FzfLua oldfiles<cr>", options)

-- History Keymaps
-- Access various command histories
vim.keymap.set('n', '<leader>hc', '<cmd>FzfLua command_history<cr>', options)
vim.keymap.set('n', '<leader>hr', '<cmd>FzfLua registers<cr>', options)
vim.keymap.set('n', '<leader>hs', '<cmd>FzfLua search_history<cr>', options)

-- Information Keymaps
-- Access help, commands, keymaps, and man pages
vim.keymap.set('n', '<leader>ih', '<cmd>FzfLua help_tags<cr>', options)
vim.keymap.set('n', '<leader>ic', '<cmd>FzfLua commands<cr>', options)
vim.keymap.set('n', '<leader>ik', '<cmd>FzfLua keymaps<cr>', options)
vim.keymap.set('n', '<leader>im', '<cmd>FzfLua man_pages<cr>', options)

-- Buffer Keymaps
-- Buffer management and navigation
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<cr>', options)
vim.keymap.set('n', '<leader>bd', '<cmd>bp<bar>sp<bar>bn<bar>bd<cr>', {})

-- Search Keymaps
-- Various search functionalities
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep_native<cr>', options)
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua blines<cr>', options)
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>', options)
vim.keymap.set('n', '<leader>sl', '<cmd>FzfLua grep_last<cr>', options)

-- Trouble Keymaps
-- Diagnostics and quickfix list management
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", options)
vim.keymap.set("n", "<leader>xw", "<cmd>FzfLua diagnostics_workspace<cr>", options)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics focus=false filter.buf=0<cr>", options)

-- Test Keymaps
-- Testing commands for running test suites
vim.keymap.set("n", "<leader>ta", "<cmd>TestSuite<cr>", options)
vim.keymap.set("n", "<leader>tb", "<cmd>TestFile<cr>", options)
vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest<cr>", options)
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", options)
vim.keymap.set("n", "<leader>tv", "<cmd>TestVisit<cr>", options)

-- Git Keymaps
-- Git commands for status, commits, and more
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', options)
vim.keymap.set('n', '<leader>gl', '<cmd>FzfLua git_commits<cr>', options)
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_bcommits<cr>', options)
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', options)
vim.keymap.set('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<cr>', options)
vim.keymap.set('n', '<leader>gtd', '<cmd>Gitsigns diffthis<cr>', options)

-- Window Keymaps
-- Window management commands
vim.keymap.set('n', '<leader>w/', '<C-W>v', options)
vim.keymap.set('n', '<leader>wk', '<C-W>k', options)
vim.keymap.set('n', '<leader>wj', '<C-W>j', options)
vim.keymap.set('n', '<leader>wl', '<C-W>w', options)
vim.keymap.set('n', '<leader>wh', '<C-W>h', options)
vim.keymap.set('n', '<leader>wd', '<C-W>c', options)
