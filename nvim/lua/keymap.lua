local map = vim.api.nvim_set_keymap

map('n', '<Space>', '', {})

local options = { noremap = true, silent = true }

-- Editor
map('n', '<leader>qq', ':qa<cr>', {})
map('n', '<leader>eq', ':qa!<cr>', {})
map('n', '<leader>ec', ':FzfLua colorschemes<cr>', options)

-- Tree
map('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', options)
map('n', '<leader>pf', '<cmd>NvimTreeFindFile<cr>', options)
map('n', '<leader>pr', '<cmd>NvimTreeRefresh<cr>', options)

-- Comments
map('n', '<leader>cl', ':CommentToggle<cr>', options)
map('v', '<leader>cl', ':CommentToggle<cr>', options)

-- Files
map('n', '<leader>fs', ':w<cr>', {})
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
map('n', '<leader>bd', ':bp<bar>sp<bar>bn<bar>bd<cr>', {})

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

-- Tmux
map("n", "<Leader>mo", ":VimuxOpenRunner<cr>", options)
map("n", "<Leader>md", ":VimuxCloseRunner<cr>", options)
map("n", "<Leader>mt", ":VimuxTogglePane<cr>", options)
map("n", "<Leader>mi", ":VimuxInspectRunner<cr>", options)
map("n", "<Leader>mz", ":VimuxZoomRunner<cr>", options)
map("n", "<Leader>mc", ":VimuxPromptCommand('bin/rails c')<cr>", options)

-- Test
map("n", "<leader>ta", ":TestSuite<cr>", options)
map("n", "<leader>tb", ":TestFile<cr>", options)
map("n", "<leader>tt", ":TestNearest<cr>", options)
map("n", "<leader>tl", ":TestLast<cr>", options)
map("n", "<leader>tv", ":TestVisit<cr>", options)

-- Git
map('n', '<leader>gs', ':FzfLua git_status<cr>', options)
map('n', '<leader>gl', ':FzfLua git_commits<cr>', options)
map('n', '<leader>gc', ':FzfLua git_bcommits<cr>', options)
map('n', '<leader>gb', ':Gitsigns blame_line<cr>', options)
map('n', '<leader>gtb', ':Gitsigns toggle_current_line_blame<cr>', options)
map('n', '<leader>gtb', ':Gitsigns diffthis<cr>', options)

-- Windows
map('n', '<leader>w/', '<C-W>v', options)
map('n', '<leader>wk', '<C-W>k', options)
map('n', '<leader>wj', '<C-W>j', options)
map('n', '<leader>wl', '<C-W>w', options)
map('n', '<leader>wh', '<C-W>h', options)
map('n', '<leader>wd', '<C-W>c', options)
