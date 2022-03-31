local M, mt = {}, {}

local function split(str)
  if #str > 0 then
    return str:sub(1, 1), split(str:sub(2))
  end
end

local function keymap(mode, lhs, rhs, opts)
  local options = vim.tbl_extend('keep', opts or {}, { silent = true })
  vim.keymap.set(mode, lhs, rhs, options)
end

-- add metatable function for creating mode specific keymaps
function mt:__index(key)
  if key:find 'map$' then
    local mode = { split(key:gsub('map', '')) }
    return function(lhs, rhs, opts)
      keymap(mode, lhs, rhs, opts)
    end
  end
end

setmetatable(M, mt)

function M.create_keymaps(...)
  local keymaps = {}
  for _, mode in ipairs { ... } do
    table.insert(keymaps, M[mode .. 'map'])
  end
  return unpack(keymaps)
end

function M.buf_create_keymaps(...)
  local mode_maps = { M.create_keymaps(...) }
  return function(bufnr)
    local buf_maps = {}
    for _, mode_map in ipairs(mode_maps) do
      table.insert(buf_maps, function(...)
        local args = { ... }
        args[3] = args[3] or {}
        args[3].buffer = bufnr
        mode_map(unpack(args))
      end)
    end
    return unpack(buf_maps)
  end
end

return M
