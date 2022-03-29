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

-- compose specific values from two tables
-- composer is a table of keys you want to combine from the two tables
-- and the values are a set of callbacks that return the composed values
function M.compose_values(t1, t2, composer)
  local composed = {}
  for k, v in pairs(composer) do
    if t1[k] and t2[k] then
      print('composing', k)
      composed[k] = v(t1, t2)
    end
  end
  return composed
end

return M
