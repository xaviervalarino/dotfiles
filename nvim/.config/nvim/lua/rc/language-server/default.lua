local M = {}
local util = require('rc.util')
local bufmap = util.bufkeymap
local run_cmd = util.run_cmd

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require('cmp_nvim_lsp').update_capabilities(M.capabilities)

function M.on_attach(client, bufnr)
  local map = bufmap(bufnr)

  local function rename()
    run_cmd('IncRename ' .. vim.fn.expand '<cword>')
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
  map.n('<leader>rn',  rename,                      { desc = 'Rename reference' })
  map.n('<leader>rr',  '<cmd>LspRestart<CR>',       { desc = 'Restart LSP' })
  map.n('<leader>d',   vim.diagnostic.open_float,   { desc = 'Current diagnostic' })
  map.n('[d',          vim.diagnostic.goto_prev,    { desc = 'Previous diagnostic' })
  map.n(']d',          vim.diagnostic.goto_next,    { desc = 'Next diagnostic' })
  map.n('<leader>q',   vim.diagnostic.setloclist,   { desc = 'Diagnostic location list' })

  map.n(
    '<leader>so',
    require('telescope.builtin').lsp_document_symbols,
    { desc = 'Search document symbols'}
  )

  map.n('<leader>ca',  vim.lsp.buf.code_action,     { desc = 'Code action' })
  map.n('gr',          vim.lsp.buf.references,      { desc = 'List references' })
  map.n('<leader>f',   vim.lsp.buf.format,          { desc = 'Format buffer' })
  map.n('<C-s>',       vim.lsp.buf.signature_help,  { desc = 'Signature help' })
  --stylua: ignore end

  local diagnostic_hover = vim.api.nvim_create_augroup('lsp_diagnostic_hover', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = diagnostic_hover,
    buffer = 0,
    callback = function(arg)
      -- note: diagnostics uses zero index for line numbers, see :h api-indexing
      local current_lnum = vim.fn.line '.' - 1
      local diagnostic_count = #vim.diagnostic.get(0, { lnum = current_lnum })
      local timeout = (arg.event == 'CursorHold' and 0 or 1000)

      if arg.event == 'CursorHold' and current_lnum == vim.b.last_diagnostic_lnum then
        return
      else
        vim.b.last_diagnostic_lnum = nil
      end
      if diagnostic_count > 0 then
        vim.b.last_diagnostic_lnum = current_lnum
        vim.fn.timer_start(timeout, function()
          vim.diagnostic.open_float()
        end)
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

  if client.server_capabilities.documentSymbolProvider then
    -- hard stop servers that use deprecated `SymbolInformation`
    if client.name  ~= 'cssls' then
      require('nvim-navic').attach(client, bufnr)
    end
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
