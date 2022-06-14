local catppuccin = require 'catppuccin'

local _, _, palette = vim.env.ITERM_PROFILE:find '-(%a+)'
for _, v in ipairs { 'latte', 'frappe', 'macchiato', 'mocha' } do
  if palette == v then
    vim.g.catppuccin_flavour = palette
  end
end

local color = require('catppuccin.api.colors').get_colors()

catppuccin.remap {
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
  TelescopeNormal = {
    bg = color.surface0,
  },
  TelescopeBorder = {
    fg = color.surface0,
    bg = color.surface0,
  },
  TelescopeSelection = {
    bg = color.surface1,
  },
  TelescopePromptNormal = {
    bg = color.subtext0,
    fg = color.crust,
  },
  TelescopePromptBorder = {
    fg = color.subtext0,
    bg = color.subtext0,
  },
  TelescopeTitle = {
    fg = color.crust,
    bg = color.sapphire,
  },
  -- Hide results title
  TelescopeResultsTitle = {
    fg = color.surface0,
    bg = color.surface0,
  },
  -- unused highlight groups
  -- TelescopePromptTitle
  --TelescopePreviewTitle
}

vim.cmd [[colorscheme catppuccin]]
