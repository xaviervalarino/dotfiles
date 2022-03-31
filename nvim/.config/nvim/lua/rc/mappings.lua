-- Mode mapping are created through a metatable
local map, imap, nmap, vmap = require('rc.util').create_keymaps('', 'i', 'n', 'v')

-- Remap leader
map('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make Y yank to the end of the line (behave like other capital letters)
nmap('Y', 'y$')

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
nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Jumplist mutations
-- TODO: need to look into this one more
-- nmap('k', "v:count > 5 ? 'm\'' .v:count : . 'k'" , {noremap = true, expr = true, silent = true})
vim.cmd [[
  nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
  nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
]]

-- Moving text
nmap('<A-j>', ':m .+1<CR>==')
nmap('<A-k>', ':m .-2<CR>==')
imap('<A-j>', '<Esc>:m .+1<CR>==gi')
imap('<A-k>', '<Esc>:m .-2<CR>==gi')
vmap('<A-j>', ":m '>+1<CR>gv=gv")
vmap('<A-k>', ":m '<-2<CR>gv=gv")

-- Stay where yah are, star
nmap('*', '*N')

-- Change word then replace other occurences with `.` (by using cgn)
nmap('cn', '*``cgn')
nmap('cN', '*``cgN')

-- Convenience for find/replace inside a visual area
-- prepopulates cmd mode with wrapping `\%V` guards
-- use <C-e> to move to replacement pattern
vmap(':s', ':s/\\%V\\%V/<Left><Left><Left><Left>')
