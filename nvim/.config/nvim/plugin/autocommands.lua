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
local function set_local_numbers(event, set)
  vim.api.nvim_create_autocmd(event, {
    group = local_numbers,
    pattern = '*',
    callback = function()
      vim.opt_local.relativenumber = set
    end,
  })
end
set_local_numbers('WinEnter', true)
set_local_numbers('WinLeave', false)

-- not sure if I need this 
-- local preview_nonumbers = vim.api.nvim_create_augroup('PreviewNoNumbers', { clear = true })
-- vim.api.nvim_create_autocmd('WinEnter', {
--   group = preview_nonumbers,
--   pattern = '*',
--   command = 'if &previewwindow | setlocal nonumber | endif',
-- })
