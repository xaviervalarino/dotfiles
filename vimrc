set nocompatible              "be iMproved

call plug#begin('~/.vim/plugged')

Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'cakebaker/scss-syntax.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
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
Plug 'vim-scripts/TaskList.vim'

"Add plugins to &runtimepath
call plug#end()


"
"===============================================================================

set history=512                      " Default history is 20
set mouse=a                          " Enable mouse

" TODO fix clipboard settings
" set clipboard=unnamedplus            " Add X11 to the copy register (e.g. <+y>)


" TABS
"===============================================================================

filetype plugin indent on            " Turn on filetype and indent detection

" Default to soft tabs, 4 spaces
set shiftwidth=4    " {sw}  Number of spaces to use for each step of (auto)indent
set softtabstop=4   " {sts} Number of spaces in a <Tab>

set smartindent     " Do smart autoindenting when starting a new line
set smarttab        " <Tab> in front of a line inserts spaces according to 'sw'
set expandtab       " In Insert, use the appropriate number of spaces for a <Tab>

" Set specific filetype tab settings
autocmd FileType js   setl sw=4 sts=4
autocmd FileType jade setl sw=2 sts=2
autocmd FileType css  setl sw=2 sts=2

" Run detectIndent whenever a file is opened
autocmd BufRead * DetectIndent

"Fix backspace
set backspace=2
set backspace=indent,eol,start

"Treat all numerals as decimal, regardless of padded zeros
set nrformats=


" SEARCH
"===============================================================================

set hlsearch                         " Highlight search results
set incsearch                        " Do incremental searching
set showmatch                        " Highlight matching bracket

" Search for visually selected text using '//'
vnoremap // y/<C-R>"<CR>"
" Unset search pattern (highlighting) w/ backslash <\>
nnoremap \ :noh<CR>


" SAVING
"===============================================================================

"remap 'jj' to escape in insert mode
inoremap jj <Esc>

autocmd BufWritePre * :%s/\s\+$//e   " Remove trailing whitespace on save
set noswapfile                       " Turn off swapfile


" THEME
"===============================================================================

syntax on
set number                           " Show line numbers
set laststatus=2                     " Show statusbar
set cursorline                       " Highlight current line
set t_Co=256                         " Set 256 Colors
set encoding=utf8                    " Set char encoding inside Vim
set noshowmode                       " Hide mode line (controlled by Airline)

" Set the background light from 7am to 7pm
let hour = strftime("%H")
if 7 <= hour && hour < 19
  set background=light
else " Set to dark from 7pm to 7am
  set background=dark
endif
colorscheme solarized


" NAVIGATION
"===============================================================================

"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>


" PLUGINS SETUPS
"===============================================================================

let delimitMate_expand_cr = 1                       " Expand brackets
let javascript_enable_domhtmlcss=1                  " Enable HTML/CSS syntax in JS
let g:move_key_modifier = 'C'                       " Vim move modifier key (CTRL)
let g:vimroom_sidebar_height=0                      " Remove statusbar in Vimroom

" YouCompleteMe auto-completion -------------------------------------------------
set omnifunc=syntaxcomplete#Complete "turn on omnicompletion
let g:ycm_key_list_previous_completion = ['<Up>']   " Remove <s-Tab> for automcomplete

" Airline Status Bar ------------------------------------------------------------
let g:airline_powerline_fonts=1                     " Enable powerline fonts
let g:airline#extensions#tabline#enabled = 1        " Don't display all buffers if one tab open
let g:airline#extensions#tabline#left_sep = ' '     " Don't use arrow separator for buffer
let g:airline#extensions#tabline#left_alt_sep = '|' " Same as above
