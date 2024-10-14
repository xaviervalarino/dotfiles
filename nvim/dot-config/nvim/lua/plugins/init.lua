return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'
      configs.setup {
        ensure_installed = 'all',
        sync_install = false,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      }
    end,
  },
  {
    'echasnovski/mini.diff',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      local diff = require 'mini.diff'
      diff.setup {
        view = { style = 'sign' },
      }
      vim.keymap.set('n', 'dh', diff.toggle_overlay, { desc = 'Toggle [d]iff [h]unks' })
    end,
  },
  {
    'echasnovski/mini.ai',
    version = false,
    config = function()
      require('mini.ai').setup()
    end,
  },
  {
    'echasnovski/mini-git',
    version = false,
    enabled = not vim.g.vscode,
    main = 'mini.git',
    config = function()
      require('mini.git').setup()
    end,
  },

  {
    'echasnovski/mini.animate',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      require 'rc.animate'
    end,
  },
  {
    'stevearc/oil.nvim',
    enabled = not vim.g.vscode,
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'echasnovski/mini.clue',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      require 'rc.clue'
    end,
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup {}
    end,
  },
  {

    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup {
        n_lines = 200,
      }
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      require('mini.indentscope').setup {
        draw = {
          delay = 0,
          animation = function()
            return 0
          end,
        },
        symbol = '│',
      }
    end,
  },
  {
    'rose-pine/neovim',
    enabled = not vim.g.vscode,
    config = function()
      require('rose-pine').setup {}
    end,
  },
  {
    'stevearc/conform.nvim',
    enabled = not vim.g.vscode,
    event = { 'BufWritePre ' },
    cmd = { 'ConformInfo' },
    config = function()
      require 'rc.conform'
    end,
  },
  {
    'ThePrimeagen/harpoon',
    enabled = not vim.g.vscode,
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'rc.harpoon'
    end,
  },
  {
    'gbprod/yanky.nvim',
    enabled = not vim.g.vscode,
    config = function()
      require 'rc.yanky'
    end,
  },
  {
    'echasnovski/mini.comment',
    version = false,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require 'rc.comment'
    end,
  },
  {
    'folke/zen-mode.nvim',
    enabled = not vim.g.vscode,
    dependencies = {
      'folke/twilight.nvim',
    },
    cmd = 'ZenMode',
    keys = {
      { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
    },
    config = function()
      require 'rc.zenmode'
    end,
  },
  {
    'sindrets/diffview.nvim',
    enabled = not vim.g.vscode,
    config = function()
      require 'rc.diffview'
    end,
  },
  {
    'stevearc/aerial.nvim',
    enabled = not vim.g.vscode,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require 'rc.aerial'
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = {
      'html',
      'javascriptreact',
      'typescriptreact',
    },
    config = function()
      require('nvim-ts-autotag').setup {}
    end,
  },
  {
    'davidosomething/format-ts-errors.nvim',
    enabled = not vim.g.vscode,
    event = {
      'LspNotify *.ts',
      'LspNotify *.tsx',
    },
    after = function()
      require 'rc.format-ts-errors'
    end,
  },
}
