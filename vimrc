set nocompatible              " be iMproved

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'othree/html5.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'ryanoasis/vim-devicons'
Plug 'mikewest/vimroom'
Plug 'pangloss/vim-javascript'
Plug 'jelera/vim-javascript-syntax'
Plug 'elzr/vim-json'
Plug 'Raimondi/delimitMate'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/syntastic'
Plug 'marijnh/tern_for_vim'
Plug 'matze/vim-move'
Plug 'terryma/vim-multiple-cursors'
Plug 'digitaltoad/vim-pug'

" Add plugins to &runtimepath
call plug#end()
filetype plugin indent on

syntax on
set number                           "Show line numbers
set laststatus=2                     "Show statusbar
set t_Co=256                         "Set 256 Colors
set encoding=utf8                    "Show devicons
set history=512                      "Default history is 20
set hlsearch                         "Highlight search results
set mouse=a                          "Enable mouse
set cursorline                       "Highlight current line
set noshowmode                       "Hide default mode indicator (controlled by airline)

" Default to soft tabs, 2 spaces
set smartindent
set expandtab
set sw=2
set sts=2

set showmatch                        "Highlight matching bracket
autocmd BufWritePre * :%s/\s\+$//e   "Remove trailing whitespace on save
set listchars=tab:\ \ ,trail:·       "Set trails for tabs and spaces

set omnifunc=syntaxcomplete#Complete "turn on omnicompletion

":set background=dark
colorscheme hybrid_material

set noswapfile                        "turn off swapfile

" remap 'jj' to escape in insert mode
inoremap jj <Esc>

"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>

let g:enable_bold_font = 1

" ================ plugins setups ========================
let delimitMate_expand_cr = 1                         "Expand brackets
let javascript_enable_domhtmlcss=1                    "Enable HTML/CSS syntax in JS

let g:move_key_modifier = 'C'                         " Vim move modifier key (CTRL)

"Airline
let g:airline#extensions#tabline#enabled = 1      "Display all buffers if one tab open
let g:airline#extensions#tabline#left_sep = ' '   "Don't use arrow separator for buffer
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts=1                   "Enable powerline fonts
let g:airline_theme = "bubblegum"                 "Set theme to powerline default theme

let g:NERDTreeChDirMode = 2                       "Always change the root directory
let g:NERDTreeShowHidden = 1                      "Show hidden files
let g:NERDTreeIgnore = ['\.git$','\.sass-cache$'] "Ignore files
"Open Nerd tree if no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-N> :NERDTreeToggle<CR>

let g:vimroom_sidebar_height=0                    "Fix issue with airline statusbar in Vimroom
