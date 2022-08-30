local catppuccin = require 'catppuccin'

local palette
if type(vim.env.TERM_COLORSCHEME) == 'string' then
  palette = vim.env.TERM_COLORSCHEME:match('-(%a+)'):lower()
else
  -- default to dark
  palette = 'mocha'
end

for _, v in ipairs { 'latte', 'frappe', 'macchiato', 'mocha' } do
  if palette == v then
    vim.g.catppuccin_flavour = palette
  end
end

vim.cmd [[colorscheme catppuccin]]

local color = require('catppuccin.palettes').get_palette()

if color then
  local hl_overrides = {
    DiagnosticVirtualTextError = {
      bg = color.base,
    },
    DiagnosticVirtualTextWarn = {
      bg = color.base,
    },
    DiagnosticVirtualTextInfo = {
      bg = color.base,
    },
    DiagnosticVirtualTextHint = {
      bg = color.base,
    },
    FloatBorder = {
      fg = color.sapphire,
      bg = color.base,
    },
    FloatShadow = {
      bg = color.base,
    },
    FloatShadowThrough = {
      bg = color.base,
    },
    NormalFloat = {
      bg = color.base,
    },
    MsgArea = {
      fg = color.text,
      bg = color.mantle,
    },
  }
  for name, override in pairs(hl_overrides) do
    local colors = vim.api.nvim_get_hl_by_name(name, true)
    vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', colors, override))
  end
end
