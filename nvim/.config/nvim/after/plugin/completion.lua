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
    { name = 'nvim_lsp_signature_help' },
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
local palette = require('catppuccin.palettes').get_palette()
if palette then
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
