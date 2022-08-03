local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Turn off relative line numbers for inactive windows
local bkg_numbers = vim.api.nvim_create_augroup('BkgNumbers', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  group = bkg_numbers,
  pattern = '*',
  callback = function()
    vim.opt_local.relativenumber = true
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = bkg_numbers,
  pattern = '*',
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})

-- not sure if I need this 
-- local preview_nonumbers = vim.api.nvim_create_augroup('PreviewNoNumbers', { clear = true })
-- vim.api.nvim_create_autocmd('WinEnter', {
--   group = preview_nonumbers,
--   pattern = '*',
--   command = 'if &previewwindow | setlocal nonumber | endif',
-- })
