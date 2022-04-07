local status_ok, ts_utils = pcall(require, 'nvim-lsp-ts-utils')
if not status_ok then
  return
end

local buf_keymaps = require('rc.util').buf_create_keymaps 'n'

return {
  init_options = require('nvim-lsp-ts-utils').init_options,
  on_init = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
  on_attach = function(_, bufnr)
    local nmap = buf_keymaps(bufnr)
    ts_utils.setup {
      auto_inlay_hints = false,
    }

    -- stylua: ignore start
    nmap('<leader>o',   ':TSLspOrganize<CR>',          { desc = 'Organize imports' })
    nmap('<leader>rf',  ':TSLspRenameFile<CR>',        { desc = 'Rename file' })
    nmap('<leader>I',   ':TSLspImportAll<CR>',         { desc = 'Import all packages' })
    nmap('<leader>ic',  ':TSLspImportCurrent<CR>',     { desc = 'Import current package' })
    nmap('<leader>th',  ':TSLspToggleInlayHints<CR>',  { desc = 'Toggle inlayed hints (Typescript)' })
    -- stylua: ignore end
  end,
}
