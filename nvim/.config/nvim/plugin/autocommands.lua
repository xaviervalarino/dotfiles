local bufmap = require('rc.util').bufkeymap

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Turn off relative line numbers for inactive windows
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('LocalNumbers', { clear = true }),
  callback = function(ctx)
    vim.opt_local.relativenumber = ctx.event == 'WinEnter'
  end,
})

-- Turn off cursorline for inactive and special windows
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('CursorLineFocus', { clear = true }),
  callback = function(ctx)
    vim.opt_local.cursorline = ctx.event == 'WinEnter'
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'CursorLineFocus',
  callback = function(ctx)
    if ctx.match == 'TelescopePrompt' then
      vim.opt_local.cursorline = false
    end
  end,
})
if not vim.o.cursorline then
  vim.api.nvim_del_augroup_by_name 'CursorLineFocus'
end

-- Create directory if it doesn't exist when saving file
-- https://github.com/jdhao/nvim-config/blob/78baf8d015695c2b795ac6f955550f5e96104845/lua/custom-autocmd.lua#L53-L67
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ':p:h'), 'p')
  end,
})

-- Update file if modified outside Vim
-- https://github.com/jdhao/nvim-config/blob/78baf8d015695c2b795ac6f955550f5e96104845/lua/custom-autocmd.lua#L69-L92
vim.api.nvim_create_autocmd({ 'FileChangedShellPost', 'FocusGained', 'CursorHold' }, {
  group = vim.api.nvim_create_augroup('AutoRead', { clear = true }),
  pattern = '*',
  callback = function(ctx)
    if ctx.event == 'FileChangedShellPost' then
      vim.notify('File changed on disk. Buffer reloaded!', vim.log.levels.WARN, { title = 'nvim-config' })
    end
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

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

-- Save when exiting insert mode
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('AutoSave', { clear = true }),
  callback = function(ctx)
    if not ctx.match:find 'Telescope' then
      bufmap(ctx.buf).i('<esc>', '<esc><cmd>update<CR>')
    end
  end,
})
