local map = require('rc.util').keymap

-- Initial setting
vim.opt.cmdheight = 0
vim.opt.ruler = false

local cmd_status = vim.api.nvim_create_augroup('CmdlineStatus', { clear = true })

-- Capture keys that enter Command-line mode
-- "CmdlineEnter" event doesn't happen until after these keys are pressed, which isn't fast enough
-- to counteract the cmdline shift
for _, char in pairs { ':', '/', '?', '!' } do
  map(char, function()
    local keys = vim.api.nvim_replace_termcodes(char, true, false, true)
    vim.api.nvim_exec_autocmds('User', { pattern = 'CmdlineEnterPre', group = 'CmdlineStatus' })
    vim.api.nvim_feedkeys(keys, 'n', false) -- 'n': do not remap keys, any other option locks up Vim
  end)
end

vim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
  group = 'CmdlineStatus',
  callback = function()
    vim.api.nvim_exec_autocmds('User', { pattern = 'CmdlineLeavePost', group = 'CmdlineStatus' })
  end,
})

-- See "StatusLineToggle" autogroup in StatusLine
vim.api.nvim_create_autocmd('User', {
  group = 'CmdlineStatus',
  pattern = { 'CmdlineEnterPre', 'CmdlineLeavePost' },
  callback = function(ctx)
    if ctx.match == 'CmdlineEnterPre' then
      vim.opt.cmdheight = 1
    else
      vim.opt.cmdheight = 0
    end
  end,
})
