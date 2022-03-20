local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then return false end

null_ls.setup {
  debug = true,
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    -- null_ls.builtins.formatting.prettier.with {
    null_ls.builtins.formatting.prettier_d_slim.with {
      extra_args = { '--single-quote', '--jsx-single-quote' }
    }
  }
}
