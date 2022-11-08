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

M.border = {
  border = 'rounded',
}

-- Cmdheight=0 expression fix --------------------------------------------------

--- Run a <command> expression through feedkeys
---Fix for cmdheight=0
---@param keys string keys to be typed as a command
---@param mode? string  Feedkeys mode to use, defaults to 'n' -> Do not remap keys
M.run_cmd = function(keys, mode)
  local keys = vim.api.nvim_replace_termcodes(':' .. keys, true, false, true)
  vim.api.nvim_exec_autocmds('User', { pattern = 'CmdlineEnterPre', group = 'CmdlineStatus' })
  vim.api.nvim_feedkeys(keys, mode or 'n', false)
end
--------------------------------------------------------------------------------

return M
