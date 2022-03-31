local M = {}

function M.keymap(mode, lhs, rhs, opts)
  local options = vim.tbl_extend('keep', opts or {}, {
    noremap = true,
    silent = true,
  })
  vim.keymap.set(mode, lhs, rhs, options)
end

-- return a keymap for a specific buffer
function M.create_buf_keymap(bufnr)
  return function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    M.keymap(mode, lhs, rhs, opts)
  end
end

return M
