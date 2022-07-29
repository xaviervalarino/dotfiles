-- Pulled heavily from: https://elianiva.my.id/post/neovim-lua-statusline

Statusline = {}
local fn = vim.fn
local api = vim.api

-- Dont show mode in command line
vim.o.showmode = false

Statusline.trunc_width = setmetatable({
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

Statusline.is_truncated = function(_, width)
  local current_width = api.nvim_win_get_width(0)
  return current_width < width
end

local function color(hlgroup, str)
  return string.format('%%#%s#%s%%#%s#', hlgroup, str, 'StatusLine')
end

local palette = require('catppuccin.palettes').get_palette()
api.nvim_set_hl(0, 'DarkFg', { fg = palette.crust, bg = palette.base })
api.nvim_set_hl(0, 'StatusERROR', { fg = palette.crust, bg = palette.red })
api.nvim_set_hl(0, 'StatusWARN', { fg = palette.crust, bg = palette.yellow })
api.nvim_set_hl(0, 'StatusINFO', { fg = palette.crust, bg = palette.sky })
api.nvim_set_hl(0, 'StatusHINT', { fg = palette.crust, bg = palette.teal })
api.nvim_set_hl(0, 'StatusLine', { fg = palette.text, bg = palette.crust })

Statusline.separator = { start = color('DarkFg', ''), close = color('DarkFg', '') }

Statusline.modes = setmetatable({
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

Statusline.mode = function(self)
  local current_mode = api.nvim_get_mode().mode

  if self:is_truncated(self.trunc_width.mode) then
    return string.format(' %s ', self.modes[current_mode][2]:upper())
  end

  return string.format(' %s ', self.modes[current_mode][1]):upper()
end

Statusline.git_status = function(self)
  -- fallback
  local signs = vim.b.gitsigns_status_dict or { head = '', added = 0, changed = 0, removed = 0 }
  local is_head_empty = signs.head ~= ''

  if self:is_truncated(self.trunc_width.git_status) then
    return is_head_empty and string.format('  %s ', signs.head or '') or ''
  end

  return is_head_empty
      and string.format('  %s | +%s ~%s -%s ', signs.head, signs.added, signs.changed, signs.removed)
    or ''
end

Statusline.filename = function(self)
  if self:is_truncated(self.trunc_width.filename) then
    --   return ' %<%f '
    return fn.pathshorten(fn.expand '%:f')
  end
  return ' %<%f '
end

Statusline.filetype = function(self)
  local file_name, file_ext = fn.expand '%:t', fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype

  if filetype == '' then
    return ''
  end
  return string.format(' %s %s ', filetype, icon)
end

Statusline.line_col = function(self)
  if self:is_truncated(self.trunc_width.line_col) then
    return ' %l:%c '
  end
  return ' Ln %l, Col %c '
end

-- TODO: pull icons from a central module to use across config files
Statusline.diagnostics = function(self)
  local result = {}
  local severity = { 'ERROR', 'WARN', 'INFO', 'HINT' }
  local icon = {
    error = ' ',
    warn = ' ',
    info = ' ',
    hint = ' ',
  }
  for _, level in ipairs(severity) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    if count > 0 then
      table.insert(result, color('Status' .. level, string.format(' %s%s ', icon[level:lower()], count)))
    end
  end

  if self:is_truncated(self.trunc_width.diagnostic) then
    return ''
  else
    return table.concat(result)
  end
end

setmetatable(Statusline, {
  __call = function(s)
    return table.concat {
      s.separator.start,
      s:mode(),
      s:diagnostics(),
      s:git_status(),
      '%=',
      s:filename(),
      '%=',
      s:filetype(),
      s:line_col(),
      s.separator.close,
    }
  end,
})

vim.o.statusline = '%!luaeval("Statusline()")'
