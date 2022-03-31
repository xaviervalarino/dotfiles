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
  on_attach = function(client, bufnr)
    local nmap = buf_keymaps(bufnr)
    ts_utils.setup(client)

    nmap('gs', ':TSLspOrganize<CR>')
    nmap('gr', ':TSLspRenameFile<CR>')
    nmap('gI', ':TSLspImportAll<CR>')
    nmap('gi', ':TSLspImportCurrent<CR>')
  end,
}
