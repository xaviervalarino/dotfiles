-- completion plugins
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer', -- buffer completion
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-path', -- path completion
    'hrsh7th/cmp-cmdline', -- cmdline completion
    {
      'L3MON4D3/LuaSnip', -- snippet engine
      dependencies = 'rafamadriz/friendly-snippets', -- collection of snippets
    },
    'saadparwaiz1/cmp_luasnip', -- snippet completion
    'fladson/vim-kitty',
  },
  config = function()
    local cmp_ok, cmp = pcall(require, 'cmp')
    if not cmp_ok then
      return
    end

    local lspkind_ok, lspkind = pcall(require, 'lspkind')
    if not lspkind_ok then
      return
    end

    local menu_style = cmp.config.window.bordered()
    menu_style.winhighlight = menu_style.winhighlight:gsub('(FloatBorder:)Normal', '%1FloatBorder')

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = menu_style,
        documentation = menu_style,
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
      }, {
        { name = 'path' },
        { name = 'buffer', keyword_length = 4 },
      }),
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text',
          menu = {
            nvim_lsp = '[LSP]',
            nvim_lua = '[api]',
            buffer = '[buf]',
            luasnip = '[snip]',
            path = '[path]',
          },
        },
      },
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.confirm { select = true },
        ['<Enter>'] = cmp.mapping.abort(),
      },
      experimental = {
        ghost_text = true,
      },
    }

    cmp.setup.filetype({ 'markdown', 'gitcommit' }, {
      view = {
        entries = { name = 'wildmenu', separator = ' | ' },
      },
    })
    -- Fix WildMenu controlled by CMP
    -- Match color to StatusLine
    local cat_palette_ok, cat_palette = pcall(require, 'catppuccin.palettes')
    if cat_palette_ok then
      local palette = cat_palette.get_palette()
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = palette.crust })
    end

    --TODO
    --cmp.setup.cmdline('/', { sources = { name = 'buffer' } })
    -- cmp.setup.cmdline(':', {
    --   sources = cmp.config.sources {
    --     { name = 'path' },
    --     { name = 'cmdline' },
    --   },
    -- })

    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

    -- snippets
    local luasnip = require 'luasnip'
    local map = require('rc.util').keymap

    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').lazy_load()

    luasnip.config.set_config {
      history = true,
      updateevents = 'TextChanged,TextChangedI',
      -- delete_check_events = 'TextChanged, InsertEnter',
      enable_autosnippets = true,
      ext_opts = {
        [require('luasnip.util.types').choiceNode] = {
          -- passive = { virt_text = { { '●', 'Comment' } } },
          active = { virt_text = { { '●', 'DiagnosticHint' } } },
        },
      },
    }

    map.is('<C-k>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end)
    map.is('<C-j>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end)
    map.is('<C-l>', function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end)
  end,
}
