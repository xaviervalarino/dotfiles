return {
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      '*',
      css = { css = true },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = {
        spelling = {
          enabled = true,
        },
      },
      window = {
        border = require('rc.util').float_win_style.border,
        margin = { 1, 5, 2, 7 },
      },
    },
  },
  { 'kyazdani42/nvim-web-devicons', lazy = true },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 1,
        width = 80,
      },
      plugins = {
        -- requires `allow_remote_control` and 'listen_on' to be set
        kitty = {
          -- enabled = true,
          enabled = false, -- doesn't return the font size on close, see: https://github.com/folke/zen-mode.nvim/issues/87
          font = '+1',
        },
      },
    },
  },
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'lewis6991/gitsigns.nvim' },
    opts = function()
      local builtin = require 'statuscol.builtin'

      return {
        relculright = true,
        segments = {
          {
            text = { ' ', builtin.lnumfunc, ' ' },
            click = 'v:lua.ScLa',
          },
          {
            sign = {
              name = { '.*' },
              namespace = { 'gitsigns' },
              maxwidth = 1,
              colwidth = 1,
              fillchar = '▏',
            },
            click = 'v:lua.ScSa',
          },
        },
        ft_ignore = {
          'help',
          'vim',
          'alpha',
          'lazy',
          'toggleterm',
        },
      }
    end,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },
}
