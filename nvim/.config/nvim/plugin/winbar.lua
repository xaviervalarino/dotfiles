function _G.Winbar()
  local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true }) .. ' '
  return table.concat {
    '%#@text# ',
    icon,
    '%t',
  }
end

vim.o.winbar = '%{%v:lua.Winbar()%}'
