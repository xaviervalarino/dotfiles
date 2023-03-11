local status_ok, ts_utils = pcall(require, 'nvim-lsp-ts-utils')
if not status_ok then
  return
end

local bufmap = require('rc.util').bufkeymap

return {
  init_options = require('nvim-lsp-ts-utils').init_options,
  root_dir = require('lspconfig').util.root_pattern 'package.json',
  -- TODO: have single file if not deno project?
  single_file_support = false,
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  on_attach = function(_, bufnr)
    local map = bufmap(bufnr)
    ts_utils.setup {
      auto_inlay_hints = false,
    }

    -- stylua: ignore start
    map.n('<leader>o',   '<cmd>TSLspOrganize<CR>',          { desc = 'Organize imports' })
    map.n('<leader>rf',  '<cmd>TSLspRenameFile<CR>',        { desc = 'Rename file' })
    map.n('<leader>I',   '<cmd>TSLspImportAll<CR>',         { desc = 'Import all packages' })
    map.n('<leader>ic',  '<cmd>TSLspImportCurrent<CR>',     { desc = 'Import current package' })
    map.n('<leader>th',  '<cmd>TSLspToggleInlayHints<CR>',  { desc = 'Toggle inlayed hints (Typescript)' })
    -- stylua: ignore end
  end,
}
