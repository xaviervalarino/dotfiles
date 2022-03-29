local create_buf_map = require('rc.util').create_buf_keymap
local M = {}

local count = 1

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

local keymaps = {
  { 'n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' } },
  -- note: many servers do not implement this method
  -- { 'n', 'gD', function () return print(vim.inspect(vim.lsp.buf.declaration)) end },
  { 'n', 'K', vim.lsp.buf.hover },
  { 'n', 'gi', vim.lsp.buf.implementation, { desc = 'Implementation' } },
  { 'n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename reference' } },
  { 'n', '<leader>rr', ':LspRestart<CR>' },
  { 'n', '<leader>d', vim.diagnostic.open_float, { desc = 'Current diagnostic' } },
  { 'n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' } },
  { 'n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' } },
  { 'n', '<leader>q', vim.diagnostic.setloclist },
  { 'n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' } },
  { 'n', 'gr', vim.lsp.buf.references, { desc = 'List references' } },
  { 'n', '<leader>f', vim.lsp.buf.formatting },
  { 'n', '<C-s>', vim.lsp.buf.signature_help },
}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').update_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  -- mappings
  local buf_map = create_buf_map(bufnr)
  for _, args in pairs(keymaps) do
    buf_map(unpack(args))
  end

  if client.resolved_capabilities.document_highlight then
    lsp_highlight_document()
  end
  if client.resolved_capabilities.document_formatting then
    lsp_format_document()
  end
end

return M
