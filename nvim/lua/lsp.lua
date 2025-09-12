local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_cmds,
  desc = 'LSP actions',
  callback = function(args)
    local buf = args.buf
    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf })
    end

    bufmap('n', '<Leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', '<Leader>lg', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', '<leader>lR', ':FzfLua lsp_references<cr>')
    bufmap('n', '<Leader>lG', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', '<Leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<Leader>lH', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
    bufmap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    bufmap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    bufmap('n', '<leader>lws', ':FzfLua lsp_live_workspace_symbols<cr>')

    bufmap('n', '<Leader>lo', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<Leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', '<Leader>ln', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    bufmap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    bufmap('n', '<Leader>lf', function()
      require('conform').format({ async = true, lsp_fallback = false })
    end)
  end
})

-- -------------- LSP CAPABILITIES --------------
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- -------------- DISABLE TSSERVER FORMATTING --------------
local on_attach = function(client, bufnr)
  if client.name == 'tsserver' or client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    -- 'eslint',  -- optional, if you also set up eslint LSP
  }
})

if lspconfig.ts_ls then
  lspconfig.ts_ls.setup({ on_attach = on_attach })
end

-- -------------- OPTIONAL: ESLINT LSP FOR CODE ACTIONS --------------
-- If you want ESLint fixes via <leader>la:
-- lspconfig.eslint.setup({
--   settings = {
--     format = { enable = false }, -- keep formatting on Conform
--     workingDirectory = { mode = "auto" },
--   },
-- })
