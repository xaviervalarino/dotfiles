local signs = {
  { name = 'Error', icon = '' },
  { name = 'Warn', icon = ' ' },
  { name = 'Info', icon = '' },
  { name = 'Hint', icon = ' ' },
}

for _, sign in ipairs(signs) do
  local hl = 'DiagnosticSign' .. sign.name
  vim.fn.sign_define(hl, {
    texthl = hl,
    text = sign.icon,
    numhl = hl,
  })
end

return signs
