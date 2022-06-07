local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

local nmap = require('rc.util').create_keymaps 'n'
local builtin = require 'telescope.builtin'

telescope.load_extension 'fzf'
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

nmap('<leader><space>', builtin.buffers)
nmap('<leader>sf', builtin.find_files)
nmap('<leader>sb', builtin.current_buffer_fuzzy_find)
nmap('<leader>sh', builtin.help_tags)
nmap('<leader>st', builtin.tags)
nmap('<leader>sd', builtin.grep_string)
nmap('<leader>sp', builtin.live_grep)
nmap('<leader>so', function()
  builtin.tags { only_current_buffer = true }
end)
nmap('<leader>?', builtin.oldfiles)
