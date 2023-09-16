local bufmap = require('rc.util').bufkeymap
-- Typescript Tools will load multiple instances of TS server
local ts_server_attached = false

return {
  {
    'marilari88/twoslash-queries.nvim',
    opts = { multi_line = true }
  },
  {
    'pmizio/typescript-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('typescript-tools').setup {
        on_attach = function(client, bufnr)
          if not ts_server_attached then
            require('twoslash-queries').attach(client, bufnr)
            ts_server_attached = true
          end
        end,
        settings = {
          separate_diagnostic_server = true,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      }
      local map = bufmap()
    -- stylua: ignore start
    map.n('<leader>o',   '<cmd>TSToolsOraganizeImports<CR>',  { desc = 'Organize imports' })
    -- map.n('<leader>rf',  '<cmd>TSLspRenameFile<CR>',       { desc = 'Rename file' })
    map.n('<leader>i',   '<cmd>TSToolsAddMissingImports<CR>', { desc = 'Import missing imports' })
    map.n('<leader>I',  '<cmd>TSToolsOrganizeImports<CR>',    { desc = 'Sort and organize missing imports' })
      -- map.n('<leader>th',  '<cmd>TSLspToggleInlayHints<CR>',  { desc = 'Toggle inlayed hints (Typescript)' })
      -- stylua: ignore end
    end,
  },
}
