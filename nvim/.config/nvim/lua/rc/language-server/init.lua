local nvim_lsp = require 'lspconfig'
local servers = {
  bashls = true,
  eslint = true,
  cssls = true,
  html = true,
  jsonls = true,
  sumneko_lua = require 'rc.language-server.sumneko_lua',
  tsserver = true,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local on_attach = function(_, bufnr)

  local function buf_nnoremap(lhs, rhs)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, opts)
  end
  -- mappings
  -- buf_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  buf_nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- note: many servers do not implement this method
  buf_nnoremap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_nnoremap('K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_nnoremap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- buf_nnoremap('<leader>rr', ':LspRestart<CR>')
  buf_nnoremap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_nnoremap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_nnoremap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  buf_nnoremap('<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
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
