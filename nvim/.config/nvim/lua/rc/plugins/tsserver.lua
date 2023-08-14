local bufmap = require('rc.util').bufkeymap

return {
  'pmizio/typescript-tools.nvim',
  requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    require('typescript-tools').setup {}
    local map = bufmap()
    -- stylua: ignore start
    map.n('<leader>o',   '<cmd>TSToolsOraganizeImports<CR>',  { desc = 'Organize imports' })
    -- map.n('<leader>rf',  '<cmd>TSLspRenameFile<CR>',       { desc = 'Rename file' })
    map.n('<leader>i',   '<cmd>TSToolsAddMissingImports<CR>', { desc = 'Import missing imports' })
    map.n('<leader>I',  '<cmd>TSToolsOrganizeImports<CR>',    { desc = 'Sort and organize missing imports' })
    -- map.n('<leader>th',  '<cmd>TSLspToggleInlayHints<CR>',  { desc = 'Toggle inlayed hints (Typescript)' })
    -- stylua: ignore end
  end,
}
