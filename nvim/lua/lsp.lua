---------------------------------------------------------------------
-- LSP keymaps (buffer-local on attach)
---------------------------------------------------------------------
local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_cmds,
    desc = 'LSP actions',
    callback = function(args)
        local buf = args.buf
        local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        -- Prefer function refs over <cmd>lua ...<cr>
        bufmap('n', '<Leader>lh', vim.lsp.buf.hover, 'Hover')
        bufmap('n', '<Leader>lg', vim.lsp.buf.definition, 'Go to definition')
        bufmap('n', '<Leader>lG', vim.lsp.buf.declaration, 'Go to declaration')
        bufmap('n', '<Leader>li', vim.lsp.buf.implementation, 'Go to implementation')
        bufmap('n', '<Leader>lt', vim.lsp.buf.type_definition, 'Type definition')
        bufmap('n', '<Leader>lr', vim.lsp.buf.rename, 'Rename symbol')
        bufmap('n', '<Leader>lH', vim.lsp.buf.signature_help, 'Signature help')

        bufmap('n', '<leader>lwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'List workspace folders')
        bufmap('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
        bufmap('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')

        -- FzfLua integrations (leave as commands)
        bufmap('n', '<leader>lR', '<cmd>FzfLua lsp_references<cr>', 'References')
        bufmap('n', '<leader>lws', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', 'Workspace symbols')

        -- Diagnostics
        bufmap('n', '<Leader>lo', function()
            vim.diagnostic.open_float(nil, { border = "rounded", focus = false, source = "if_many" })
        end, 'Line diagnostics')
        bufmap('n', '<Leader>lp', vim.diagnostic.goto_prev, 'Prev diagnostic')
        bufmap('n', '<Leader>ln', vim.diagnostic.goto_next, 'Next diagnostic')

        -- Code actions
        bufmap('n', '<leader>la', vim.lsp.buf.code_action, 'Code action')
        bufmap('x', '<leader>la', vim.lsp.buf.code_action, 'Range code action')

        -- Format: prefer Conform for web-ish filetypes, fallback to LSP
        bufmap('n', '<Leader>lf', function()
            local ok, conform = pcall(require, 'conform')
            if ok then
                local ft = vim.bo.filetype
                local webby = {
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
                if webby[ft] then
                    return conform.format({ async = true, lsp_fallback = false })
                end
            end
            vim.lsp.buf.format({ async = true }) -- fallback for everything else
        end, 'Format buffer')
    end,
})

local cmp_caps = require('cmp_nvim_lsp').default_capabilities()
if vim.lsp and vim.lsp.config then
    vim.lsp.config('*', {
        capabilities = cmp_caps,
    })
end

local function on_attach_disable_ts_formatting(client, bufnr)
    if client.name == 'tsserver' or client.name == 'ts_ls' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end
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
    },
    handlers = {
        function(server_name)
            vim.lsp.enable(server_name)
        end,
    },
})
