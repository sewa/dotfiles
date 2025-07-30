local M = {}

function M.toggle_diagnostics()
  local diags_active = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not diags_active)
  vim.notify("Diagnostics " .. (not diags_active and "enabled" or "disabled"))
end

return M
