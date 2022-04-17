" Turn off relative line numbers for inactive windows
augroup BkgNumbers
  autocmd!
  autocmd WinEnter * setlocal relativenumber
  autocmd WinLeave * setlocal norelativenumber
augroup END

" turn off line numbers in preview windows
augroup PreviewNoNumbers
  autocmd!
  autocmd WinEnter * if &previewwindow | setlocal nonumber | endif
augroup END
