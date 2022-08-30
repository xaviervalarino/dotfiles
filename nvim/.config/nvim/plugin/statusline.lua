-- initial
vim.o.statusline = "%!v:lua.require'rc.statusline'()"

-- User event for "CmdlineEnterPre|CmdlineLeavePost" defined in cmdheight-zero.lua
vim.api.nvim_create_autocmd('User', {
  group = 'CmdlineStatus',
  pattern = { 'CmdlineEnterPre', 'CmdlineLeavePost' },
  callback = function(ctx)
    if ctx.match == 'CmdlineEnterPre' then
      vim.opt.laststatus = 0
      vim.opt.statusline = "%!v:lua.require'rc.statusline'('inactive')"
    else
      vim.opt.laststatus = 3
      vim.opt.statusline = "%!v:lua.require'rc.statusline'()"
    end
  end,
})
