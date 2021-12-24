require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'ayu-theme/ayu-vim'
    use "folke/trouble.nvim"
    use "folke/which-key.nvim"
    use 'vijaymarupudi/nvim-fzf'
    use 'ibhagwan/fzf-lua'
    use 'kyazdani42/nvim-tree.lua'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-repeat'
    use 'terrortylor/nvim-comment'
    use 'nvim-lualine/lualine.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
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
end)

vim.cmd[[set termguicolors]]
vim.cmd[[let ayucolor="mirage"]]
vim.cmd[[colorscheme ayu]]
vim.cmd[[let test#strategy = "neovim"]]
vim.cmd[[let test#ruby#use_spring_binstub = 1]]

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
