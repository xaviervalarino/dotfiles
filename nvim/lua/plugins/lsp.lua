if vim.g.vscode then
  return {}
end

-- Enable (broadcasting) snippet capability for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'yioneko/nvim-vtsls',
      'marilari88/twoslash-queries.nvim',
    },
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
              disable = { 'missing-fields' },
            },
          },
        },
      }

      require('lspconfig.configs').vtsls = require('vtsls').lspconfig

      lspconfig.vtsls.setup {
        settings = {
          typescript = {
            autoUseWorkspaceTsdk = true,
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
        on_attach = function(client, bufnr)
          require('twoslash-queries').attach(client, bufnr)

          local cmd = require('vtsls').commands

          local function on_reject(msg_or_err)
            vim.notify(msg_or_err)
          end

          vim.keymap.set('n', '<leader>im', function()
            cmd.remove_unused_imports(bufnr, function()
              cmd.add_missing_imports(bufnr, function()
                cmd.sort_imports(bufnr, nil, on_reject)
              end, on_reject)
            end, on_reject)
          end, { desc = 'TS: update [im]ports' })

          vim.keymap.set('n', '<leader>fa', function()
            cmd.fix_all(bufnr)
          end, { desc = 'TS: [f]ix [a]ll' })

          vim.keymap.set('n', '<leader>rf', ':VtsRename % ', { desc = 'TS: [r]ename [f]ile' })
        end,
      }
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua file
    opts = {},
  },
}
