local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Turn off relative line numbers for inactive windows
local local_numbers = vim.api.nvim_create_augroup('LocalNumbers', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave' }, {
  group = local_numbers,
  pattern = '*',
  callback = function(arg)
    vim.opt_local.relativenumber = arg.event == 'WinEnter' and true or false
  end,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave', 'FileType' }, {
  group = vim.api.nvim_create_augroup('CursorLineFocus', { clear = true }),
  callback = function(ctx)
    local value = ctx.event == 'WinEnter'
    if ctx.match == 'TelescopePrompt' then
      value = false
    end
    vim.opt_local.cursorline = value
  end,
})
if not vim.o.cursorline then
  vim.api.nvim_del_augroup_by_name 'cursorlinefocus'
end

-- not sure if I need this 
-- local preview_nonumbers = vim.api.nvim_create_augroup('PreviewNoNumbers', { clear = true })
-- vim.api.nvim_create_autocmd('WinEnter', {
--   group = preview_nonumbers,
--   pattern = '*',
--   command = 'if &previewwindow | setlocal nonumber | endif',
-- })

-- Toggle padding in terminal when entering/leaving vim
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimLeave', 'VimResume', 'VimSuspend' }, {
  group = vim.api.nvim_create_augroup('TermMargin', { clear = true }),
  callback = function(ctx)
    if not vim.env.KITTY_LISTEN_ON then
      return
    end
    local padding = (ctx.event == 'VimLeave' or ctx.event == 'VimSuspend') and 20 or 0
    os.execute('kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=' .. padding)
  end,
})
