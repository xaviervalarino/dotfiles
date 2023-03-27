local M = {}

-- Keymap convenience function -------------------------------------------------
local function split(str)
  if #str > 0 then
    return str:sub(1, 1), split(str:sub(2))
  end
end

local keymap_mt = {
  __call = function(t, lhs, rhs, opts)
    opts = vim.tbl_extend('force', t.defaults, opts or {})
    vim.keymap.set('', lhs, rhs, opts)
  end,
  __index = function(t, key)
    if key:find '[n|v|s|x|o|m|i|l|c|t]' then
      return function(lhs, rhs, opts)
        local mode = { split(key) }
        opts = vim.tbl_extend('force', t.defaults, opts or {})
        vim.keymap.set(mode, lhs, rhs, opts)
      end
    end
  end,
}

M.keymap = setmetatable({
  defaults = { silent = true },
}, keymap_mt)

M.bufkeymap = function(bufnr)
  return setmetatable({
    defaults = {
      silent = true,
      buffer = bufnr,
    },
  }, keymap_mt)
end

-- UI elements and styling -----------------------------------------------------
M.diagnostic_signs = {
  { name = 'Error', icon = ' ' },
  { name = 'Warn', icon = ' ' },
  { name = 'Info', icon = ' ' },
  { name = 'Hint', icon = ' ' },
}

M.float_win_style = {
  border = 'rounded',
}

return M
