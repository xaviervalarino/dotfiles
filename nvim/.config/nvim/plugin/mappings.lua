-- Mode mapping are created through a metatable
local map = require('rc.util').keymap

-- Remap leader
map('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keep cursor centered
map.n('n', 'nzzzv')
map.n('N', 'nzzzv')
map.n('J', 'mzJ`z')

-- Undo break points
map.i(',', ',<c-g>u')
map.i('.', '.<c-g>u')
map.i('!', '!<c-g>u')
map.i('?', '?<c-g>u')
map.i(':', ':<c-g>u')
map.i(';', ';<c-g>u')
map.i(')', ')<c-g>u')

-- scroll over wrapped lines as if they were individual lines
map.n('k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
-- Jumplist mutations
map.n('j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- TODO: need to look into this one more
-- map.n('k', "v:count > 5 ? 'm\'' .v:count : . 'k'" , {noremap = true, expr = true, silent = true})
-- vim.cmd [[
--   nnormap.e <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
--   nnormap.e <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
-- ]]

-- Moving text
map.n('<A-j>', '<cmd>m .+1<CR>==')
map.n('<A-k>', '<cmd>m .-2<CR>==')
map.i('<A-j>', '<Esc><cmd>m .+1<CR>==gi')
map.i('<A-k>', '<Esc><cmd>m .-2<CR>==gi')
map.v('<A-j>', "<cmd>m '>+1<CR>gv=gv")
map.v('<A-k>', "<cmd>m '<-2<CR>gv=gv")

-- Stay where yah are, star
map.n('*', '*N')

-- Change word then replace other occurences with `.` (by using cgn)
map.n('cn', '*``cgn')
map.n('cN', '*``cgN')

-- Convenience for find/replace inside a visual area
-- prepopulates cmd mode with wrapping `\%V` guards
-- use <C-e> to move to replacement pattern
map.v('<leader>s', ':s/\\%V\\%V/<Left><Left><Left><Left>')

-- Tabularize on markers : = ,
map.nv('<leader>a:', '<cmd>Tab /:\zs<CR>')
map.nv('<leader>a=', '<cmd>Tab /=\zs<CR>')
map.nv('<leader>a,', '<cmd>Tab /,\zs<CR>')

-- Fugitive mappings
map.n('<leader>gs', '<cmd>G<CR>', { desc = 'Open Git status' })
map.n('<leader>gh', '<cmd>diffget //3<CR>', { desc = 'Select left diff' })
map.n('<leader>gj', '<cmd>diffget //2<CR>', { desc = 'Select right diff' })

-- Set CWD to buffer (manual :set autochdir)
map.n('<leader>cd', '<cmd>cd %:h<CR>', { desc = 'Set working directory to buffer' })

map.n('<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle Distraction-free Zen Mode' })
