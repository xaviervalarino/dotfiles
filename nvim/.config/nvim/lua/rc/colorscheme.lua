if vim.env.ITERM_PROFILE == 'Github light' then
  require('github-theme').setup{
    theme_style = 'light',
  }
else
  -- profile == 'Catppuccin' (probably)
  vim.cmd[[colorscheme catppuccin]]
end
