local function cb(modname, method, ...)
  local args = { ... }
  return function()
    require(modname)[method](unpack(args))
  end
end

return {
  {
    'windwp/nvim-autopairs',
    config = true,
    keys = (function()
      local t = {}
      for _, key in ipairs { '{', '}', '[', ']', "'", '"', '`' } do
        table.insert(t, { key, mode = 'i' })
      end
      return t
    end)(),
  },
  { 'kylechui/nvim-surround', event = { 'BufReadPost', 'BufNewFile' }, config = true },
  { 'tpope/vim-repeat', lazy = true },
  { 'tpope/vim-fugitive', cmd = { 'G', 'Git' } },
  { 'godlygeek/tabular', cmd = { 'Tab', 'Tabularize' } },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      char_hightlight = 'LineNr',
      use_treesitter = true,
      -- show_trailing_blankline_indent = false,
      -- show_end_of_line = true,
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

  -- theme
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
          enabled = true,
          font = '+1',
        },
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    config = true,
    keys = {
      { '<leader>pa', cb('harpoon.mark', 'add_file'), desc = 'Harpoon: add file to list' },
      { '<leader>l', cb('harpoon.ui', 'toggle_quick_menu'), desc = 'Harpoon: list all files' },
      { '<leader>1', cb('harpoon.ui', 'nav_file', 1), desc = 'Harpoon: Go to 1st file' },
      { '<leader>2', cb('harpoon.ui', 'nav_file', 2), desc = 'Harpoon: Go to 2nd file' },
      { '<leader>3', cb('harpoon.ui', 'nav_file', 3), desc = 'Harpoon: Go to 3rd file' },
      { '<leader>4', cb('harpoon.ui', 'nav_file', 4), desc = 'Harpoon: Go to 4th file' },
    },
  },
  {
    'folke/which-key.nvim',
    lazy = true,
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
