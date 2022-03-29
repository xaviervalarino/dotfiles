local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return false
end

local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local formatting = null_ls.builtins.formatting

local M = {}

function M.setup(opts)
  null_ls.setup({
    debug = true,
    on_attach = opts.on_attach,
    sources = {
      code_actions.xo,
      diagnostics.xo,
      formatting.prettier,
      -- null_ls.builtins.diagnostics.eslint_d,
      -- null_ls.builtins.code_actions.eslint_d,
      -- prettier_d_slim.with {
      --   extra_args = { '--single-quote', '--jsx-single-quote' }
      -- }
    },
  })
end

return M
