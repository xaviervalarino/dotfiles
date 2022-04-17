local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  Packer_bootstrap = vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
end

local function simple_setup(pkg_name)
  local pkg_status_ok, pkg = pcall(require, pkg_name)
  if pkg_status_ok then
    pkg.setup {}
  end
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local packages = {
  'wbthomason/packer.nvim',

  { 'windwp/nvim-autopairs', run = simple_setup 'nvim-autopairs' },
  { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } },
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'godlygeek/tabular',
  'lukas-reineke/indent-blankline.nvim',

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/playground',
  'windwp/nvim-ts-autotag',
  { 'lewis6991/spellsitter.nvim', config = simple_setup 'spellsitter' },

  -- lsp
  'neovim/nvim-lspconfig',
  'onsails/lspkind-nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'folke/lua-dev.nvim',

  -- completion plugins
  'hrsh7th/nvim-cmp', -- completion plugin
  'hrsh7th/cmp-buffer', -- buffer completion
  'hrsh7th/cmp-path', -- path completion
  'hrsh7th/cmp-cmdline', -- cmdline completion
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip', -- snippet completion

  -- snippets
  'L3MON4D3/LuaSnip', -- snippet engine
  'rafamadriz/friendly-snippets', -- collection of snippets

  { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' },

  -- theme
  'kyazdani42/nvim-web-devicons',
  { 'catppuccin/nvim', as = 'catppuccin' },
  'projekt0n/github-nvim-theme',
  'tjdevries/express_line.nvim',

  'j-hui/fidget.nvim',
  { 'folke/zen-mode.nvim', run = simple_setup 'zen-mode' },
  'ThePrimeagen/harpoon',
  -- { 'folke/which-key.nvim', run = simple_setup 'which-key' },
  -- tracking PR https://github.com/folke/which-key.nvim/pull/253
  { 'xiyaowong/which-key.nvim', run = simple_setup 'which-key' },
  { 'numToStr/Comment.nvim', run = simple_setup 'Comment' },
}

return require('packer').startup {
  function(use)
    for _, package in pairs(packages) do
      use(package)
    end

    if Packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'single' }
      end,
    },
  },
}
