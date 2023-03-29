return {
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  name = 'catppuccin',
  config = function()
    local status_ok, catppuccin = pcall(require, 'catppuccin')
    if not status_ok then
      return
    end

    local palette
    if type(vim.env.TERM_COLORSCHEME) == 'string' then
      palette = vim.env.TERM_COLORSCHEME:match('-(%a+)'):lower()
    else
      -- default to dark
      palette = 'mocha'
    end

    local color = require('catppuccin.palettes').get_palette(palette)

    catppuccin.setup {
      flavour = palette,
      highlight_overrides = {
        all = {
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
          StatusLine = {
            fg = color.overlay2,
            bg = color.base,
          },
        },
      },
    }

    vim.cmd.colorscheme 'catppuccin'

    -- Use the diagnostic background color from DiagnosticVirtualText* for DiagnosticSign*
    for _, name in pairs {
      'DiagnosticVirtualTextError',
      'DiagnosticVirtualTextWarn',
      'DiagnosticVirtualTextInfo',
      'DiagnosticVirtualTextHint',
    } do
      local colors = vim.api.nvim_get_hl_by_name(name, true)
      local virtualtxt_colors = vim.tbl_extend('force', colors, { bg = 'bg', italic = false })
      local statusline_colors = vim.tbl_extend('force', colors, { italic = false })
      vim.api.nvim_set_hl(0, name, virtualtxt_colors)
      vim.api.nvim_set_hl(0, 'DiagnosticStatusLine' .. name:match '.+(%u%l+)', statusline_colors)
      vim.api.nvim_set_hl(0, 'DiagnosticSign' .. name:match '.+(%u%l+)', colors)
    end

    vim.api.nvim_set_hl(0, 'StatuslineMode', { bg = color.subtext0, fg = 'bg', bold = true })
  end,
}
