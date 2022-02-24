local global = vim.g
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  -- TODO consider not having silent be the default
  local options = {
    noremap = true,
    silent = true
  }
  if opts then
    options = vim.tbl_deep_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Remap leader
map('', '<Space>', '<Nop>')
global.mapleader = ' '
global.maplocalleader = ' '

-- Make Y yank to the end of the line (behave like other capital letters)
map('n', 'Y', 'y$')

-- Keep cursor centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'nzzzv')
map('n', 'J', 'mzJ`z')

-- Undo break points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')
map('i', ':', ':<c-g>u')
map('i', ';', ';<c-g>u')
-- map('i', ')', ')<c-g>u', {noremap = true})

-- scroll over wrapped lines as if they were individual lines
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Jumplist mutations
-- TODO: need to look into this one more
-- map('n', 'k', "v:count > 5 ? 'm\'' .v:count : . 'k'" , {noremap = true, expr = true, silent = true})
cmd[[
  nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
  nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
]]

-- Moving text
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
map('v', '<A-j>', ':m \'>+1<CR>gv=gv')
map('v', '<A-k>', ':m \'<-2<CR>gv=gv')

-- Stay where yah are, star
map('n', '*', '*N')

-- Change word then replace other occurences with `.` (by using cgn)
map('n', 'cn', '*``cgn')
map('n', 'cN', '*``cgN')
