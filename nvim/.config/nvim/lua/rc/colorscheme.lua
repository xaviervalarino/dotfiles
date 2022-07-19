local catppuccin = require 'catppuccin'

local _, _, palette = vim.env.ITERM_PROFILE:find '-(%a+)'
for _, v in ipairs { 'latte', 'frappe', 'macchiato', 'mocha' } do
  if palette == v then
    vim.g.catppuccin_flavour = palette
  end
end

local color = require('catppuccin.palettes').get_palette()

catppuccin.setup {
  color_overrides = {
    CmpDocumentationBorder = {
      fg = color.sapphire,
    },
    CmpDocumentation = {
      fg = color.sapphire,
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
  },
}

vim.cmd [[colorscheme catppuccin]]
