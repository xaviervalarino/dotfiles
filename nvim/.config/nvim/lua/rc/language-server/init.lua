local nvim_lsp_ok, nvim_lsp = pcall(require, 'lspconfig')
if not nvim_lsp_ok then return end

require 'rc.language-server.style'

local servers = {
  bashls = true,
  eslint = true,
  cssls = true,
  html = true,
  jsonls = require 'rc.language-server.servers.jsonls',
  sumneko_lua = require 'rc.language-server.servers.sumneko_lua',
  tsserver = require 'rc.language-server.servers.tsserver',
}

require 'rc.language-server.servers.null-ls'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local create_keymaps = function(bufnr, lsp_keymaps)
  local function buf_map(mode, lhs, rhs)
    local opts = { buffer = bufnr, noremap = true, silent = true, }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local keymaps = vim.tbl_extend('force', {
    { 'n', 'gd', vim.lsp.buf.definition },
    -- note: many servers do not implement this method
    { 'n', 'gD', vim.lsp.buf.declaration },
    { 'n', 'K', vim.lsp.buf.hover },
    { 'n', 'gi',  vim.lsp.buf.implementation },
    { 'n', '<leader>rn',  vim.lsp.buf.rename },
    { 'n', '<leader>rr', ':LspRestart<CR>' },
    { 'n', '[d', vim.diagnostic.goto_prev },
    { 'n', ']d', vim.diagnostic.goto_next },
    { 'n', '<space>q', vim.diagnostic.setloclist },
    { 'n', '<leader>f', vim.lsp.buf.formatting },
    { 'i', '<C-s>', vim.lsp.buf.signature_help },
  }, lsp_keymaps or {})

  for _, args in pairs(keymaps) do
    buf_map(unpack(args))
  end
end

local on_attach = function(_, bufnr)
  -- mappings
  create_keymaps(bufnr)
end

local setup_server = function(server, config)
  if type(config) ~= 'table' then
    config = {}
  end
  config = vim.tbl_deep_extend('force', {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config)

  nvim_lsp[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end
