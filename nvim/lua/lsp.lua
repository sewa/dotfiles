---------------------------------------------------------------------
-- LSP keymaps (buffer-local on attach)
---------------------------------------------------------------------

-- Filetypes that should use Conform (Prettier) instead of LSP formatting
local webby_filetypes = {
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
    json = true,
    css = true,
    scss = true,
    markdown = true,
    yaml = true,
}

-- Global diagnostic configuration
vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
})

local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_cmds,
    desc = 'LSP actions',
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        -- Prefer function refs over <cmd>lua ...<cr>
        bufmap('n', '<leader>lh', vim.lsp.buf.hover, 'Hover')
        bufmap('n', '<leader>lg', vim.lsp.buf.definition, 'Go to definition')
        bufmap('n', '<leader>lG', vim.lsp.buf.declaration, 'Go to declaration')
        bufmap('n', '<leader>li', vim.lsp.buf.implementation, 'Go to implementation')
        bufmap('n', '<leader>lt', vim.lsp.buf.type_definition, 'Type definition')
        bufmap('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
        bufmap('n', '<leader>lH', vim.lsp.buf.signature_help, 'Signature help')

        bufmap('n', '<leader>lwl', function()
            vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'List workspace folders')
        bufmap('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
        bufmap('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')

        -- FzfLua integrations (leave as commands)
        bufmap('n', '<leader>lR', '<cmd>FzfLua lsp_references<cr>', 'References')
        bufmap('n', '<leader>lws', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Workspace symbols')

        -- Diagnostics
        bufmap('n', '<leader>lo', function()
            vim.diagnostic.open_float({ border = "rounded", focus = false, source = "if_many" })
        end, 'Line diagnostics')
        bufmap('n', '<leader>lp', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
        bufmap('n', '<leader>ln', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')

        -- Code actions
        bufmap('n', '<leader>la', vim.lsp.buf.code_action, 'Code action')
        bufmap('x', '<leader>la', vim.lsp.buf.code_action, 'Range code action')

        -- Inlay hints (Neovim 0.10+)
        if client and client.supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
        bufmap('n', '<leader>lI', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, 'Toggle inlay hints')

        -- Document highlight (highlight references under cursor)
        if client and client.supports_method('textDocument/documentHighlight') then
            local hl_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
            vim.api.nvim_clear_autocmds({ group = hl_group, buffer = buf })
            vim.api.nvim_create_autocmd('CursorHold', {
                group = hl_group,
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                group = hl_group,
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Format: prefer Conform for web-ish filetypes, fallback to LSP
        bufmap('n', '<leader>lf', function()
            local ok, conform = pcall(require, 'conform')
            if ok and webby_filetypes[vim.bo.filetype] then
                return conform.format({ async = true, lsp_fallback = true })
            end
            vim.lsp.buf.format({ async = true })
        end, 'Format buffer')
    end,
})

local cmp_caps = require('blink.cmp').get_lsp_capabilities()
if vim.lsp and vim.lsp.config then
    vim.lsp.config('*', {
        capabilities = cmp_caps,
    })
end

local function on_attach_disable_ts_formatting(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

if vim.lsp and vim.lsp.config then
    vim.lsp.config('ts_ls', {
        on_attach = on_attach_disable_ts_formatting,
    })
end

require('mason').setup({})

local mlsp = require('mason-lspconfig')

mlsp.setup({
    ensure_installed = {
        'ts_ls',
        'lua_ls',
    },
    handlers = {
        function(server_name)
            vim.lsp.enable(server_name)
        end,
    },
})
