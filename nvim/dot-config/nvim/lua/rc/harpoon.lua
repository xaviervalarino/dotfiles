local harpoon = require 'harpoon'

harpoon.setup {}

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'Harpoon: [a]dd file to list' })

vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon: show list' })

vim.keymap.set('n', '<C-h>', function()
  harpoon:list():select(1)
end, { desc = 'Harpoon: Go to to 1st item' })

vim.keymap.set('n', '<C-j>', function()
  harpoon:list():select(2)
end, { desc = 'Harpoon: Go to to 2nd item' })

vim.keymap.set('n', '<C-k>', function()
  harpoon:list():select(3)
end, { desc = 'Harpoon: Go to to 3rd item' })

vim.keymap.set('n', '<C-l>', function()
  harpoon:list():select(4)
end, { desc = 'Harpoon: Go to to 4th item' })

vim.keymap.set('n', '<leader>p', function()
  harpoon:list():prev()
end, { desc = 'Harpoon: go to [p]rev file' })

vim.keymap.set('n', '<leader>n', function()
  harpoon:list():next()
end, { desc = 'Harpoon: go to [n]ext file' })
