local catppuccin = require 'catppuccin'
local colors = require('catppuccin.api.colors').get_colors()

local _, _, color = vim.env.ITERM_PROFILE:find '-(%a+)'
for _, v in ipairs { 'latte', 'frappe', 'macchiato', 'mocha' } do
  if color == v then
    vim.g.catppuccin_flavour = color
  end
end

catppuccin.remap {
  FloatBorder = {
    fg = colors.sapphire,
    bg = colors.base,
  },
  FloatShadow = {
    bg = colors.base,
  },
  FloatShadowThrough = {
    bg = colors.base,
  },
  NormalFloat = {
    bg = colors.base,
  },
}

vim.cmd [[colorscheme catppuccin]]
