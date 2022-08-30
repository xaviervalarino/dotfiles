-- Mode mapping are created through a metatable
local map, imap, nmap, vmap, nvmap = require('rc.util').create_keymaps('', 'i', 'n', 'v', 'nv')

-- Remap leader
map('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Save when exiting insert mode
-- TODO: consider autocommand for TextChanged,FocusLost
imap('<esc>', '<esc><cmd>update<CR>')

-- Keep cursor centered
nmap('n', 'nzzzv')
nmap('N', 'nzzzv')
nmap('J', 'mzJ`z')

-- Undo break points
imap(',', ',<c-g>u')
imap('.', '.<c-g>u')
imap('!', '!<c-g>u')
imap('?', '?<c-g>u')
imap(':', ':<c-g>u')
imap(';', ';<c-g>u')
imap(')', ')<c-g>u')

-- scroll over wrapped lines as if they were individual lines
nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
-- Jumplist mutations
nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- TODO: need to look into this one more
-- nmap('k', "v:count > 5 ? 'm\'' .v:count : . 'k'" , {noremap = true, expr = true, silent = true})
-- vim.cmd [[
--   nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
--   nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
-- ]]

-- Moving text
nmap('<A-j>', '<cmd>m .+1<CR>==')
nmap('<A-k>', '<cmd>m .-2<CR>==')
imap('<A-j>', '<Esc><cmd>m .+1<CR>==gi')
imap('<A-k>', '<Esc><cmd>m .-2<CR>==gi')
vmap('<A-j>', "<cmd>m '>+1<CR>gv=gv")
vmap('<A-k>', "<cmd>m '<-2<CR>gv=gv")

-- Stay where yah are, star
nmap('*', '*N')

-- Change word then replace other occurences with `.` (by using cgn)
nmap('cn', '*``cgn')
nmap('cN', '*``cgN')

-- Convenience for find/replace inside a visual area
-- prepopulates cmd mode with wrapping `\%V` guards
-- use <C-e> to move to replacement pattern
vmap('<leader>s', ':s/\\%V\\%V/<Left><Left><Left><Left>')

-- Tabularize on markers : = ,
nvmap('<leader>a:', '<cmd>Tab /:\zs<CR>')
nvmap('<leader>a=', '<cmd>Tab /=\zs<CR>')
nvmap('<leader>a,', '<cmd>Tab /,\zs<CR>')

-- Fugitive mappings
nmap('<leader>gs', '<cmd>G<CR>', { desc = 'Open Git status' })
nmap('<leader>gh', '<cmd>diffget //3<CR>', { desc = 'Select left diff' })
nmap('<leader>gj', '<cmd>diffget //2<CR>', { desc = 'Select right diff' })

-- Set CWD to buffer (manual :set autochdir)
nmap('<leader>cd', '<cmd>cd %:h<CR>', { desc = 'Set working directory to buffer' })

nmap('<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle Distraction-free Zen Mode' })

-- fix: cmdline=0 breaks WhichKey plugin
nmap('gg', 'gg')
