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
  { name = 'Error', icon = ' ' },
  { name = 'Warn', icon = ' ' },
  { name = 'Info', icon = ' ' },
  { name = 'Hint', icon = '󰌵 ' },
}

M.float_win_style = {
  border = 'rounded',
}

-- Get the string length of special utf8 characters ----------------------------
function M.utf8_len(str)
  local len = 0
  local currentIndex = 1

  while currentIndex <= #str do
    local byte = string.byte(str, currentIndex)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
      byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
      byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF4 then
      byteCount = 4
    end

    currentIndex = currentIndex + byteCount
    len = len + 1
  end

  return len
end

function M.base64_enc(data)
  local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return (
    (data:gsub('.', function(x)
      local r, b = '', x:byte()
      for i = 8, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
      end
      return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
      if #x < 6 then
        return ''
      end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
      end
      return b:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1]
  )
end

return M
