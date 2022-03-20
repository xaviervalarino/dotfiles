local status_ok, paq = pcall(require, 'paq')
if not status_ok then
  return
end

local cmd = vim.cmd

local function simple_setup(pkg_name)
  local pkg_status_ok, pkg = pcall(require, pkg_name)
  if pkg_status_ok then
    pkg.setup {}
  end
end

cmd [[
  augroup package_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PaqSync
  augroup end
]]

paq {
  'savq/paq-nvim';
  'nvim-lua/plenary.nvim';   -- dependency of git signs & telescope

  { 'windwp/nvim-autopairs', run = simple_setup 'nvim-autopairs' };
  'lewis6991/gitsigns.nvim';
  'tpope/vim-surround';
  'tpope/vim-fugitive';
  'lukas-reineke/indent-blankline.nvim';

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = function () cmd('TSUpdate') end };
  'nvim-treesitter/playground';
  'windwp/nvim-ts-autotag';

  -- lsp
  'neovim/nvim-lspconfig';
  'onsails/lspkind-nvim';
  'jose-elias-alvarez/null-ls.nvim';

  -- completion plugins
  'hrsh7th/nvim-cmp'; -- completion plugin
  'hrsh7th/cmp-buffer'; -- buffer completion
  'hrsh7th/cmp-path'; -- path completion
  'hrsh7th/cmp-cmdline'; -- cmdline completion
  'hrsh7th/cmp-nvim-lsp';
  'saadparwaiz1/cmp_luasnip'; -- snippet completion

  -- snippets
  'L3MON4D3/LuaSnip'; -- snippet engine
  'rafamadriz/friendly-snippets'; -- collection of snippets

  'nvim-telescope/telescope.nvim';

  -- theme
  'kyazdani42/nvim-web-devicons';
  { 'catppuccin/nvim', as = 'catppuccin' };
  'tjdevries/express_line.nvim';
  'j-hui/fidget.nvim';

  { 'folke/zen-mode.nvim', run = simple_setup 'zen-mode' };
  'ThePrimeagen/harpoon';
  { 'folke/which-key.nvim', run = simple_setup 'which-key' };
  { 'numToStr/Comment.nvim', run = simple_setup 'Comment' };
}
