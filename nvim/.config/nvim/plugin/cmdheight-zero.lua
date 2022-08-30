-- Initial setting
vim.opt.cmdheight = 0

local cmd_status = vim.api.nvim_create_augroup('CmdlineStatus', { clear = true })

-- Capture keys that enter Command-line mode
-- "CmdlineEnter" event doesn't happen until after these keys are pressed, which isn't fast enough
-- to counteract the cmdline shift
for _, char in pairs { ':', '/', '?', '!' } do
  vim.keymap.set('', char, function()
    vim.api.nvim_exec_autocmds('User', { pattern = 'CmdlineEnterPre', group = 'CmdlineStatus' })
    vim.fn.feedkeys(char, 'n') -- 'n': do not remap keys, any other option locks up Vim
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
