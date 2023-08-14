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
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },
  { 'tpope/vim-repeat', lazy = true },
  { 'tpope/vim-fugitive', cmd = { 'G', 'Git' } },
  { 'godlygeek/tabular', cmd = { 'Tab', 'Tabularize' } },

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
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  { 'tiagovla/scope.nvim', event = { 'TabEnter', 'TabLeave' } },
}
