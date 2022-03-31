local M = {}
local buf_keymaps = require('rc.util').buf_create_keymaps 'n'

require 'rc.language-server.style'

local function lsp_highlight_document()
  vim.cmd [[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
  ]]
end

local function lsp_format_document()
  vim.cmd [[
    augroup LspFormatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
  ]]
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').update_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  local nmap = buf_keymaps(bufnr)

  nmap('<leader>ca', 'vim.lsp.buf.code_action', { desc = 'Code action' })
  nmap('gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  -- note: many servers do not implement this method
  nmap('gD', vim.lsp.buf.declaration)
  nmap('K', vim.lsp.buf.hover)
  nmap('gi', vim.lsp.buf.implementation, { desc = 'Implementation' })
  nmap('<leader>rn', vim.lsp.buf.rename, { desc = 'Rename reference' })
  nmap('<leader>rr', ':LspRestart<CR>')
  nmap('<leader>d', vim.diagnostic.open_float, { desc = 'Current diagnostic' })
  nmap('[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  nmap(']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
  nmap('<leader>q', vim.diagnostic.setloclist)
  nmap('<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
  nmap('gr', vim.lsp.buf.references, { desc = 'List references' })
  nmap('<leader>f', vim.lsp.buf.formatting)
  nmap('<C-s>', vim.lsp.buf.signature_help)

  if client.resolved_capabilities.document_highlight then
    lsp_highlight_document()
  end
  if client.resolved_capabilities.document_formatting then
    lsp_format_document()
  end
end

return M
