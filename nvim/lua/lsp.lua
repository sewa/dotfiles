---------------------------------------------------------------------
-- LSP keymaps (buffer-local on attach)
---------------------------------------------------------------------

-- Global diagnostic configuration
vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    severity_sort = true,
    float = { source = "if_many" },
    -- Show the float for the diagnostic landed on by [d/]d and <leader>ln/lp
    jump = {
        on_jump = function(diagnostic, bufnr)
            if not diagnostic then return end
            vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
        end,
    },
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
            vim.diagnostic.open_float({ focus = false })
        end, 'Line diagnostics')
        bufmap('n', '<leader>lp', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
        bufmap('n', '<leader>ln', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')

        -- Code actions
        bufmap('n', '<leader>la', vim.lsp.buf.code_action, 'Code action')
        bufmap('x', '<leader>la', vim.lsp.buf.code_action, 'Range code action')

        -- Inlay hints (Neovim 0.10+)
        if client and client:supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
        bufmap('n', '<leader>lI', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, 'Toggle inlay hints')

        -- Document highlight (highlight references under cursor)
        if client and client:supports_method('textDocument/documentHighlight') then
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

        -- Format: Conform uses Prettier for the filetypes it has configured and
        -- falls back to the LSP for everything else, so the filetype list that
        -- used to live here is redundant with formatters_by_ft.
        bufmap('n', '<leader>lf', function()
            local ok, conform = pcall(require, 'conform')
            if ok then
                return conform.format({ async = true, lsp_format = 'fallback' })
            end
            vim.lsp.buf.format({ async = true })
        end, 'Format buffer')
    end,
})

-- blink.cmp registers its own capabilities on vim.lsp.config('*') from its
-- plugin/ file, so there is nothing to wire up here.

local function on_attach_disable_ts_formatting(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

vim.lsp.config('ts_ls', {
    on_attach = on_attach_disable_ts_formatting,
})

-- ruby-lsp is installed per-Ruby with `gem install ruby-lsp` and picked up via
-- the asdf shim, not through Mason: a Mason-installed gem binds its native
-- extensions to whatever Ruby was active at install time and breaks on switch.
-- It shells out to rubocop for diagnostics and formatting when the project has
-- it, so <leader>lf's LSP fallback covers Ruby with no Conform entry.
vim.lsp.enable('ruby_lsp')

require('mason').setup({})

local mlsp = require('mason-lspconfig')

-- mason-lspconfig v2 removed `handlers`; installed servers are enabled
-- automatically via `automatic_enable` (default true).
mlsp.setup({
    ensure_installed = {
        'ts_ls',
        'lua_ls',
    },
})
