return {
  {
    'windwp/nvim-autopairs',
    keys = (function()
      local t = {}
      for _, key in ipairs { '{', '}', '[', ']', "'", '"', '`' } do
        table.insert(t, { key, mode = 'i' })
      end
      return t
    end)(),
  },
  { 'lewis6991/gitsigns.nvim', event = { 'BufReadPre', 'BufNewFile' } },
  { 'kylechui/nvim-surround', event = { 'BufReadPost', 'BufNewFile' } },
  { 'tpope/vim-repeat', lazy = true },
  { 'tpope/vim-fugitive', cmd = { 'G', 'Git' } },
  { 'godlygeek/tabular', cmd = 'Tabularize' },
  { 'lukas-reineke/indent-blankline.nvim', event = { 'BufReadPost', 'BufNewFile' } },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          separator = '─',
        },
      },
    },
  },

  -- snippets
  {
    'L3MON4D3/LuaSnip', -- snippet engine
    event = 'VeryLazy',
    dependencies = 'rafamadriz/friendly-snippets', -- collection of snippets
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'nvim-telescope/telescope-file-browser.nvim',
        cmd = 'Telescope file_browser',
      },
    },
  },

  -- theme
  { 'kyazdani42/nvim-web-devicons', lazy = true },
  { 'catppuccin/nvim', lazy = false, name = 'catppuccin' },

  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup { text = { spinner = 'dots' } }
    end,
  },

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
          enabled = true,
          font = '+1',
        },
      },
    },
  },
  { 'ThePrimeagen/harpoon', lazy = true },
  { 'folke/which-key.nvim', lazy = true },

  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  { 'norcalli/nvim-colorizer.lua', event = { 'BufReadPost', 'BufNewFile' } },
  { 'gpanders/editorconfig.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  'AckslD/messages.nvim',
  { 'tiagovla/scope.nvim', event = { 'TabEnter', 'TabLeave' } },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },
}
