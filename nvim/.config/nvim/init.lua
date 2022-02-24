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


-- Packages ----------------------------
require 'paq' {
  'savq/paq-nvim';
  'nvim-lua/plenary.nvim';   -- dependency of git signs & telescope
  { 'windwp/nvim-autopairs', run = function() require 'nvim-autopairs'.setup {} end };
  'lewis6991/gitsigns.nvim';
  'tpope/vim-surround';
  'tpope/vim-fugitive';
  'lukas-reineke/indent-blankline.nvim';
  { 'nvim-treesitter/nvim-treesitter', run = function() cmd('TSUpdate') end };
  'nvim-treesitter/playground';
  'windwp/nvim-ts-autotag';
  'nvim-telescope/telescope.nvim';
  'neovim/nvim-lspconfig';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline';
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-vsnip';
  'onsails/lspkind-nvim';
  'hrsh7th/vim-vsnip';
  'kyazdani42/nvim-web-devicons';
  'folke/tokyonight.nvim';
  { 'folke/zen-mode.nvim', run = function() require'zenmode'.setup {} end };
  'rafamadriz/friendly-snippets';
  'ThePrimeagen/harpoon';
  { 'folke/which-key.nvim', run = function() require'which-key'.setup {} end };
  { 'numToStr/Comment.nvim', run = function() require'Comment'.setup {} end };
}

-- Package Config --------------------

require 'rc.completion'
require 'rc.colorscheme'
require 'rc.git-signs'
require 'rc.indent-blankline'
require 'rc.language-server'
require 'rc.mappings'
require 'rc.treesitter'
