local nvim_lsp_ok, nvim_lsp = pcall(require, 'lspconfig')
if not nvim_lsp_ok then
  return
end

local null_ls = require 'rc.language-server.null-ls'

local config = {
  default = require 'rc.language-server.default',
  disable_formatting = {
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
    end,
  },
}

local servers = {
  bashls = config.default,
  cssls = config.default,
  html = config.disable_formatting,
  denols = {
    root_dir = nvim_lsp.util.root_pattern 'deno.json',
    init_options = { lint = true },
  },
  jsonls = require 'rc.language-server.jsonls',
  sumneko_lua = require 'rc.language-server.sumneko_lua',
  tsserver = require 'rc.language-server.tsserver',
}

function config.create(self, lsp)
  local composed = {}
  if lsp.on_attach then
    composed.on_attach = function(client, bufnr)
      self.default.on_attach(client, bufnr)
      lsp.on_attach(client, bufnr)
    end
  end
  return vim.tbl_deep_extend('force', self.default, lsp, composed)
end

for server, opts in pairs(servers) do
  if opts ~= config.default then
    opts = config:create(opts)
  end
  nvim_lsp[server].setup(opts)
end

null_ls.setup(config.default)
