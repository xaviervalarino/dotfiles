-- originally inspired by https://elianiva.my.id/post/neovim-lua-statusline
local M = {}
local fn = vim.fn
local api = vim.api

-- Dont show mode in command line
vim.o.showmode = false

local create_table = function (initial)
  return setmetatable(initial or {}, { __index = table })
end

local function escape_chars(string)
  return string:gsub('([%(|%)|%%|%.|%+|%-|%*|%[|%?|%^|%$])', '%%%1')
end

-- add color to the string segment and then reset back to the StatusLine hlGroup
local hl = setmetatable({}, {
  __index = function(t, hlgroup)
    return function(str, escaped)
      local template = '%%#%s#%s%%#%s#'
      if escaped then
        template = template:gsub('%%%%', '%%%%%%%%')
      end
      return string.format(template, hlgroup, str, 'StatusLine')
    end
  end,
})

M.trunc_width = setmetatable({
  mode = 80,
  git_status = 90,
  filename = 140,
  line_col = 60,
}, {
  __index = function()
    -- handle edge cases
    return 80
  end,
})

M.is_truncated = function(_, width)
  return vim.o.columns < width
end


local palette = require('catppuccin.palettes').get_palette()
if palette then
  api.nvim_set_hl(0, 'StatusLine', { fg = palette.overlay2, bg = palette.base })
  api.nvim_set_hl(0, 'StatusDark', { fg = palette.overlay2, bg = palette.base, bold = true })
end

M.modes = setmetatable({
  ['n'] = { 'Normal', 'N' },
  ['no'] = { 'N·Pending', 'N·P' },
  ['v'] = { 'Visual', 'V' },
  ['V'] = { 'V·Line', 'V·L' },
  [''] = { 'V·Block', 'V·B' },
  ['s'] = { 'Select', 'S' },
  ['S'] = { 'S·Line', 'S·L' },
  [''] = { 'S·Block', 'S·B' },
  ['i'] = { 'Insert', 'I' },
  ['ic'] = { 'Insert', 'I' },
  ['R'] = { 'Replace', 'R' },
  ['Rv'] = { 'V·Replace', 'V·R' },
  ['c'] = { 'Command', 'C' },
  ['cv'] = { 'Vim·Ex ', 'V·E' },
  ['ce'] = { 'Ex ', 'E' },
  ['r'] = { 'Prompt ', 'P' },
  ['rm'] = { 'More ', 'M' },
  ['r?'] = { 'Confirm ', 'C' },
  ['!'] = { 'Shell ', 'S' },
  ['t'] = { 'Terminal ', 'T' },
}, {
  __index = function()
    return { 'Unkown', 'U' }
  end,
})

M.mode = function(self)
  local current_mode = api.nvim_get_mode().mode

  -- if self:is_truncated(self.trunc_width.mode) then
  return string.format('%s', self.modes[current_mode][2]:upper())
  -- end

  -- return string.format(' %s ', self.modes[current_mode][1]):upper()
end

M.git_status = function(self)
  local git_status = {}
  -- fallback
  local signs = vim.b.gitsigns_status_dict
  -- not a repo
  if not signs then
    return ''
  end

  if self:is_truncated(self.trunc_width.git_status) then
    return string.format('  %s ', signs.head or '')
  end

  local git_items = {
    { text = (signs.head and ('  ' .. signs.head) or '') },
    { text = (signs.added and signs.added > 0) and ('+' .. signs.added) or '', hlGrp = 'GitSignsAdd' },
    { text = (signs.changed and signs.changed > 0) and ('~' .. signs.changed) or '', hlGrp = 'GitSignsChange' },
    { text = (signs.removed and signs.removed > 0) and ('-' .. signs.removed) or '', hlGrp = 'GitSignsDelete' },
  }
  for _, item in ipairs(git_items) do
    local string = item.text
    if item.hlGrp then
      string = hl[item.hlGrp](item.text)
    end
    table.insert(git_status, string)
  end

  return table.concat(git_status, ' ')
end

M.filepath = function(self)
  local path_stat = create_table()

  local f = {
    cwd = fn.getcwd(),
    path = fn.expand '%:p:h',
    head = fn.expand '%:h',
    filename = fn.expand '%:t',
  }

  local function short_home(path, prepend)
    prepend = prepend or ''
    return path:gsub('^' .. vim.env.HOME .. '/?', prepend)
  end

  local function path_back()
    local back_str = ''
    for _ in short_home(f.cwd):gmatch '[^/]+' do
      back_str = back_str .. '../'
    end
    return back_str
  end

  local function strip_extra_slash(path)
    local resolved = (#short_home(f.cwd) < #f.cwd) and short_home(path, '~/') or path
    return resolved:gsub('(//+)', '%/')
  end

  local function resolve(callback)
    local resolved, head

    -- filepath is in the current working directory
    if f.path:match('^' .. f.cwd) and not f.cwd:match '^/$' then
      resolved = short_home(f.path, '~/')
      head = short_home(f.head)
    else
      -- shorten path and head if CWD is in $HOME
      if #short_home(f.cwd) < #f.cwd then
        resolved = short_home(f.path) or f.path
        head = short_home(f.head)
      else
        resolved = f.path
        head = f.head
      end
      resolved = path_back() .. resolved
    end
    resolved = strip_extra_slash(resolved)
    return callback(resolved, head)
  end

  local function highlight(path, head)
    local at_head = #head == 0 or head:match '^%.$'
    local test = at_head and '$' or escape_chars(head)
    local replace = at_head and hl.Title('/', true) or hl.Title(head, true) .. '/'
    local highlighted = path:gsub(test, replace)
    return highlighted
  end

  path_stat:insert '  %<'
  path_stat:insert(resolve(highlight))
  path_stat:insert(hl.Comment(f.filename))
  -- readonly? 
  -- updated? 
  path_stat:insert ' %m'

  return path_stat:concat()
end

local diagnostic_signs = require('rc.util').diagnostic_signs

M.diagnostics = function(self)
  local result = create_table()
  for _, sign in ipairs(diagnostic_signs) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[sign.name:upper()] })
    if count > 0 then
      local hl_group = 'DiagnosticSign' .. sign.name
      local diagnostic = string.format(' %s%s ', sign.icon, count)
      result:insert(hl[hl_group](diagnostic))
    end
  end

  if self:is_truncated(self.trunc_width.diagnostic) then
    return ''
  else
    return result:concat()
  end
end

setmetatable(M, {
  __call = function(s, status)
    if status == 'inactive' then
      local separator = vim.opt.fillchars:get().horiz or '─'
      return '%#WinSeparator#' .. string.rep(separator, vim.fn.winwidth '.')
    end
    return table.concat({
      '%#StatusDark#▎',
      s:mode(),
      s:diagnostics(),
      s:git_status(),
      '%#StatusLine#',
      '%=',
      s:filepath(),
      '%=',
    }, ' ')
  end,
})

return M
