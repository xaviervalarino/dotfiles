-- Treesitter

-- speed up loading of ts_context_commentstring
vim.g.skip_ts_context_commentstring_module = true

return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    opts = {
      separator = '─',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        ensure_installed = {
          'bash',
          'css',
          'html',
          'javascript',
          'json',
          'lua',
          'svelte',
          'tsx',
          'typescript',
          'sql',
          'yaml',
        },
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            floating_preview_opts = require('rc.util').float_win_style,
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
      }
    end,
  },
}
