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
-- brew install efm-langserver
-- brew install lua-language-server && ln -s <path-to-installation> ~/lua-language-server

require'lsp'
require'options'
require'packages'
require'mappings'
require'treesitter'

vim.cmd[[filetype plugin on]]
vim.cmd[[filetype indent on]]

vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]
vim.cmd[[autocmd FileType lua setlocal shiftwidth=4 softtabstop=4 tabstop=8]]
vim.cmd[[autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 tabstop=4]]
vim.cmd[[autocmd BufRead,BufNewFile *.kbd set filetype=kbd]]