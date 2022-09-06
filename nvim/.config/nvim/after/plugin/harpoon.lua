local ok, harpoon = pcall(require, 'harpoon')
if not ok then
  return
end

harpoon.setup {}

local map = require('rc.util').keymap
local harpoon_add_file = require('harpoon.mark').add_file
local harpoon_ui = require 'harpoon.ui'

local function nav_to_file(id)
  return function()
    harpoon_ui.nav_file(id)
  end
end

map.n('<leader>pa', harpoon_add_file, { desc = 'Harpoon: add file to list' })
map.n('<leader>l', harpoon_ui.toggle_quick_menu, { desc = 'Harpoon: list all files' })
map.n('<leader>1', nav_to_file(1), { desc = 'Harpoon: Go to 1st file' })
map.n('<leader>2', nav_to_file(2), { desc = 'Harpoon: Go to 2nd file' })
map.n('<leader>3', nav_to_file(3), { desc = 'Harpoon: Go to 3rd file' })
map.n('<leader>4', nav_to_file(4), { desc = 'Harpoon: Go to 4th file' })
