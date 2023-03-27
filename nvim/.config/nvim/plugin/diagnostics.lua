local util = require 'rc.util'
local diagnostic_signs = util.diagnostic_signs
local float_win_style = util.float_win_style

for _, sign in ipairs(diagnostic_signs) do
  local hl = 'DiagnosticSign' .. sign.name
  vim.fn.sign_define(hl, {
    texthl = hl,
    text = sign.icon,
    numhl = hl,
  })
end

vim.fn.sign_define('DiagnosticSignError', { text = '' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '' })
vim.fn.sign_define('DiagnosticSignHint', { text = '' })

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    spacing = 0,
    format = function(diagnostic)
      for _, sign in ipairs(diagnostic_signs) do
        if vim.diagnostic.severity[sign.name:upper()] == diagnostic.severity then
          return sign.icon
        end
      end
    end,
  },
  signs = true,
  severity_sort = true,
  underline = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = float_win_style.border,
    source = 'always',
    header = '',
    prefix = '',
  },
}
