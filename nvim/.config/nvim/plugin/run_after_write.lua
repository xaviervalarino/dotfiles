local bufkeymap = require('rc.util').bufkeymap

_G.run_after_write = function(...)
  local shell_cmd = table.concat({ ... }, ' ')
  bufkeymap(0).n(':w', string.format('<cmd>w|! %s<cr>', shell_cmd))
end
_G.clear_run_after_write = function()
  vim.api.nvim_buf_del_keymap(0, 'n', ':w')
end

vim.cmd 'command! -nargs=* RunAfterWrite lua run_after_write(<f-args>)'
vim.cmd 'command! ClearRunAfterWrite lua clear_run_after_write()'
