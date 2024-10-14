return {
  'nvim-telescope/telescope.nvim',
  enabled = not vim.g.vscode,
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    require 'rc.telescope'
  end,
}
