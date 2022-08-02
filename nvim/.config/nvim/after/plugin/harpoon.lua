local nmap = require('rc.util').create_keymaps 'n'
local harpoon_add_file = require('harpoon.mark').add_file
local harpoon_ui = require 'harpoon.ui'

local function nav_to_file(id)
  return function ()
    harpoon_ui.nav_file(id)
  end
end

nmap('h ', harpoon_add_file)
nmap('hl', harpoon_ui.toggle_quick_menu)
nmap('ha', nav_to_file(1))
nmap('hs', nav_to_file(2))
nmap('hd', nav_to_file(3))
nmap('hf', nav_to_file(4))
