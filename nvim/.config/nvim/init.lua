local set = vim.opt
local window = vim.wo

set.termguicolors = true
set.linebreak = true
set.laststatus = 3

set.mouse = 'a'
set.spell = true

set.showbreak = '↪\\'
set.listchars:append {
  space = '·',
  tab = '→\\ ',
  eol = '¬',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}

-- Left column -------------------------
set.breakindent = true
set.relativenumber = true
set.number = true
window.signcolumn = 'yes'

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

-- Package Config --------------------
require 'rc.plugins'
require 'rc.completion'
require 'rc.snippets'
require 'rc.colorscheme'
require 'rc.git-signs'
require 'rc.indent-blankline'
require 'rc.language-server'
require 'rc.mappings'
require 'rc.treesitter'
require 'rc.statusline'
