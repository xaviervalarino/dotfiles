local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

---Setup package with default config
---@param pkg_name string plugin name supplied to `require`
local function simple_setup(pkg_name)
  if type(pkg_name) == 'string' then
    local pkg_status_ok, pkg = pcall(require, pkg_name)
    if pkg_status_ok then
      pkg.setup {}
    end
  end
end

local packer_group = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = 'plugins.lua',
})

local packages = {
  'wbthomason/packer.nvim',

  { 'windwp/nvim-autopairs', config = simple_setup 'nvim-autopairs' },
  { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } },
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'godlygeek/tabular',
  'lukas-reineke/indent-blankline.nvim',

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  { 'nvim-treesitter/nvim-treesitter-context', simple_setup 'treesitter-context' },
  'nvim-treesitter/playground',
  'windwp/nvim-ts-autotag',
  { 'lewis6991/spellsitter.nvim', config = simple_setup 'spellsitter' },

  -- lsp
  'neovim/nvim-lspconfig',
  'onsails/lspkind-nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'folke/lua-dev.nvim',
  { 'smjonas/inc-rename.nvim', config = simple_setup 'inc_rename' },

  -- completion plugins
  'hrsh7th/nvim-cmp', -- completion plugin
  'hrsh7th/cmp-buffer', -- buffer completion
  'hrsh7th/cmp-path', -- path completion
  'hrsh7th/cmp-cmdline', -- cmdline completion
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip', -- snippet completion
  'fladson/vim-kitty',

  -- snippets
  'L3MON4D3/LuaSnip', -- snippet engine
  'rafamadriz/friendly-snippets', -- collection of snippets

  { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },

  -- theme
  'kyazdani42/nvim-web-devicons',
  { 'catppuccin/nvim', as = 'catppuccin' },

  'j-hui/fidget.nvim',

  -- TODO: move this into it's own file?
  {
    'folke/zen-mode.nvim',
    config = require('zen-mode').setup {
      window = {
        backdrop = 1,
        width = 80,
      },
      -- TODO: I don't think this works
      plugins = {
        kitty = {
          enabled = true,
          font = '+4',
        },
      },
    },
  },
  'ThePrimeagen/harpoon',
  { 'folke/which-key.nvim', config = simple_setup 'which-key' },
  { 'numToStr/Comment.nvim', config = simple_setup 'Comment' },

  { 'Pocco81/AutoSave.nvim', config = simple_setup 'autosave' },
}

return require('packer').startup {
  function(use)
    for _, package in pairs(packages) do
      use(package)
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
