-- Prerequisites
-- brew tap homebrew/cask-fonts
-- brew install --cask font-sauce-code-pro-nerd-font
--
-- fzf-lua requires the following packages:
-- brew install fzf
-- brew install fd
-- brew install rg
-- brew install bat
-- brew install delta

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require'packages'
require'lsp'
require'options'
require'keymap'
require'ai_terminal'

vim.cmd.filetype('plugin on')
vim.cmd.filetype('indent on')

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Lua-specific indentation
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 8
    end,
})

-- Custom filetypes
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.kbd',
    callback = function()
        vim.bo.filetype = 'kbd'
    end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.ex', '*.exs', 'mix.lock' },
    callback = function()
        vim.bo.filetype = 'elixir'
    end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.eex', '*.heex', '*.leex', '*.sface', '*.lexs' },
    callback = function()
        vim.bo.filetype = 'eelixir'
    end,
})
