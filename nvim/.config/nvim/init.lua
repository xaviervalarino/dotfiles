-- Set options -----------------------
local set = vim.opt
local window = vim.wo

set.termguicolors = true
set.linebreak = true
set.laststatus = 3

set.mouse = 'a'
set.spell = true

set.showbreak = '↪'
set.listchars:append {
  space = '·',
  tab = '→ ',
  eol = '¬',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}

set.autowriteall = true

-- Visual -------------------------
set.breakindent = true
set.relativenumber = true
set.number = true
set.updatetime = 250
set.cursorline = true
set.wrap = false
window.signcolumn = 'yes'

vim.g.netrw_banner = 0
-- let g:netrw_browse_split = 4

set.fillchars = {
  horiz = '━',
  horizup = '━',
  horizdown = '━',
  vert = ' ',
  vertleft = '━',
  vertright = '━',
  verthoriz = '━',
}

set.cmdheight = 0
set.shortmess:append 'c' -- don't give `ins-completion-menu` messages
set.shortmess:append 's' -- don't give "search hit BOTTOM, continuing at TOP"
set.shortmess:append 'C' -- don't give messages while scanning for ins-completion
set.shortmess:append 'S' -- do not show search count message when searching

-- Search ------------------------------
set.ignorecase = true
set.smartcase = true

-- Save / Swap / Undo ------------------
-- Leave buffers open in the background
set.hidden = true
-- Turn off swap and turn on undo history
set.swapfile = false
set.undofile = true

-- Tabs --------------------------------
set.shiftwidth = 2
set.softtabstop = 2
set.smartindent = true
set.expandtab = true

-- Window splits -----------------------
set.splitbelow = true
set.splitright = true

-- Completion --------------------------
set.completeopt = { 'menu,menuone,noselect' }

-- Bootstrap Lazy plugin manager -------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Remap leader ------------------------
require('rc.util').keymap('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load plugins ------------------------
require('lazy').setup('rc.plugins', { ui = { border = require('rc.util').float_win_style.border } })
