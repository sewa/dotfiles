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

-- Strip trailing whitespace on save. `keeppatterns` avoids clobbering the last
-- search pattern and winsaveview restores the scroll position, not just the
-- cursor. Markdown is skipped: trailing double-space is a hard line break.
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(args)
        if vim.bo[args.buf].filetype == 'markdown' then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
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
-- Neovim already detects every Elixir extension natively (.ex/.exs/mix.lock ->
-- elixir, .heex -> heex, .eex/.leex -> eelixir, .sface -> surface). The old
-- autocmds forced .heex and .sface to eelixir, which gave them the wrong
-- ftplugin/indent rules. Only .kbd is genuinely unknown to Neovim.
vim.filetype.add({
    extension = {
        kbd = 'kbd',
    },
})
