local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

local map = require('rc.util').keymap

require('luasnip.loaders.from_vscode').lazy_load()

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_next_item()
  elseif luasnip and luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    cmp.complete()
  end
  return ''
end
_G.s_tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip and luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
  return ''
end

map('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
map('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
map('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
map('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
map('i', '<C-E>', '<Plug>luasnip-next-choice')
map('s', '<C-E>', '<Plug>luasnip-next-choice')
