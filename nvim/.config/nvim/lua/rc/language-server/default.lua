local M = {}
local util = require 'rc.util'
local bufmap = util.bufkeymap

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').default_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  local map = bufmap(bufnr)

  local function rename()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end

  -- stylua: ignore start
  map.n('<leader>ca',  'vim.lsp.buf.code_action',   { desc = 'Code action' })
  map.n('gd',          vim.lsp.buf.definition,      { desc = 'Go to definition' })
  -- note: many servers do not implement this method
  map.n('gD',          vim.lsp.buf.declaration,     { desc = 'Go to declaration' })
  -- TODO: no `number` on document hover
  map.n('K',           vim.lsp.buf.hover,           { desc = 'Hover symbol info' })
  map.n('gi',          vim.lsp.buf.implementation,  { desc = 'Implementation' })
  map.n('<leader>D',   vim.lsp.buf.type_definition, { desc = 'Type definition' })
  map.n('<leader>rn',  rename,                      { desc = 'Rename reference', expr = true })
  map.n('<leader>rr',  '<cmd>LspRestart<CR>',       { desc = 'Restart LSP' })
  map.n('<leader>d',   vim.diagnostic.open_float,   { desc = 'Current diagnostic' })
  map.n('[d',          vim.diagnostic.goto_prev,    { desc = 'Previous diagnostic' })
  map.n(']d',          vim.diagnostic.goto_next,    { desc = 'Next diagnostic' })
  map.n('<leader>q',   vim.diagnostic.setloclist,   { desc = 'Diagnostic location list' })

  map.n(
    '<leader>so',
    require('telescope.builtin').lsp_document_symbols,
    { desc = 'Search document symbols' }
  )

  map.n('<leader>ca',  vim.lsp.buf.code_action,     { desc = 'Code action' })
  map.n('gr',          vim.lsp.buf.references,      { desc = 'List references' })
  map.n('<leader>f',   vim.lsp.buf.format,          { desc = 'Format buffer' })
  map.n('<C-s>',       vim.lsp.buf.signature_help,  { desc = 'Signature help' })
  --stylua: ignore end

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })

  if client.server_capabilities.documentHighlightProvider then
    local highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = highlight_group,
      buffer = 0,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = highlight_group,
      buffer = 0,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- if client.server_capabilities.documentFormattingProvider then
  --   local lsp_formatting = vim.api.nvim_create_augroup('lsp_formatting', { clear = true })
  --   vim.api.nvim_create_autocmd('BufWritePre', {
  --     group = lsp_formatting,
  --     buffer = 0,
  --     callback = function()
  --       vim.lsp.buf.format()
  --     end,
  --   })
  -- end
end

return M
