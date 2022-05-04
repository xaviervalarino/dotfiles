if vim.env.ITERM_PROFILE == 'Github light' then
  require('github-theme').setup {
    theme_style = 'light',
  }
else
  -- profile == 'Catppuccin' (probably)
  vim.cmd [[colorscheme catppuccin]]
end

local noescroll_ok, neoscroll = pcall(require, 'neoscroll')
if not noescroll_ok then
  return
end

neoscroll.setup {
  easing_function = 'cubic',
}
