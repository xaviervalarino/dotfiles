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
              name = { 'GitSigns' },
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
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      use_treesitter = true,
      -- show_trailing_blankline_indent = false,
      -- show_end_of_line = true,
      char = '',
      context_char = '│',
      buftype_exclude = { 'terminal', 'help', 'nofile' },
      show_current_context = true,
      -- show_current_context_start = true,
      show_first_indent_level = false,
      context_patterns = {
        'class',
        'function',
        'method',
        'element',
        '^if',
        '^while',
        '^for',
        '^object',
        '^table',
        'block',
        'arguments',
      },
    },
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
