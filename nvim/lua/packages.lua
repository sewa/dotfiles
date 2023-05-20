require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',

    'shatur/neovim-ayu',
    'folke/trouble.nvim',
    'folke/which-key.nvim',
    'vijaymarupudi/nvim-fzf',
    'ibhagwan/fzf-lua',
    'kyazdani42/nvim-tree.lua',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',
    'terrortylor/nvim-comment',
    'lewis6991/gitsigns.nvim',
    'nvim-lualine/lualine.nvim',
    'elixir-editors/vim-elixir',
    { 'elixir-tools/elixir-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-context',
            'nvim-treesitter/nvim-treesitter-refactor',
        },
        build = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { 'ruby', 'lua', 'typescript', 'javascript', 'css', 'bash', 'elixir', 'eex', 'heex',
                    'erlang', 'html' },
                sync_install = false,
                refactor = {
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = 'grr',
                        },
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ab'] = '@block.outer',
                            ['ib'] = '@block.inner',
                            ['ac'] = '@call.outer',
                            ['ic'] = '@call.inner',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            }
        end
    },

    'ray-x/lsp_signature.nvim',
    'onsails/lspkind-nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'vim-test/vim-test',
    'preservim/vimux',
})

vim.cmd [[colorscheme ayu]]
vim.cmd [[let test#strategy = "vimux"]]
vim.cmd [[let test#ruby#use_spring_binstub = 1]]
vim.cmd [[let g:VimuxOrientation = "h"]]
vim.cmd [[let g:VimuxHeight = "40"]]
vim.cmd [[let g:VimuxCloseOnExit = 1]]
vim.cmd [[let g:VimuxUseNearest = 0]]

require 'fzf-lua'.setup {
    winopts = {
        preview = {
            horizontal = 'right:50%',
            flip_columns = 200,
        },
        height = 0.95,
        width = 0.95,
        border = true,
    }
}

require('nvim-tree').setup({
    view = {
        width = 35
    }
})
vim.g.nvim_tree_disable_window_picker = 1

require 'lualine'.setup({
    options = {
        theme = 'ayu'
    }
})

require 'which-key'.setup {}

require 'trouble'.setup {
    icons = false
}

require 'nvim_comment'.setup {
    comment_empty = false,
    create_mappings = false
}

require('gitsigns').setup()
