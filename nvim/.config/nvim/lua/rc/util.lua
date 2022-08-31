local M = {}

-- Keymap convenience function -------------------------------------------------
local function split(str)
  if #str > 0 then
    return str:sub(1, 1), split(str:sub(2))
  end
end

M.keymap = function(bufnr)
  local defaults = {
    silent = true,
    buffer = bufnr or nil,
  }
  return setmetatable({}, {
    __call = function(_, lhs, rhs, opts)
      opts = vim.tbl_extend('force', defaults, opts or {})
      vim.keymap.set('', lhs, rhs, opts)
    end,
    __index = function(_, key)
      return function(lhs, rhs, opts)
        if key:find '[n|v|s|x|o|m|i|l|c|t]' then
          local mode = { split(key) }
          opts = vim.tbl_extend('force', defaults, opts or {})
          vim.keymap.set(mode, lhs, rhs, opts)
        end
      end
    end,
  })
end

-- Diagnostic icons ----------------------------------------------------------------
M.diagnostic_signs = {
  { name = 'Error', icon = ' ' },
  { name = 'Warn', icon = ' ' },
  { name = 'Info', icon = ' ' },
  { name = 'Hint', icon = ' ' },
}

-----------------------------------------------------------------------------------

return M
