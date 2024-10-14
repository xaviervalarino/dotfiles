require('aerial').setup {
  layout = {
    width = 0.2,
    default_direction = 'prefer_left',
  },
  attach_mode = 'global',
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}

vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { desc = 'Open Code Outline' })
