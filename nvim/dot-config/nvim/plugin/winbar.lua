function _G.Winbar()
  local file_name = vim.fn.expand '%:t'
  local file_ext =  vim.fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true })

  if not file_name then
    return ' '
  end

  return table.concat {
    '%#@text# ',
    '%=',
    icon,
    '  ', -- space for icon
    '%t',
    ' %m',
    '%=',
  }
end

vim.o.winbar = '%{%v:lua.Winbar()%}'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'alpha', 'netrw' },
  group = vim.api.nvim_create_augroup('winbar', { clear = true }),
  callback = function()
    vim.wo.winbar = ' '
  end,
})
