local helpers = require("keymap_helpers")
local options = { noremap = true, silent = true }

vim.keymap.set('n', '<Space>', '', options)

-- Editor
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', options)
vim.keymap.set('n', '<leader>eq', '<cmd>qa!<cr>', options)
vim.keymap.set('n', '<leader>ed', helpers.toggle_diagnostics, options)

-- Tree
vim.keymap.set('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', options)
vim.keymap.set('n', '<leader>pf', '<cmd>NvimTreeFindFile<cr>', options)
vim.keymap.set('n', '<leader>pr', '<cmd>NvimTreeRefresh<cr>', options)

-- Comments
vim.keymap.set('n', '<leader>cl', '<cmd>CommentToggle<cr>', options)
vim.keymap.set('v', '<leader>cl', '<cmd>CommentToggle<cr>', options)

-- Files
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr>', {})
vim.keymap.set('n', '<leader>ff', "<cmd>FzfLua files<cr>", options)
vim.keymap.set('n', '<leader>fl', "<cmd>FzfLua loclist<cr>", options)
vim.keymap.set('n', '<leader>fo', "<cmd>FzfLua oldfiles<cr>", options)

-- History
vim.keymap.set('n', '<leader>hc', '<cmd>FzfLua command_history<cr>', options)
vim.keymap.set('n', '<leader>hr', '<cmd>FzfLua registers<cr>', options)
vim.keymap.set('n', '<leader>hs', '<cmd>FzfLua search_history<cr>', options)

-- Info
vim.keymap.set('n', '<leader>ih', '<cmd>FzfLua help_tags<cr>', options)
vim.keymap.set('n', '<leader>ic', '<cmd>FzfLua commands<cr>', options)
vim.keymap.set('n', '<leader>ik', '<cmd>FzfLua keymaps<cr>', options)
vim.keymap.set('n', '<leader>im', '<cmd>FzfLua man_pages<cr>', options)

-- Buffers
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<cr>', options)
vim.keymap.set('n', '<leader>bd', '<cmd>bp<bar>sp<bar>bn<bar>bd<cr>', {})

-- Search
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep_native<cr>', options)
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua blines<cr>', options)
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>', options)
vim.keymap.set('n', '<leader>sl', '<cmd>FzfLua grep_last<cr>', options)

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", options)
vim.keymap.set("n", "<leader>xw", "<cmd>FzfLua diagnostics_workspace<cr>", options)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics focus=false filter.buf=0<cr>", options)

-- Tmux
vim.keymap.set("n", "<Leader>mo", "<cmd>VimuxOpenRunner<cr>", options)
vim.keymap.set("n", "<Leader>md", "<cmd>VimuxCloseRunner<cr>", options)
vim.keymap.set("n", "<Leader>mt", "<cmd>VimuxTogglePane<cr>", options)
vim.keymap.set("n", "<Leader>mi", "<cmd>VimuxInspectRunner<cr>", options)
vim.keymap.set("n", "<Leader>mz", "<cmd>VimuxZoomRunner<cr>", options)
vim.keymap.set("n", "<Leader>mc", "<cmd>VimuxPromptCommand('bin/rails c')<cr>", options)

-- Test
vim.keymap.set("n", "<leader>ta", "<cmd>TestSuite<cr>", options)
vim.keymap.set("n", "<leader>tb", "<cmd>TestFile<cr>", options)
vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest<cr>", options)
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", options)
vim.keymap.set("n", "<leader>tv", "<cmd>TestVisit<cr>", options)

-- Git
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', options)
vim.keymap.set('n', '<leader>gl', '<cmd>FzfLua git_commits<cr>', options)
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_bcommits<cr>', options)
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', options)
vim.keymap.set('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<cr>', options)
vim.keymap.set('n', '<leader>gtd', '<cmd>Gitsigns diffthis<cr>', options)

-- Windows
vim.keymap.set('n', '<leader>w/', '<C-W>v', options)
vim.keymap.set('n', '<leader>wk', '<C-W>k', options)
vim.keymap.set('n', '<leader>wj', '<C-W>j', options)
vim.keymap.set('n', '<leader>wl', '<C-W>w', options)
vim.keymap.set('n', '<leader>wh', '<C-W>h', options)
vim.keymap.set('n', '<leader>wd', '<C-W>c', options)

-- Copilot chat
vim.keymap.set('n', '<leader>cw', '<cmd>CopilotChat<cr>', options)
vim.keymap.set('n', '<leader>cC', '<cmd>CopilotChatClose<cr>', options)
vim.keymap.set('n', '<leader>cm', '<cmd>CopilotChatModels<cr>', options)
vim.keymap.set('n', '<leader>cc', helpers.chat, vim.tbl_extend("force", options, { desc = "Chat" }))
vim.keymap.set('n', '<leader>co', helpers.chat_with_buffer, vim.tbl_extend("force", options, { desc = "Chat with buffer" }))
vim.keymap.set('n', '<leader>ci', helpers.chat_with_selection, vim.tbl_extend("force", options, { desc = "Chat with selection" }))
vim.keymap.set('v', '<leader>ci', helpers.chat_with_selection, vim.tbl_extend("force", options, { desc = "Chat with selection" }))
