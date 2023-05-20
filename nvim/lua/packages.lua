require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'vijaymarupudi/nvim-fzf',
    'onsails/lspkind-nvim',
    'vim-test/vim-test',
    'preservim/vimux',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',


    {
        'projekt0n/github-nvim-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd('colorscheme github_dark')
        end,
    },

    {
        'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {
                icons = false
            }
        end
    },

    {
        'folke/which-key.nvim',
        config = function()
            require 'which-key'.setup {}
        end
    },

    {
        'ibhagwan/fzf-lua',
        config = function()
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
        end
    },

    {
        'kyazdani42/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                view = {
                    width = 35
                }
            })
            vim.g.nvim_tree_disable_window_picker = 1
        end
    },

    {
        'terrortylor/nvim-comment',
        config = function()
            require 'nvim_comment'.setup {
                comment_empty = false,
                create_mappings = false
            }
        end
    },

    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require 'lualine'.setup({
                options = {
                    theme = 'ayu'
                }
            })
        end
    },

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

    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer' },
        config = function()
            local cmp = require 'cmp'
            local lspkind = require('lspkind')
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    })
                },
                mapping = {
                    ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Select
                    }), { 'i', 'c' }),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Select
                    }), { 'i', 'c' }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                }
            })
        end
    },
})

vim.cmd [[let test#strategy = "vimux"]]
vim.cmd [[let test#ruby#use_spring_binstub = 1]]
vim.cmd [[let g:VimuxOrientation = "h"]]
vim.cmd [[let g:VimuxHeight = "40"]]
vim.cmd [[let g:VimuxCloseOnExit = 1]]
vim.cmd [[let g:VimuxUseNearest = 0]]
