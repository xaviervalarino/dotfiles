local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

local map = require('rc.util').keymap
local builtin = require 'telescope.builtin'

telescope.setup {
  defaults = {
    selection_caret = '❯ ',
    prompt_prefix = '   ',
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    find_files = {
      -- theme = 'dropdown',
    },
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
    },
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'file_browser'

map.n('<leader><space>', function()
  builtin.buffers { previewer = false }
end)
map.n('<leader>sf', builtin.find_files)
map.n('<leader>sb', builtin.current_buffer_fuzzy_find)
map.n('<leader>sd', telescope.extensions.file_browser.file_browser)
map.n('<leader>sh', builtin.help_tags)
map.n('<leader>st', builtin.tags)
map.n('<leader>s*', builtin.grep_string)
map.n('<leader>sg', builtin.live_grep)
map.n('<leader>so', function()
  builtin.tags { only_current_buffer = true }
end)
map.n('<leader>?', builtin.oldfiles)
