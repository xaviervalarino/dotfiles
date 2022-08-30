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

catppuccin.setup {
  integrations = {
    navic = true,
  },
}

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
  NavicIconsFile = { bg = color.base },
  NavicIconsModule = { bg = color.base },
  NavicIconsNamespace = { bg = color.base },
  NavicIconsPackage = { bg = color.base },
  NavicIconsClass = { bg = color.base },
  NavicIconsMethod = { bg = color.base },
  NavicIconsProperty = { bg = color.base },
  NavicIconsField = { bg = color.base },
  NavicIconsConstructor = { bg = color.base },
  NavicIconsEnum = { bg = color.base },
  NavicIconsInterface = { bg = color.base },
  NavicIconsFunction = { bg = color.base },
  NavicIconsVariable = { bg = color.base },
  NavicIconsConstant = { bg = color.base },
  NavicIconsString = { bg = color.base },
  NavicIconsNumber = { bg = color.base },
  NavicIconsBoolean = { bg = color.base },
  NavicIconsArray = { bg = color.base },
  NavicIconsObject = { bg = color.base },
  NavicIconsKey = { bg = color.base },
  NavicIconsNull = { bg = color.base },
  NavicIconsEnumMember = { bg = color.base },
  NavicIconsStruct = { bg = color.base },
  NavicIconsEvent = { bg = color.base },
  NavicIconsOperator = { bg = color.base },
  NavicIconsTypeParameter = { bg = color.base },
  NavicText = { bg = color.base },
  NavicSeparator = { bg = color.base },
  }
  for name, override in pairs(hl_overrides) do
    local colors = vim.api.nvim_get_hl_by_name(name, true)
    vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', colors, override))
    -- swap the hightlight groups for DiagnosticVirtualText* and DiagnosticSign* 
    if name:find('DiagnosticVirtualText') then
      vim.api.nvim_set_hl(0, 'DiagnosticSign' .. name:match '.+(%u%l+)', colors)
    end
  end
end
