-- lsp
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'onsails/lspkind-nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'folke/neodev.nvim',
    'jose-elias-alvarez/nvim-lsp-ts-utils',
  },
  config = function()
    local nvim_lsp = require 'lspconfig'
    require 'rc.language-server.diagnostics'

    local null_ls = require 'rc.language-server.null-ls'

    local config = {
      default = require 'rc.language-server.default',
      disable_formatting = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
    }

    local servers = {
      bashls = config.default,
      cssls = config.default,
      html = config.disable_formatting,
      svelte = config.default,
      sqlls = config.default,
      denols = {
        root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc'),
        init_options = { lint = true },
        single_file_support = false,
      },
      jsonls = require 'rc.language-server.jsonls',
      lua_ls = require 'rc.language-server.lua_ls',
      tsserver = require 'rc.language-server.tsserver',
      pyright = config.default,
      clojure_lsp = config.default,
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

    if null_ls then
      null_ls.setup(config.default)
    end

    require('lspconfig.ui.windows').default_options.border = require('rc.util').float_win_style.border
  end,
}
