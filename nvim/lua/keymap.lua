local helpers = require("keymap_helpers")

local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
end

vim.keymap.set('n', '<Space>', '', opts('Leader'))

-- Editor Keymaps
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', opts('Quit all'))
vim.keymap.set('n', '<leader>eq', '<cmd>qa!<cr>', opts('Force quit all'))
vim.keymap.set('n', '<leader>ed', helpers.toggle_diagnostics, opts('Toggle diagnostics'))

-- Tree Keymaps
vim.keymap.set('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', opts('Toggle file tree'))
vim.keymap.set('n', '<leader>pf', '<cmd>NvimTreeFindFile<cr>', opts('Find file in tree'))
vim.keymap.set('n', '<leader>pr', '<cmd>NvimTreeRefresh<cr>', opts('Refresh file tree'))

-- Comment Keymaps
vim.keymap.set('n', '<leader>cl', '<cmd>CommentToggle<cr>', opts('Toggle comment'))
vim.keymap.set('v', '<leader>cl', '<cmd>CommentToggle<cr>', opts('Toggle comment'))

-- File Keymaps
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr>', opts('Save file'))
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', opts('Find files'))
vim.keymap.set('n', '<leader>fl', '<cmd>FzfLua loclist<cr>', opts('Location list'))
vim.keymap.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', opts('Recent files'))

-- History Keymaps
vim.keymap.set('n', '<leader>hc', '<cmd>FzfLua command_history<cr>', opts('Command history'))
vim.keymap.set('n', '<leader>hr', '<cmd>FzfLua registers<cr>', opts('Registers'))
vim.keymap.set('n', '<leader>hs', '<cmd>FzfLua search_history<cr>', opts('Search history'))

-- Information Keymaps
vim.keymap.set('n', '<leader>ih', '<cmd>FzfLua help_tags<cr>', opts('Help tags'))
vim.keymap.set('n', '<leader>ic', '<cmd>FzfLua commands<cr>', opts('Commands'))
vim.keymap.set('n', '<leader>ik', '<cmd>FzfLua keymaps<cr>', opts('Keymaps'))
vim.keymap.set('n', '<leader>im', '<cmd>FzfLua man_pages<cr>', opts('Man pages'))

-- Buffer Keymaps
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<cr>', opts('List buffers'))
vim.keymap.set('n', '<leader>bd', '<cmd>bp<bar>sp<bar>bn<bar>bd<cr>', opts('Delete buffer'))

-- Search Keymaps
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep_native<cr>', opts('Live grep'))
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua blines<cr>', opts('Search buffer lines'))
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>', opts('Grep word under cursor'))
vim.keymap.set('n', '<leader>sl', '<cmd>FzfLua grep_last<cr>', opts('Grep last search'))

-- Trouble Keymaps
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble<cr>', opts('Toggle Trouble'))
vim.keymap.set('n', '<leader>xw', '<cmd>FzfLua diagnostics_workspace<cr>', opts('Workspace diagnostics'))
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics focus=false filter.buf=0<cr>', opts('Document diagnostics'))

-- Test Keymaps
vim.keymap.set('n', '<leader>ta', '<cmd>TestSuite<cr>', opts('Run test suite'))
vim.keymap.set('n', '<leader>tb', '<cmd>TestFile<cr>', opts('Run test file'))
vim.keymap.set('n', '<leader>tt', '<cmd>TestNearest<cr>', opts('Run nearest test'))
vim.keymap.set('n', '<leader>tl', '<cmd>TestLast<cr>', opts('Run last test'))
vim.keymap.set('n', '<leader>tv', '<cmd>TestVisit<cr>', opts('Visit test file'))

-- Git Keymaps
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', opts('Git status'))
vim.keymap.set('n', '<leader>gl', '<cmd>FzfLua git_commits<cr>', opts('Git log'))
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_bcommits<cr>', opts('Git buffer commits'))
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', opts('Git blame line'))
vim.keymap.set('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<cr>', opts('Toggle git blame'))
vim.keymap.set('n', '<leader>gtd', '<cmd>Gitsigns diffthis<cr>', opts('Git diff this'))

-- Window Keymaps
vim.keymap.set('n', '<leader>w/', '<C-W>v', opts('Split vertical'))
vim.keymap.set('n', '<leader>wd', '<C-W>c', opts('Close window'))
