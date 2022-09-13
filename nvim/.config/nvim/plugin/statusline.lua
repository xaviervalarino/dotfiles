local s = require 'rc.statusline'

-- require('plenary.reload').reload_module('rc.statusline-new', true)
-- local c = require 'rc.statusline.components'

local api = vim.api
local fn = vim.fn
local function mode(add)
  local modes = setmetatable({
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
  local current = api.nvim_get_mode().mode
  add(modes[current][2]:upper() .. ' ')
end

local diagnostic_signs = require('rc.util').diagnostic_signs

local function diagnostics(add)
  for _, sign in ipairs(diagnostic_signs) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[sign.name:upper()] })
    if count > 0 then
      local hlgrp = 'DiagnosticStatusLine' .. sign.name
      local diagnostic = string.format(' %s%s ', sign.icon, count)
      add(diagnostic, hlgrp)
    end
  end
end

local function git_status(add)
  local git_items = {
    { name = 'head', symbol = '  ', hlgrp = 'Statusline' },
    { name = 'added', symbol = ' +', hlgrp = 'GitSignsAdd' },
    { name = 'changed', symbol = ' ~', hlgrp = 'GitSignsChange' },
    { name = 'removed', symbol = ' -', hlgrp = 'GitSignsDelete' },
  }
  local signs = vim.b.gitsigns_status_dict
  -- not a repo
  if not signs then
    return {}
  end
  for _, item in pairs(git_items) do
    local stat = signs[item.name]
    if stat then
      if type(stat) == 'number' and stat == 0 then
        return
      end
      add(item.symbol .. stat, item.hlgrp)
    end
  end
end

local function filepath(add)
  local modified = vim.bo.modified and ' [+]' or ''
  add(fn.expand('%') .. modified)
end

s.left.add('▎', 'Bold')
s.left.add(mode)
s.left.add(diagnostics)
s.left.add(git_status)
s.center.add('  ', 'Statusline')
s.center.add(filepath)
-- s.center.add({' %m'})

-- Dont show mode in command line
vim.o.showmode = false

-- initial
local sl = [[%{%luaeval("require'rc.statusline':create()")%}]]
vim.opt.statusline = sl

-- User event for "CmdlineEnterPre|CmdlineLeavePost" defined in cmdheight-zero.lua
vim.api.nvim_create_autocmd('User', {
  group = 'CmdlineStatus',
  pattern = { 'CmdlineEnterPre', 'CmdlineLeavePost' },
  callback = function(ctx)
    if ctx.match == 'CmdlineEnterPre' then
      local separator = string.rep(vim.opt.fillchars:get().horiz or '─', vim.o.columns)
      local win_split = string.format('%%#WinSeparator#%s', separator)
      vim.opt.laststatus = 0
      vim.opt.statusline = win_split
    else
      vim.opt.laststatus = 3
      vim.opt.statusline = sl
    end
  end,
})
