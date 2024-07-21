return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'
      configs.setup {
        ensure_installed = 'all',
        sync_install = false,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      }
    end,
  },
  {
    'echasnovski/mini.diff',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      local diff = require 'mini.diff'
      diff.setup {
        view = { style = 'sign' },
      }
      vim.keymap.set('n', '<leader>gh', diff.toggle_overlay, { desc = 'Toggle [G]it [H]unks' })
    end,
  },
  {
    'echasnovski/mini.ai',
    version = false,
    config = function()
      require('mini.ai').setup()
    end,
  },
  {
    'echasnovski/mini-git',
    enabled = not vim.g.vscode,
    version = false,
    main = 'mini.git',
    config = function()
      require('mini.git').setup()
    end,
  },

  {
    'echasnovski/mini.animate',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { 'Up', 'Down' } do
        local key = '<ScrollWheel' .. scroll .. '>'
        vim.keymap.set({ '', 'i' }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require 'mini.animate'
      animate.setup {
        cursor = { enable = false },
        resize = {
          timing = animate.gen_timing.linear { duration = 50, unit = 'total' },
        },
        scroll = {
          timing = animate.gen_timing.linear { duration = 150, unit = 'total' },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
      }
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    enabled = not vim.g.vscode,
    dependencies = { 'echasnovski/mini.icons' },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'echasnovski/mini.clue',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      local miniclue = require 'mini.clue'
      miniclue.setup {
        window = {
          config = {
            width = 60,
          },
        },
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup {}
    end,
  },
  {

    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup {
        n_lines = 200,
      }
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    enabled = not vim.g.vscode,
    config = function()
      require('mini.indentscope').setup {
        draw = {
          delay = 0,
          animation = function()
            return 0
          end,
        },
        symbol = '│',
      }
    end,
  },
  {
    'rose-pine/neovim',
    enabled = not vim.g.vscode,
    config = function()
      require('rose-pine').setup {}
      -- vim.cmd 'colorscheme rose-pine'
      -- vim.cmd 'colorscheme rose-pine-moon'
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre ' },
    enabled = not vim.g.vscode,
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup {
        format_on_save = {
          timeout_ms = 500,
          lsp_format = 'fallback',
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { { 'prettierd', 'prettier' } },
          javascriptreact = { { 'prettierd', 'prettier' } },
          typescript = { { 'prettierd', 'prettier' } },
          typescriptreact = { { 'prettierd', 'prettier' } },
          vue = { { 'prettierd', 'prettier' } },
          css = { { 'prettierd', 'prettier' } },
          scss = { { 'prettierd', 'prettier' } },
          less = { { 'prettierd', 'prettier' } },
          html = { { 'prettierd', 'prettier' } },
          json = { { 'prettierd', 'prettier' } },
          jsonc = { { 'prettierd', 'prettier' } },
          yaml = { { 'prettierd', 'prettier' } },
        },
      }
    end,
  },
}
