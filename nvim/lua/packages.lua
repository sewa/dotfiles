require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'vijaymarupudi/nvim-fzf',
    'onsails/lspkind-nvim',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    javascript = { "prettierd", "prettier" },
                    typescript = { "prettierd", "prettier" },
                    javascriptreact = { "prettierd", "prettier" },
                    typescriptreact = { "prettierd", "prettier" },
                    json = { "prettierd", "prettier" },
                    css = { "prettierd", "prettier" },
                    scss = { "prettierd", "prettier" },
                    markdown = { "prettierd", "prettier" },
                    yaml = { "prettierd", "prettier" },
                },
                -- don’t fall back to LSP; we want Prettier only
                format_on_save = false,
            })
        end,
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
        'vim-test/vim-test',
        config = function()
            vim.cmd [[let test#strategy = "neovim"]]
            vim.cmd [[let test#neovim#term_position = "botright 15"]]
            vim.cmd [[let test#neovim#start_normal = 1]]
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
        "axkirillov/unified.nvim",
        event = "VeryLazy",
        opts = {
            -- you can add options here if needed
            -- e.g. always_fold = true,
        },
        keys = function()
            -- state shared between keypresses
            local state = {
                unified_active = false,
                nvimtree_was_open = false,
            }

            local function toggle_unified_with_nvimtree()
                -- try to get nvim-tree view module (don’t hard-depend on it)
                local has_nvimtree, view = pcall(require, "nvim-tree.view")

                if not state.unified_active then
                    -- activating unified.nvim
                    if has_nvimtree then
                        state.nvimtree_was_open = view.is_visible()
                        if state.nvimtree_was_open then
                            vim.cmd("NvimTreeClose")
                        end
                    end

                    -- toggle unified on
                    require("unified").toggle()
                    state.unified_active = true
                else
                    -- deactivating unified.nvim
                    require("unified").toggle()

                    -- restore nvim-tree if it was open before
                    if has_nvimtree and state.nvimtree_was_open then
                        vim.cmd("NvimTreeOpen")
                    end

                    state.unified_active = false
                    state.nvimtree_was_open = false
                end
            end

            return {
                {
                    "<leader>gd",
                    toggle_unified_with_nvimtree,
                    desc = "Git diff (unified, smart with nvim-tree)",
                    mode = "n",
                    silent = true,
                },
                -- Toggle inline diff for current file vs HEAD
                {
                    "<leader>gd",
                    function()
                        require("unified").toggle()
                    end,
                    desc = "Git Diff (inline unified diff)",
                },

                -- OPTIONAL: Show inline diff against a specific commit
                {
                    "<leader>gD",
                    function()
                        vim.ui.input({ prompt = "Diff against commit: " }, function(commit)
                            if commit and commit ~= "" then
                                require("unified").open({ commit = commit })
                            end
                        end)
                    end,
                    desc = "Git Diff against commit",
                },

                -- OPTIONAL: Refresh the diff when working on big files
                {
                    "<leader>gr",
                    function()
                        require("unified").refresh()
                    end,
                    desc = "Refresh unified diff",
                },

                -- OPTIONAL: Open a file-pair diff (not just buffer vs HEAD)
                {
                    "<leader>gF",
                    function()
                        vim.ui.input({ prompt = "File A: " }, function(a)
                            if not a then return end
                            vim.ui.input({ prompt = "File B: " }, function(b)
                                if not b then return end
                                require("unified").open({ file1 = a, file2 = b })
                            end)
                        end)
                    end,
                    desc = "Unified diff: file A vs file B",
                },
            }
        end,
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
