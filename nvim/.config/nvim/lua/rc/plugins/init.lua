local function cb(modname, method, ...)
  local args = { ... }
  return function()
    require(modname)[method](unpack(args))
  end
end

return {
  {
    'windwp/nvim-autopairs',
    opts = {},
    keys = (function()
      local t = {}
      for _, key in ipairs { '{', '}', '[', ']', "'", '"', '`' } do
        table.insert(t, { key, mode = 'i' })
      end
      return t
    end)(),
  },
  { 'kylechui/nvim-surround', event = { 'BufReadPost', 'BufNewFile' } },
  { 'tpope/vim-repeat', lazy = true },
  { 'tpope/vim-fugitive', cmd = { 'G', 'Git' } },
  { 'godlygeek/tabular', cmd = 'Tabularize' },
  { 'lukas-reineke/indent-blankline.nvim', event = { 'BufReadPost', 'BufNewFile' } },

  -- theme
  { 'kyazdani42/nvim-web-devicons', lazy = true },

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
  {
    'ThePrimeagen/harpoon',
    opts = {},
    keys = {
      { '<leader>pa', cb('harpoon.mark', 'add_file'), desc = 'Harpoon: add file to list' },
      { '<leader>l', cb('harpoon.ui', 'toggle_quick_menu'), desc = 'Harpoon: list all files' },
      { '<leader>1', cb('harpoon.ui', 'nav_file', 1), desc = 'Harpoon: Go to 1st file' },
      { '<leader>2', cb('harpoon.ui', 'nav_file', 2), desc = 'Harpoon: Go to 2nd file' },
      { '<leader>3', cb('harpoon.ui', 'nav_file', 3), desc = 'Harpoon: Go to 3rd file' },
      { '<leader>4', cb('harpoon.ui', 'nav_file', 4), desc = 'Harpoon: Go to 4th file' },
    },
  },
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
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      '*',
      css = { css = true },
    },
  },
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
