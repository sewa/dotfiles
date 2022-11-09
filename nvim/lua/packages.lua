require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'shatur/neovim-ayu'
    use "folke/trouble.nvim"
    use "folke/which-key.nvim"
    use 'vijaymarupudi/nvim-fzf'
    use 'ibhagwan/fzf-lua'
    use 'kyazdani42/nvim-tree.lua'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-repeat'
    use 'terrortylor/nvim-comment'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'elixir-editors/vim-elixir'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { 'ruby', 'lua', 'typescript', 'javascript', 'css', 'bash', 'elixir', 'eex', 'heex', 'erlang', 'html' },
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
    end }
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/nvim-treesitter-refactor'

    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'ray-x/lsp_signature.nvim'
    use 'onsails/lspkind-nvim'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use "rafamadriz/friendly-snippets"
    use 'vim-test/vim-test'
    use 'preservim/vimux'
end)

vim.cmd[[colorscheme ayu-mirage]]
vim.cmd[[let test#strategy = "vimux"]]
vim.cmd[[let test#ruby#use_spring_binstub = 1]]
vim.cmd[[let g:VimuxOrientation = "h"]]
vim.cmd[[let g:VimuxHeight = "40"]]
vim.cmd[[let g:VimuxCloseOnExit = 1]]
vim.cmd[[let g:VimuxUseNearest = 0]]

require'fzf-lua'.setup {
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

require'lualine'.setup({
    options = {
        theme = 'ayu'
    }
})

require'which-key'.setup{}

require'trouble'.setup{
    icons = false
}

require'nvim_comment'.setup{
    comment_empty = false,
    create_mappings= false
}

require('gitsigns').setup()
