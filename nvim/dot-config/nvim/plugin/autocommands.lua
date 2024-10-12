local base64_enc = require('rc.util').base64_enc

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('TextYankPost', {
  group = augroup('YankHighlight', { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Turn off relative line numbers for inactive windows
autocmd({ 'WinEnter', 'WinLeave' }, {
  group = augroup('LocalNumbers', { clear = true }),
  callback = function(ctx)
    -- Don't target float windows (which don't have `file` named) or Help docs
    if #ctx.file > 0 and vim.api.nvim_buf_get_option(ctx.buf, 'filetype') ~= 'help' then
      vim.opt_local.relativenumber = ctx.event == 'WinEnter'
    end
  end,
})

-- Turn off cursorline for inactive windows
autocmd({ 'WinEnter', 'WinLeave' }, {
  group = augroup('CursorLineFocus', { clear = true }),
  callback = function(ctx)
    vim.opt_local.cursorline = ctx.event == 'WinEnter'
  end,
})

if not vim.o.cursorline then
  vim.api.nvim_del_augroup_by_name 'CursorLineFocus'
end

-- Create directory if it doesn't exist when saving file
-- https://github.com/jdhao/nvim-config/blob/78baf8d015695c2b795ac6f955550f5e96104845/lua/custom-autocmd.lua#L53-L67
autocmd('BufWritePre', {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ':p:h'), 'p')
  end,
})

-- Update file if modified outside Vim
-- https://github.com/jdhao/nvim-config/blob/78baf8d015695c2b795ac6f955550f5e96104845/lua/custom-autocmd.lua#L69-L92
autocmd({ 'FileChangedShellPost', 'FocusGained', 'CursorHold' }, {
  group = augroup('AutoRead', { clear = true }),
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
autocmd({ 'VimEnter', 'VimLeave', 'VimResume', 'VimSuspend' }, {
  group = augroup('TermMargin', { clear = true }),
  callback = function(ctx)
    local wezterm_pane = vim.env.WEZTERM_PANE
    local kitty_socket = vim.env.KITTY_LISTEN_ON
    local is_out_event = (ctx.event == 'VimLeave' or ctx.event == 'VimSuspend')

    if wezterm_pane then
      local wezterm_str = string.format('wezterm cli set-tab-title --pane-id %s %%s', wezterm_pane)
      local event = base64_enc(is_out_event and 'OUT' or 'IN')

      if event then
        io.write('\x1b]1337;SetUserVar=NVIM_EVENT=' .. event)
      end
    end

    if kitty_socket then
      local padding = is_out_event and 20 or 0
      local cmd = string.format('kitty @ --to=%s set-spacing padding=%s', kitty_socket, padding)
      os.execute(cmd)
    end
  end,
})

-- Save when exiting insert mode
autocmd('InsertLeave', {
  group = augroup('AutoSave', { clear = true }),
  callback = function(ctx)
    if ctx.file:len() > 0 and not ctx.file:find 'Command Line' then
      vim.cmd ':update'
    end
  end,
})
