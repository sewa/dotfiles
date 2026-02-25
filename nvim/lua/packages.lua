require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    {
        "OlegGulevskyy/better-ts-errors.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        opts = {
            keymaps = {
                toggle = "<leader>le",
                go_to_definition = "<leader>ld",
            },
        },
    },
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
        config = function()
            require('fzf-lua').setup({
                winopts = {
                    height = 0.95,
                    width = 0.95,
                    border = true,
                    preview = {
                        horizontal = 'right:50%',
                        flip_columns = 200,
                    },
                },
            })
        end,
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
        'nvim-tree/nvim-tree.lua',
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
                        vim.keymap.set("n", "<leader>lfp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("n", "<leader>ltp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("v", "<leader>lem", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
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
        },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed = { 'ruby', 'lua', 'typescript', 'javascript', 'css', 'bash', 'elixir', 'eex', 'heex',
                    'erlang', 'html' },
            })

            require('nvim-treesitter-textobjects').setup({
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
            })
        end
    },

    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'none',
                ['<CR>']    = { 'accept', 'fallback' },
                ['<Tab>']   = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<Down>']  = { 'select_next', 'fallback' },
                ['<Up>']    = { 'select_prev', 'fallback' },
                ['<C-e>']   = { 'hide', 'fallback' },
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-b>']   = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>']   = { 'scroll_documentation_down', 'fallback' },
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
            },
            signature = {
                enabled = true,
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
        opts_extend = { 'sources.default' },
    },
})
