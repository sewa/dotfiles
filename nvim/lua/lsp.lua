local lsp_installer = require "nvim-lsp-installer"
local lsp_signature = require'lsp_signature'

-- use lsp_signature instead of native signature ui
vim.g.completion_enable_auto_signature = false

require 'vim.lsp.log'.set_level("trace")

local cmp = require'cmp'
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local luasnip = require("luasnip")
luasnip.filetype_extend("ruby", {"rails"})
require("luasnip/loaders/from_vscode").lazy_load()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    }
})

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    -- completion.on_attach()
    lsp_signature.on_attach()

    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>lG', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>lg', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', ':FzfLua lsp_references<cr>', opts)
    buf_set_keymap('n', '<leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>lk', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>lj', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())<CR>', opts)
    buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>lws', ':FzfLua lsp_live_workspace_symbols<cr>', opts)
    -- buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    --   -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

local prettier = {
    formatCommand = 'prettier --no-semi --stdin --stdin-filepath "${INPUT}"',
    formatStdin = true
}

local eslint = {
    lintCommand = 'eslint -f visualstudio --stdin --stdin-filename "${INPUT}"',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {
        "%f(%l,%c): %tarning %m",
        "%f(%l,%c): %rror %m"
    }
}

lsp_installer.on_server_ready(function(server)
    local default_opts = {
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }

    local server_opts = {
        ["efm"] = function()
            default_opts.init_options = {
                documentFormatting = true,
                codeAction = true
            }
            default_opts.filetypes = { 'ruby', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
            default_opts.settings = {
                log_level = 1,
                log_file = '~/efm.log',
                rootMarkers = { ".git/" },
                languages = {
                    javascript = { eslint, prettier },
                    javascriptreact = { eslint, prettier },
                    typescript = { eslint, prettier },
                    typescriptreact = { eslint, prettier }
                }
            }
        end,
    }

    local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
    server:setup(server_options)
end)
