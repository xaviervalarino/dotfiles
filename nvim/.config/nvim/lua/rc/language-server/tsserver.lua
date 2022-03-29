local status_ok, ts_utils = pcall(require, 'nvim-lsp-ts-utils')
if not status_ok then
  return
end

local create_buf_keymap = require('rc.util').create_buf_keymap

local keymaps = {
  { 'n', 'gs', ':TSLspOrganize<CR>' },
  { 'n', 'gr', ':TSLspRenameFile<CR>' },
  { 'n', 'gI', ':TSLspImportAll<CR>' },
  { 'n', 'gi', ':TSLspImportCurrent<CR>' },
}

return {
  init_options = require('nvim-lsp-ts-utils').init_options,
  on_init = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
  on_attach = function(client, bufnr)
    local buf_map = create_buf_keymap(bufnr)
    ts_utils.setup(client)
    for _, keymap in ipairs(keymaps) do
      buf_map(unpack(keymap))
    end
  end,
}
