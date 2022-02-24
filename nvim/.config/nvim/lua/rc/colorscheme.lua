vim.g.tokyonight_hide_inactive_statusline = true

-- Fix divider between window splits
-- TODO: move this to Lua
-- StatusLine     xxx cterm=bold,reverse guifg=#a9b1d6 guibg=#1f23350
-- StatusLineNC   xxx cterm=reverse guifg=#3b4261 guibg=#1f2335
vim.cmd[[
  function! StatusBarFix() abort
    highlight StatusLineNC cterm=underline guifg=#565f89 guibg=#2428
  endfunction

  augroup MyColors
    autocmd!
    autocmd Colorscheme tokyonight call StatusBarFix()
  augroup END

  colorscheme tokyonight
]]
