vim.diagnostic.config {
  virtual_text = false,
  -- virtual_text = { severity = 'ERROR'},
  signs = { active = require('rc.util.signs') },
  update_in_insert = true,
  severity_sort = true,
  underline = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  }
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { borders = 'rounded'})
