local M, keymap, mt = {}, {}, {}

local function split(str)
  if #str > 0 then
    return str:sub(1, 1), split(str:sub(2))
  end
end

-- metatable is used to create and initialize mode-specific keymaps
function mt:__call(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- returns mode-specific keymap, eg. nmap, vmap, inmap
-- see :h map-mode
function mt:__index(key)
  if key:find '[n|v|s|x|o|m|i|l|c|t]' or key == '' then
    local mode = { split(key) }
    return function(lhs, rhs, opts)
      keymap(mode, lhs, rhs, opts)
    end
  end
end

setmetatable(keymap, mt)

function M.create_keymaps(...)
  local keymaps = {}
  for _, mode in ipairs { ... } do
    table.insert(keymaps, keymap[mode])
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
