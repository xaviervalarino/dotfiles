local M = {}
local buf_keymaps = require('rc.util').buf_create_keymaps 'n'

require 'rc.language-server.style'

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').update_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  local nmap = buf_keymaps(bufnr)

  -- stylua: ignore start
  nmap('<leader>ca',  'vim.lsp.buf.code_action',   { desc = 'Code action' })
  nmap('gd',          vim.lsp.buf.definition,      { desc = 'Go to definition' })
  -- note: many servers do not implement this method
  nmap('gD',          vim.lsp.buf.declaration,     { desc = 'Go to declaration' })
  nmap('K',           vim.lsp.buf.hover,           { desc = 'Hover symbol info' })
  nmap('gi',          vim.lsp.buf.implementation,  { desc = 'Implementation' })
  nmap('<leader>D',   vim.lsp.buf.type_definition, { desc = 'Type definition' })
  nmap('<leader>rn',  vim.lsp.buf.rename,          { desc = 'Rename reference' })
  nmap('<leader>rr',  ':LspRestart<CR>',           { desc = 'Restart LSP' })
  nmap('<leader>d',   vim.diagnostic.open_float,   { desc = 'Current diagnostic' })
  nmap('[d',          vim.diagnostic.goto_prev,    { desc = 'Previous diagnostic' })
  nmap(']d',          vim.diagnostic.goto_next,    { desc = 'Next diagnostic' })
  nmap('<leader>q',   vim.diagnostic.setloclist,   { desc = 'Diagnostic location list' })

  nmap(
    '<leader>so',
    require('telescope.builtin').lsp_document_symbols,
    { desc = 'Search document symbols'}
  )

  nmap('<leader>ca',  vim.lsp.buf.code_action,     { desc = 'Code action' })
  nmap('gr',          vim.lsp.buf.references,      { desc = 'List references' })
  nmap('<leader>f',   vim.lsp.buf.formatting,      { desc = 'Format buffer' })
  nmap('<C-s>',       vim.lsp.buf.signature_help,  { desc = 'Signature help' })
  --stylua: ignore end

  if client.resolved_capabilities.document_highlight then
    local highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = vim.lsp.buf.document_highlight,
      group = highlight_group,
      pattern = '<buffer>',
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = vim.lsp.buf.clear_references,
      group = highlight_group,
      pattern = '<buffer>',
    })
  end
  if client.resolved_capabilities.document_formatting then
    local lsp_formatting = vim.api.nvim_create_augroup('lsp_formatting', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = vim.lsp.buf.formatting_sync,
      group = lsp_formatting,
      pattern = '<buffer>',
    })
  end
end

return M
