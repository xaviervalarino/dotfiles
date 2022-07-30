local color = require('catppuccin.palettes').get_palette()

-- Fix WildMenu controlled by CMP
-- Match color to StatusLine
vim.api.nvim_set_hl(0, 'Pmenu', { bg = color.crust })
