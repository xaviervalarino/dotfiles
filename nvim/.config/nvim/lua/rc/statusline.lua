local utf8 = require 'lua-utf8'

local M = {}

local function get_padding(left, center, right)
  local col = vim.o.columns
  local padding = col - left - center - right
  local pad_left = math.floor(col / 2) - left - math.floor(center / 2)
  local pad_right = padding - pad_left
  return pad_left, pad_right
end

local function section()
  local _data = {}
  return {
    ---@param input string|function, Text to insert into this statusline section or a function that returns these parameters
    ---@param hlgrp? string highlight group to use on this text 
    add = function(input, hlgrp)
      local component = type(input) == 'function' and input or { input, hlgrp }
      table.insert(_data, component)
    end,
    create = function()
      local this_section, components = {}, {}
      local function add(str, hlgrp)
        table.insert(components, { str, hlgrp })
      end
      for _, component in ipairs(_data) do
        if type(component) == 'function' then
          component(add)
        else
          add(unpack(component))
        end
      end
      this_section.str = vim.fn.reduce(components, function(acc, v)
        local value, hlgrp = unpack(v)
        local highlight = hlgrp and string.format('%%#%s#', hlgrp) or ''
        return acc .. highlight .. value
      end, '')
      this_section.length = vim.fn.reduce(components, function(acc, v)
        return acc + utf8.len(v[1])
      end, 0)
      return this_section
    end,
  }
end

M.sections = {
  section(),
  section(),
  section(),
}
M.left = M.sections[1]
M.center = M.sections[2]
M.right = M.sections[3]

M.create = function(self)
  local lengths = {}
  local result = {}
  for _, this_section in ipairs(self.sections) do
    local t = this_section.create()
    table.insert(lengths, t.length)
    table.insert(result, t.str)
  end
  local pad_left, pad_right = get_padding(unpack(lengths))
  return table.concat {
    result[1],
    string.rep(' ', pad_left),
    result[2],
    string.rep(' ', pad_right),
    result[3],
  }
end

return M
