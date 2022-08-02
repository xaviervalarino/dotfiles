local nmap = require('rc.util').create_keymaps 'n'
local harpoon_add_file = require('harpoon.mark').add_file
local harpoon_ui = require 'harpoon.ui'

local function nav_to_file(id)
  return function ()
    harpoon_ui.nav_file(id)
  end
end

require('harpoon').setup{}

nmap('<leader>pa', harpoon_add_file, { desc = 'Harpoon: add file to list'})
nmap('<leader>l', harpoon_ui.toggle_quick_menu, { desc='Harpoon: list all files'})
nmap('<leader>1', nav_to_file(1), { desc = 'Harpoon: Go to 1st file'})
nmap('<leader>2', nav_to_file(2), { desc = 'Harpoon: Go to 2nd file'})
nmap('<leader>3', nav_to_file(3), { desc = 'Harpoon: Go to 3rd file'})
nmap('<leader>4', nav_to_file(4), { desc = 'Harpoon: Go to 4th file'})
