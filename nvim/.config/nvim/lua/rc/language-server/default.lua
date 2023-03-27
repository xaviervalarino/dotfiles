local M = {}
local util = require 'rc.util'
local bufmap = util.bufkeymap
local float_win_style = util.float_win_style

local diagnostic_hover = true
local dh_augroup = vim.api.nvim_create_augroup('diagnostic_hover', {})

local function dh_disable_before(callback)
  return function(...)
    diagnostic_hover = false
    callback(...)
  end
end

local function dh_enable_after(lsp_handler)
  return function(...)
    local bufnr = vim.lsp.handlers[lsp_handler](...)
    vim.api.nvim_create_autocmd('BufWinLeave', {
      group = dh_augroup,
      buffer = bufnr,
      callback = function()
        diagnostic_hover = true
      end,
    })
    return bufnr
  end
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(dh_enable_after 'hover', float_win_style)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(dh_enable_after 'signature_help', float_win_style)

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').default_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  local map = bufmap(bufnr)

  local function rename()
    return ':IncRename ' .. vim.fn.expand '<cword>'
  end

  -- stylua: ignore start
  map.n('<leader>ca',  'vim.lsp.buf.code_action',                     { desc = 'Code action' })
  map.n('gd',          vim.lsp.buf.definition,                        { desc = 'Go to definition' })
  -- note: many servers do not implement this method
  map.n('gD',          vim.lsp.buf.declaration,                       { desc = 'Go to declaration' })
  -- TODO: no `number` on document hover
  map.n('K',           dh_disable_before(vim.lsp.buf.hover),          { desc = 'Hover symbol info' })
  map.n('<C-k',        dh_disable_before(vim.lsp.buf.signature_help), { desc = 'Signature help'})
  map.n('gi',          vim.lsp.buf.implementation,                    { desc = 'Implementation' })
  map.n('<leader>D',   vim.lsp.buf.type_definition,                   { desc = 'Type definition' })
  map.n('<leader>rn',  rename,                                        { desc = 'Rename reference', expr = true })
  map.n('<leader>rr',  '<cmd>LspRestart<CR>',                         { desc = 'Restart LSP' })
  map.n('<leader>e',   vim.diagnostic.open_float,                     { desc = 'Current diagnostic' })
  map.n('[d',          vim.diagnostic.goto_prev,                      { desc = 'Previous diagnostic' })
  map.n(']d',          vim.diagnostic.goto_next,                      { desc = 'Next diagnostic' })
  map.n('<leader>q',   vim.diagnostic.setloclist,                     { desc = 'Diagnostic location list' })

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
    group = dh_augroup,
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = float_win_style.border,
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      if diagnostic_hover then
        vim.diagnostic.open_float(nil, opts)
      end
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

  if client.server_capabilities.documentFormattingProvider then
    local lsp_formatting = vim.api.nvim_create_augroup('lsp_formatting', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp_formatting,
      buffer = 0,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end
end

return M
