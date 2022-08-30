local navic = require 'nvim-navic'
local separator = ' 〉'

navic.setup {
  highlight = true,
  separator = separator,
}

function _G.Winbar()
  local get_location = navic.get_location()
  local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true }) .. ' '
  return table.concat {
    '%#@text# ',
    icon,
    '%t',
    #get_location > 0 and separator .. get_location or '',
  }
end

vim.o.winbar = '%{%v:lua.Winbar()%}'
