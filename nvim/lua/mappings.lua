local map = vim.api.nvim_set_keymap

map('n', '<Space>', '', {})
vim.g.mapleader = ' '

local options = { noremap = true, silent = true }

-- Editor
map('n', '<leader>qq', ':qa<CR>', {})
map('n', '<leader>eq', ':qa!<CR>', {})
map('n', '<leader>ec', ':FzfLua colorschemes<cr>', options)

-- Tree
map('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', options)
map('n', '<leader>pf', '<cmd>NvimTreeFindFile<cr>', options)
map('n', '<leader>pr', '<cmd>NvimTreeRefresh<cr>', options)

-- Comments
map('n', '<leader>cl', ':CommentToggle<cr>', options)
map('v', '<leader>cl', ':CommentToggle<cr>', options)

-- Files
map('n', '<leader>fs', ':w<CR>', {})
map('n', '<leader>ff', ":FzfLua files<cr>", options)
map('n', '<leader>fl', ":FzfLua loclist<cr>", options)
map('n', '<leader>fo', ":FzfLua oldfiles<cr>", options)

-- History
map('n', '<leader>hc', ':FzfLua command_history<cr>', options)
map('n', '<leader>hr', ':FzfLua registers<cr>', options)
map('n', '<leader>hs', ':FzfLua search_history<cr>', options)

-- Info
map('n', '<leader>ih', ':FzfLua help_tags<cr>', options)
map('n', '<leader>ic', ':FzfLua commands<cr>', options)
map('n', '<leader>ik', ':FzfLua keymaps<cr>', options)
map('n', '<leader>im', ':FzfLua man_pages<cr>', options)

-- Buffers
map('n', '<leader>bb', ':FzfLua buffers<cr>', options)
map('n', '<leader>bd', ':bd<CR>', {})

-- Search
map('n', '<leader>/', ':FzfLua live_grep_native<cr>', options)
map('n', '<leader>sb', ':FzfLua blines<cr>', options)
map('n', '<leader>sw', ':FzfLua grep_cword<cr>', options)
map('n', '<leader>sl', ':FzfLua grep_last<cr>', options)

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble<cr>", options)
map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", options)
map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", options)
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", options)
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", options)
map("n", "<leader>xr", "<cmd>Trouble lsp_references<cr>", options)

-- Test
map("n", "<leader>mtt", ":TestNearest<cr>", options)
map("n", "<leader>mtb", ":TestFile<cr>", options)
map("n", "<leader>mta", ":TestSuite<cr>", options)
map("n", "<leader>mtl", ":TestLast<cr>", options)
map("n", "<leader>mtv", ":TestVisit<cr>", options)

-- Git
map('n', '<leader>gs', ':FzfLua git_status<cr>', options)
map('n', '<leader>gl', ':FzfLua git_commits<cr>', options)
map('n', '<leader>gc', ':FzfLua git_bcommits<cr>', options)
map('n', '<leader>gb', ':FzfLua git_branches<cr>', options)

-- Terminal
map('n', '<leader>t', ':ToggleTerm<cr>', options)
map('t', '<leader>t', '<cmd>close<cr>', options)
map('t', '<esc>', [[<C-\><C-n>]], options)
map('t', '<space>wh', [[<C-\><C-n><C-W>h]], options)
map('t', '<space>wj', [[<C-\><C-n><C-W>j]], options)
map('t', '<space>wk', [[<C-\><C-n><C-W>k]], options)
map('t', '<space>wl', [[<C-\><C-n><C-W>l]], options)

-- Windows
map('n', '<leader>w/', '<C-W>v', options)
map('n', '<leader>wk', '<C-W>k', options)
map('n', '<leader>wj', '<C-W>j', options)
map('n', '<leader>wl', '<C-W>w', options)
map('n', '<leader>wh', '<C-W>h', options)
map('n', '<leader>wd', '<C-W>c', options)
