local _, _, color = vim.env.ITERM_PROFILE:find '-(%a+)'
for _, v in ipairs { 'latte', 'frappe', 'macchiato', 'mocha' } do
  if color == v then
    vim.g.catppuccin_flavour = color
  end
end

vim.cmd [[colorscheme catppuccin]]
