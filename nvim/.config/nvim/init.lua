local set = vim.opt
local global = vim.g
local window = vim.wo
local cmd = vim.cmd

set.termguicolors = true
set.linebreak = true

set.mouse = 'a'

-- Left column -------------------------
set.breakindent = true
set.relativenumber = true
set.number = true
window.signcolumn = 'yes'


-- Search ------------------------------
set.ignorecase = true
set.smartcase = true
-- Show partial off-screen results in preview window for :substitute
set.inccommand = 'split'


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
global.completeopt = 'menu,menuone,noselect'


-- Package Config --------------------
require 'rc.plugins'
require 'rc.completion'
require 'rc.colorscheme'
require 'rc.git-signs'
require 'rc.indent-blankline'
require 'rc.language-server'
require 'rc.mappings'
require 'rc.treesitter'
