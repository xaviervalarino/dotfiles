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

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('packer_user_config', { clear = true }),
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerInstall',
})

return require('packer').startup {
  function(use, use_rocks)
    use 'wbthomason/packer.nvim'

    use { 'windwp/nvim-autopairs', config = simple_setup 'nvim-autopairs' }
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'kylechui/nvim-surround', config = simple_setup 'nvim-surround' }
    use 'tpope/vim-repeat'
    use 'tpope/vim-fugitive'
    use 'godlygeek/tabular'
    use 'lukas-reineke/indent-blankline.nvim'

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    use 'windwp/nvim-ts-autotag'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('treesitter-context').setup {
          separator = '─',
        }
      end,
    }

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind-nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'folke/neodev.nvim'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'
    use { 'smjonas/inc-rename.nvim', config = simple_setup 'inc_rename' }

    -- completion plugins
    use 'hrsh7th/nvim-cmp' -- completion plugin
    use 'hrsh7th/cmp-buffer' -- buffer completion
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-path' -- path completion
    use 'hrsh7th/cmp-cmdline' -- cmdline completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip' -- snippet completion
    use 'fladson/vim-kitty'

    -- snippets
    use 'L3MON4D3/LuaSnip' -- snippet engine
    use 'rafamadriz/friendly-snippets' -- collection of snippets

    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'nvim-telescope/telescope-file-browser.nvim'

    -- theme
    use 'kyazdani42/nvim-web-devicons'
    use { 'catppuccin/nvim', as = 'catppuccin' }

    use {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup { text = { spinner = 'dots' } }
      end,
    }

    use 'folke/zen-mode.nvim'
    use 'ThePrimeagen/harpoon'

    use 'folke/which-key.nvim'

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    }
    use 'norcalli/nvim-colorizer.lua'
    use 'gpanders/editorconfig.nvim'
    use {
      'AckslD/messages.nvim',
      config = simple_setup 'messages',
    }
    use {
      'tiagovla/scope.nvim',
      config = simple_setup 'scope',
    }
    use {
      'goolord/alpha-nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('alpha').setup(require('alpha.themes.startify').config)
      end,
    }
    use 'lewis6991/impatient.nvim'
    use_rocks 'luautf8'
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float(require('rc.util').float_win_style)
      end,
    },
    luarocks = {
      python_cmd = 'python3',
    },
  },
}
