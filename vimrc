" PLUGINS
"===============================================================================

call plug#begin('~/.vim/plugged')

" Syntax highlighting ----------------------------------------------------------
Plug 'othree/html5.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'jelera/vim-javascript-syntax'
Plug 'elzr/vim-json'
Plug 'digitaltoad/vim-pug'
Plug 'mustache/vim-mustache-handlebars'
Plug 'elentok/plaintasks.vim'

" UI & Theme -------------------------------------------------------------------
Plug 'itchyny/lightline.vim'            " Enhanced Statusline
Plug 'bling/vim-bufferline'             " List buffers in command bar
"Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'mikewest/vimroom'                 " _Focus Mode_
Plug 'tpope/vim-vinegar'                " Enhance Vim's directory browser

" Text manipulation ------------------------------------------------------------
" Plug 'terryma/vim-multiple-cursors'   " TODO: 'gc' offer this functionality?
Plug 'tommcdo/vim-exchange'             " Easily exchange text
Plug 'matze/vim-move'                   " Easily move lines & v-lines around
Plug 'tpope/vim-surround'               " Modify quotes, parens, or tags
Plug 'Raimondi/delimitMate'             " Insert Mode completion for quotes, etc
Plug 'tpope/vim-commentary'             " Change lines into comments

" Integrated development environment -------------------------------------------
Plug 'ap/vim-css-color'                 " Color highlights in CSS
Plug 'ciaranm/detectindent'             " Detect tab settings in a file
Plug 'airblade/vim-gitgutter'           " Git diff in SignColumn
Plug 'scrooloose/syntastic'             " Sytax linting
Plug 'Valloric/YouCompleteMe'           " Autocompletion
" Plug 'marijnh/tern_for_vim'           " for YouCompleteMe
Plug 'rking/ag.vim'                     " Ag search in Vim
Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy file, buffer, tag, etc finder
Plug 'vim-scripts/TaskList.vim'         " Show all TODOs in a file

"Add plugins to &runtimepath
call plug#end()


" GENERAL
"===============================================================================

set nocompatible                     " Be iMproved
set history=512                      " Default history is 20
set mouse=a                          " Enable mouse
set backspace=indent,eol,start       " Make backspace behave normally
set nrformats=                       " Treat all numerals as decimal, regardless of padded zeros

" TODO fix clipboard settings
" set clipboard=unnamedplus            " Add X11 to the copy register (e.g. <+y>)

" Remap 'jj' to escape in Insert Mode
inoremap jj <Esc>


" INDENTATION
"===============================================================================

filetype plugin indent on            " Turn on filetype and indent detection

" Default to soft tabs, 4 spaces
set shiftwidth=4    " {sw}  Number of spaces to use for each step of (auto)indent
set softtabstop=4   " {sts} Number of spaces in a <Tab>

set smartindent     " Do smart autoindenting when starting a new line
set smarttab        " <Tab> in front of a line inserts spaces according to 'sw'
set expandtab       " In Insert, use the appropriate number of spaces for a <Tab>

" Specific filetype tab settings
autocmd FileType js   setl sw=4 sts=4
autocmd FileType jade setl sw=2 sts=2
autocmd FileType css  setl sw=2 sts=2

" Run detectIndent whenever a file is opened
autocmd BufRead * DetectIndent


" FILE SPECIFIC
"===============================================================================

" TODO: does this need augroup
" Set Git commit msg width to 72 chars & enable formatoptions in Insert Mode
autocmd FileType gitcommit setl textwidth=72 fo-=l


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

" Set the background light from 7am to 7pm
colorscheme solarized

let hour = strftime("%H")

if ( hour > 7 && hour < 18 )
  set background=light
  hi LineNr ctermbg=White
  hi SignColumn ctermbg=White
  hi CursorLineNr ctermbg=LightGray
else " Set to dark from 7pm to 7am
  set background=dark
  hi LineNr ctermbg=8
  hi SignColumn ctermbg=8
  hi CursorLineNr ctermfg=14 ctermbg=Black
endif


" NAVIGATION
"===============================================================================

"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>


" PLUGINS SETUPS
"===============================================================================

let delimitMate_expand_cr = 1                       " Expand brackets
let javascript_enable_domhtmlcss = 1                " Enable HTML/CSS syntax in JS
let g:move_key_modifier = 'C'                       " Vim move modifier key (CTRL)
let g:vimroom_sidebar_height = 0                    " Remove statusbar in Vimroom

" YouCompleteMe auto-completion -------------------------------------------------
set omnifunc=syntaxcomplete#Complete                " Turn on omnicompletion
let g:ycm_key_list_previous_completion = ['<Up>']   " Remove <s-Tab> for complete

" Bufferline --------------------------------------------------------------------
let g:bufferline_echo = 1

" Lightline Statusline ----------------------------------------------------------
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'component': {
  \   'readonly': '%{&readonly?"":""}',
  \ },
  \ 'subseparator': { 'left': '｜', 'right': '｜' }
  \ }

" CtrlP settings ----------------------------------------------------------------
let g:ctrlp_match_window = 'bottom,order:ttb'       " Order matching top to bottom
let g:ctrlp_switch_buffer = 0                       " Open file in new buffer
let g:ctrlp_working_path=0                          " Disable working dir settings

" Search with ag 'silver searcher'
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Syntastic ---------------------------------------------------------------------
let g:syntastic_error_symbol = '☻'
let g:syntastic_style_error_symbol = '☻'
let g:syntastic_warning_symbol = '☻'
let g:syntastic_style_warning_symbol = '☻'

" Make warnings yellow
highlight SyntasticWarningSign ctermfg = 3
