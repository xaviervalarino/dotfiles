set nocompatible              "be iMproved

call plug#begin('~/.vim/plugged')

Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'cakebaker/scss-syntax.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'mikewest/vimroom'
Plug 'tpope/vim-vinegar'
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'terryma/vim-multiple-cursors'
Plug 'matze/vim-move'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/syntastic'
Plug 'marijnh/tern_for_vim'
Plug 'digitaltoad/vim-pug'
Plug 'elentok/plaintasks.vim'
Plug 'ciaranm/detectindent'
Plug 'mustache/vim-mustache-handlebars'
Plug 'tpope/vim-commentary'

"Add plugins to &runtimepath
call plug#end()
filetype plugin indent on

syntax on
set number                           "Show line numbers
set laststatus=2                     "Show statusbar
set t_Co=256                         "Set 256 Colors
set encoding=utf8                    "Show devicons
set history=512                      "Default history is 20
set hlsearch                         "Highlight search results
set incsearch                        "Do incremental searching
set mouse=a                          "Enable mouse
set cursorline                       "Highlight current line
set noshowmode                       "Hide default mode indicator (controlled by airline)
" set clipboard=unnamedplus            "Add X11 to the copy register (e.g. <+y>)

"Default to soft tabs, 2 spaces
set smartindent
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4

"Fix backspace
set backspace=2
set backspace=indent,eol,start

"Treat all numerals as decimal, regardless of padded zeros
set nrformats=

"Unset search pattern (highlighting) by hitting backslash '\'
nnoremap \ :noh<CR>

set incsearch                        "Do incremental searching
set showmatch                        "Highlight matching bracket
autocmd BufWritePre * :%s/\s\+$//e   "Remove trailing whitespace on save

" SAVING
"===============================================================================

set noswapfile                       " Turn off swapfile
autocmd BufWritePre * :%s/\s\+$//e   " Remove trailing whitespace on save


" UI & THEME
"===============================================================================

syntax on
set number                           " Show line numbers
set laststatus=2                     " Show statusbar
set cursorline                       " Highlight current line
set t_Co=256                         " Set 256 Colors
set encoding=utf8                    " Set char encoding inside Vim
set noshowmode                       " Hide mode line (controlled by Airline)
set wildmenu                         " Show completion menu for command line

colorscheme base16-ateliersulphurpool
let base16colorspace=256

"TODO: colorscheme needs some serious overhaul
" Set the background to ENV $THEME
if $THEME == 'light'
  set background=light
  hi LineNr ctermbg=White
  hi SignColumn ctermbg=White
  hi CursorLineNr ctermfg=14 ctermbg=21
  hi GitGutterAdd          ctermbg=White
  hi GitGutterChange       ctermbg=White
  hi GitGutterDelete       ctermbg=White
  hi GitGutterChangeDelete ctermbg=White
else
  set background=dark
  hi LineNr ctermbg=0
  hi SignColumn ctermbg=0
  hi CursorLineNr ctermfg=14 ctermbg=18
  hi GitGutterAdd          ctermbg=0
  hi GitGutterChange       ctermbg=0
  hi GitGutterDelete       ctermbg=0
  hi GitGutterChangeDelete ctermbg=0
endif

set noswapfile                        "turn off swapfile

"remap 'jj' to escape in insert mode
inoremap jj <Esc>
"search for visually selected text using '//'
vnoremap // y/<C-R>"<CR>"
"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>

"let g:enable_bold_font = 1

"================ plugins setups ========================
let delimitMate_expand_cr = 1                         "Expand brackets
let g:ycm_key_list_previous_completion = ['<Up>']     "remove <s-Tab> for
let javascript_enable_domhtmlcss=1                    "Enable HTML/CSS syntax in JS
let g:move_key_modifier = 'C'                         "Vim move modifier key (CTRL)

"Airline
let g:airline#extensions#tabline#enabled = 1      "Don't display all buffers if one tab open
let g:airline#extensions#tabline#left_sep = ' '   "Don't use arrow separator for buffer
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts=1                   "Enable powerline fonts
let g:airline_theme = 'base16'                  " Set airline to base16
" TODO copy over airline theme form base16-builder
" let g:airline_theme = 'base16-ateliersulphurpool'                  " Set airline to base16

let g:vimroom_sidebar_height=0                    "Fix issue with airline statusbar in Vimroom
