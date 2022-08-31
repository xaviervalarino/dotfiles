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

-- Diagnostic icons ------------------------------------------------------------
M.diagnostic_signs = {
  { name = 'Error', icon = ' ' },
  { name = 'Warn', icon = ' ' },
  { name = 'Info', icon = ' ' },
  { name = 'Hint', icon = ' ' },
}

-- Cmdheight=0 expression fix --------------------------------------------------
M.run_cmd = function(keys)
  local keys = vim.api.nvim_replace_termcodes(':'.. keys, true, false, true)
  vim.api.nvim_exec_autocmds('User', { pattern = 'CmdlineEnterPre', group = 'CmdlineStatus' })
  vim.api.nvim_feedkeys(keys, mode or 'n', false)
end
--------------------------------------------------------------------------------

return M
