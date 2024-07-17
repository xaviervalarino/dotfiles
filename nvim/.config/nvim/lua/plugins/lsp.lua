if vim.g.vscode then
  return {}
end

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      lspconfig.eslint.setup {
        settings = {
          format = false,
          workingDirectory = {
            mode = 'auto',
          },
        },
        root_dir = lspconfig.util.find_git_ancestor,
      }
      lspconfig.graphql.setup {}
      lspconfig.html.setup {}
      lspconfig.jsonls.setup {
        capabilities = capabilities,
      }
      lspconfig.cssls.setup {}
      -- lspconfig.cssmodules_ls.setup {
      --   -- on_attach = function(client)
      --   --     client.server_capabilities.definitionProvider = false
      --   -- end,
      -- }
      -- lspconfig.css_variables.setup {}
      lspconfig.somesass_ls.setup {}
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      }
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua file
    opts = {},
  },
  {
    'marilari88/twoslash-queries.nvim',
    opts = { multi_line = true },
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'davidosomething/format-ts-errors.nvim',
    },
    config = function()
      require('typescript-tools').setup {
        handlers = {
          ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
            if result.diagnostics == nil then
              return
            end

            -- ignore some tsserver diagnostics
            local idx = 1
            while idx <= #result.diagnostics do
              local entry = result.diagnostics[idx]

              local formatter = require('format-ts-errors')[entry.code]
              entry.message = formatter and formatter(entry.message) or entry.message

              -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
              if entry.code == 80001 then
                -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                table.remove(result.diagnostics, idx)
              else
                idx = idx + 1
              end
            end

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
          end,
        },
        on_attach = function(client, bufnr)
          require('twoslash-queries').attach(client, bufnr)
        end,
      }
    end,
  },
}
