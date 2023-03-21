local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return false
end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local M = {}

function M.setup(opts)
  null_ls.setup {
    debug = true,
    on_attach = opts.on_attach,
    sources = {
      diagnostics.shellcheck,
      formatting.stylua,
      formatting.prettier.with {
        extra_args = { '--print-width', '100' },
      },
    },
  }
end

return M
