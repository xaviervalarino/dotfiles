" Turn off relative line numbers for inactive windows
augroup BgNumbers
  autocmd!
  autocmd WinEnter * setlocal relativenumber
  autocmd WinLeave * setlocal norelativenumber
augroup END

" turn of line numbers in preview windows
augroup PreviewAutocmds
  autocmd!
  autocmd WinEnter * if &previewwindow | setlocal nonumber | endif
augroup END
