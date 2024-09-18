require("mason").setup()
require("mason-lspconfig").setup()

local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_cmds,
    desc = 'LSP actions',
    callback = function()
        local bufmap = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = true })
        end

        bufmap('n', '<Leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>')
        bufmap('n', '<Leader>lg', '<cmd>lua vim.lsp.buf.definition()<cr>')
        bufmap('n', '<leader>lR', ':FzfLua lsp_references<cr>')
        bufmap('n', '<Leader>lG', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        bufmap('n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        bufmap('n', '<Leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        bufmap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.references()<cr>')
        bufmap('n', '<Leader>lH', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        bufmap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>')
        bufmap('n', '<Leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
        bufmap('n', '<Leader>lo', '<cmd>lua vim.diagnostic.open_float()<cr>')
        bufmap('n', '<Leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', '<Leader>ln', '<cmd>lua vim.diagnostic.goto_next()<cr>')
        bufmap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        bufmap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())<CR>')
        bufmap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        bufmap('n', '<leader>lws', ':FzfLua lsp_live_workspace_symbols<cr>')

        bufmap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('x', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')

        -- if using Neovim v0.8 uncomment this
        -- bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    end
})

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'efm',
        'tsserver',
        'solargraph',
    }
})

local prettier = {
    formatCommand = 'prettier --stdin --stdin-filepath "${INPUT}"',
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

require('mason-lspconfig').setup_handlers({
    function(server)
        lspconfig[server].setup({})
    end,
    ["efm"] = function()
        lspconfig.efm.setup({
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'elixir', 'eex', 'heex' },
            init_options = {
                documentFormatting = true,
                codeAction = true
            },
            settings = {
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
        })
    end,
    ['tsserver'] = function()
        lspconfig.tsserver.setup({
            settings = {
                completions = {
                    completeFunctionCalls = true
                }
            }
        })
    end,
    ['solargraph'] = function()
        lspconfig.solargraph.setup({
            cmd = {
                "asdf",
                "exec",
                "solargraph",
                "stdio"
            },
            settings = {
                solargraph = {
                    autoformat = true,
                    completion = true,
                    diagnostic = true,
                    folding = true,
                    references = true,
                    rename = true,
                    symbols = true
                }
            }
        })
    end,
})
