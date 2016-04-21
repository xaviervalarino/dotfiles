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

"Default to soft tabs, 2 spaces
set smartindent
set expandtab
set sw=2
set sts=2

"Fix backspace
set backspace=2
set backspace=indent,eol,start

"Unset search pattern (highlighting) by hitting backslash '\'
nnoremap \ :noh<CR>

set incsearch                        "Do incremental searching
set showmatch                        "Highlight matching bracket
autocmd BufWritePre * :%s/\s\+$//e   "Remove trailing whitespace on save
set listchars=tab:\ \ ,trail:·       "Set trails for tabs and spaces

set omnifunc=syntaxcomplete#Complete "turn on omnicompletion

set background=dark
let base16colorspace=256
colorscheme base16-ocean
"colorscheme hybrid_material

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
let g:airline_theme = "base16"                    "Set theme to powerline default theme

let g:vimroom_sidebar_height=0                    "Fix issue with airline statusbar in Vimroom
