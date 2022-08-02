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
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'npm' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 4 },
  },
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
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<Tab>'] = cmp.mapping.confirm { select = true },
    ['<S-Tab>'] = cmp.mapping.confirm { select = true },
    cmp.setup.cmdline('/', { sources = { name = 'buffer' } }),
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
