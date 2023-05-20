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
if not vim.loop.fs_stat(lazypath) then
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
require'completion'
require'lsp'
require'options'
require'keymap'

vim.cmd[[filetype plugin on]]
vim.cmd[[filetype indent on]]

vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]
vim.cmd[[autocmd FileType lua setlocal shiftwidth=4 softtabstop=4 tabstop=8]]
vim.cmd[[autocmd BufRead,BufNewFile *.kbd set filetype=kbd]]

vim.cmd[[au BufRead,BufNewFile *.ex,*.exs set filetype=elixir]]
vim.cmd[[au BufRead,BufNewFile *.eex,*.heex,*.leex,*.sface,*.lexs set filetype=eelixir]]
vim.cmd[[au BufRead,BufNewFile mix.lock set filetype=elixir]]
