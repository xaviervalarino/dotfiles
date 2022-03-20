local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then return end

local lspkind_ok, lspkind = pcall(require, 'lspkind')
if not lspkind_ok then return end

cmp.setup{
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'npm' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 4 },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      menu = {
        nvim_lsp = '[LSP]',
        nvim_lua = '[api]',
        buffer = '[buf]',
        npm = '[npm]',
        luasnip = '[snip]',
        path = '[path]',
      }
    })
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  experimental = {
    ghost_text = true
  },
}
