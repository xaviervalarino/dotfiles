local M = {}

-- Keymap convenience function -------------------------------------------------
local function split(str)
  if #str > 0 then
    return str:sub(1, 1), split(str:sub(2))
  end
end

---@class Keymap_helper
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

---@type Keymap_helper
M.keymap = setmetatable({
  defaults = { silent = true },
}, keymap_mt)

---@param bufnr integer buffer number
---@return Keymap_helper  -- keymap utility function scoped to `bufnr`
M.bufkeymap = function(bufnr)
  return setmetatable({
    defaults = {
      silent = true,
      buffer = bufnr,
    },
  }, keymap_mt)
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
