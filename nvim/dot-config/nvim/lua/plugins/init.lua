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
      vim.keymap.set('n', 'dh', diff.toggle_overlay, { desc = 'Toggle [d]iff [h]unks' })
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
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          typescript = { 'prettierd', 'prettier', stop_after_first = true },
          typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          vue = { 'prettierd', 'prettier', stop_after_first = true },
          css = { 'prettierd', 'prettier', stop_after_first = true },
          scss = { 'prettierd', 'prettier', stop_after_first = true },
          less = { 'prettierd', 'prettier', stop_after_first = true },
          html = { 'prettierd', 'prettier', stop_after_first = true },
          json = { 'prettierd', 'prettier', stop_after_first = true },
          jsonc = { 'prettierd', 'prettier', stop_after_first = true },
          yaml = { 'prettierd', 'prettier', stop_after_first = true },
        },
      }
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    enabled = not vim.g.vscode,
    config = function()
      local harpoon = require 'harpoon'

      harpoon.setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: [a]dd file to list' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: show list' })
      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to to 1st item' })
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to to 2nd item' })
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to to 3rd item' })
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to to 4th item' })
      vim.keymap.set('n', '<leader>p', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: go to [p]rev file' })
      vim.keymap.set('n', '<leader>n', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: go to [n]ext file' })
    end,
  },
  {
    'gbprod/yanky.nvim',
    enabled = not vim.g.vscode,
    config = function()
      require('yanky').setup {
        highlight = {
          timer = 100,
        },
      }

      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

      vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
      vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    enabled = not vim.g.vscode,
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
  {
    'echasnovski/mini.comment',
    version = false,
    config = function()
      require('mini.comment').setup {
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }
    end,
  },
  'folke/twilight.nvim',
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = { backdrop = 0.7 },
      plugins = {},
    },
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
      }
    end,
  },
  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('aerial').setup {
        layout = {
          width = 0.2,
          default_direction = 'prefer_left',
        },
        attach_mode = 'global',
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      }
      vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { desc = 'Open Code Outline' })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'javascriptreact', 'typescriptreact' },
    config = function()
      require('nvim-ts-autotag').setup {}
    end,
  },
}
