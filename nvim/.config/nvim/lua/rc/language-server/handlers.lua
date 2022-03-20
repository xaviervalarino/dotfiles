local M = {}

local function code_lens(client)
  if client.resolved_capabilities.code_lens then
    vim.cmd[[
    augroup lsp_document_codelens
      au! * <buffer>
      autocmd BufEnter ++once          <buffer> lua require 'vim.lsp.codelens'.refresh()
      autocmd BufWritePost, CursorHold <buffer> lua require'vim.lsp.codelens'.refresh()
    augroup END
    ]]
  end
end

local function highlight_document(client)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local function autoformat_document(client)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_document_formatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup  END
    ]], false)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_status_ok then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharacterSupport = true

M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end

  require('rc.mappings').lsp(bufnr)
  highlight_document(client)
  autoformat_document(client)
  code_lens(client)
end

M.capabilities = capabilities

return M
