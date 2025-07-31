require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'vijaymarupudi/nvim-fzf',
    'onsails/lspkind-nvim',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',

    -- Check https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua for more settings
    {
        "yetone/avante.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "hrsh7th/nvim-cmp",
            "ibhagwan/fzf-lua",
            "zbirenbaum/copilot.lua",
        },
        opts = {
            selector = {
                provider = "fzf_lua",
            },
            provider = "openai",
            providers = {
                openai = {
                    endpoint = "https://api.openai.com/v1",
                    model = "gpt-4o",
                    timeout = 30000,
                    context_window = 128000,
                    extra_request_body = {
                        temperature = 0.75,
                        max_completion_tokens = 16384,
                        reasoning_effort = "medium",
                    },
                },
            }
        },
    },

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "FzfLua",
        opts = {
            winopts = {
                height = 0.85,
                width = 0.85,
            },
        },
    },

    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            panel = { enabled = false },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-l>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-h>",
                },
            },
            filetypes = {
                markdown = true,
                gitcommit = true,
                help = false,
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },

    {
        'L3MON4D3/LuaSnip',
        dependencies = { "rafamadriz/friendly-snippets" }
    },

    {
        "ray-x/lsp_signature.nvim",
        config = function()
            -- vim.g.completion_enable_auto_signature = false
            require "lsp_signature".setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                }
            })
        end
    },

    {
        'preservim/vimux',
        config = function()
            vim.cmd [[let g:VimuxOrientation = "v"]]
            vim.cmd [[let g:VimuxHeight = "15%"]]
            vim.cmd [[let g:VimuxCloseOnExit = 1]]
            vim.cmd [[let g:VimuxUseNearest = 0]]
        end
    },

    {
        'vim-test/vim-test',
        config = function()
            vim.cmd [[let test#strategy = "vimux"]]
            vim.cmd [[let test#ruby#use_spring_binstub = 1]]
        end
    },

    {
        'projekt0n/github-nvim-theme',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme github_dark')
        end,
    },

    {
        'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {}
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
    {
        "elixir-tools/elixir-tools.nvim",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup {
                nextls = { enable = true },
                credo = {},
                elixirls = {
                    enable = true,
                    settings = elixirls.settings {
                        dialyzerEnabled = false,
                        enableTestLenses = false,
                    },
                    on_attach = function(client, bufnr)
                        vim.keymap.set("n", "<space>lfp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("n", "<space>ltp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("v", "<space>lem", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                    end,
                }
            }
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

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
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            local cmp = require 'cmp'
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()
            require 'luasnip'.filetype_extend('ruby', { 'rails' })
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol'
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
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'copilot' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp' },
                    { name = 'buffer' }
                }
            })
        end
    },
})
