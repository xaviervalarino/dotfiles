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
Plug 'tpope/vim-vinegar'                " Enhance Vim's directory browser
Plug 'mikewest/vimroom'                 " _Focus Mode_
Plug 'itchyny/lightline.vim'            " Enhanced Statusline
Plug 'bling/vim-bufferline'             " List buffers in command bar
" Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'
Plug 'felixjung/vim-base16-lightline'
" Plug 'daviesjamie/vim-base16-lightline'

" Text manipulation ------------------------------------------------------------
" Plug 'terryma/vim-multiple-cursors'   " TODO: 'gc' offer this functionality?
Plug 'tommcdo/vim-exchange'             " Easily exchange text
Plug 'matze/vim-move'                   " Easily move lines & v-lines around
Plug 'tpope/vim-surround'               " Modify quotes, parens, or tags
Plug 'Raimondi/delimitMate'             " Insert Mode completion for quotes, etc
Plug 'tpope/vim-commentary'             " Change lines into comments
Plug 'tpope/vim-repeat'                 " repeat mappings with Dot command

" Integrated development environment -------------------------------------------
Plug 'ap/vim-css-color'                 " Color highlights in CSS
Plug 'ciaranm/detectindent'             " Detect tab settings in a file
Plug 'airblade/vim-gitgutter'           " Git diff in SignColumn
Plug 'scrooloose/syntastic'             " Sytax linting
Plug 'Valloric/YouCompleteMe'
" Plug 'marijnh/tern_for_vim'           " Needed for YouCompleteMe?
Plug 'rking/ag.vim'                     " Ag search in Vim
Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy file, buffer, tag, etc finder
Plug 'vim-scripts/TaskList.vim'         " Show all TODOs in a file

"Add plugins to &runtimepath
call plug#end()


" GENERAL
"===============================================================================

set nocompatible                     " Be iMproved
set history=5000                     " Default history is 20
set mouse=a                          " Enable mouse
set backspace=indent,eol,start       " Make backspace behave normally
set nrformats=                       " Treat all numerals as decimal, regardless of padded zeros
set spell spelllang=en_us            " Spell checking

" TODO fix clipboard settings
" set clipboard=unnamedplus            " Add X11 to the copy register (e.g. <+y>)

" Remap 'jj' to escape in Insert Mode
inoremap jj <Esc>

" Remove timeout for <escape> i.e. <caps> key
set ttimeout
set ttimeoutlen=100


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
autocmd BufReadPost * DetectIndent


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

" Make search text darker
hi search ctermfg=0
hi WildMenu ctermfg=0


" NAVIGATION
"===============================================================================

"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>

" Window Splits auto-completion -------------------------------------------------

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" More natural split opening
set splitbelow
set splitright

" Quickly resize windows with horizontal split
" :map - <C-W>-
" :map = <C-W>+
" Quickly resize windows with vertical split
:map _ <C-W><
:map + <C-W>>

" PLUGINS SETUPS
"===============================================================================

let delimitMate_expand_cr = 1                       " Expand brackets
let javascript_enable_domhtmlcss = 1                " Enable HTML/CSS syntax in JS
" TODO: collision with Vim-Move and Split Navigation
let g:move_key_modifier = 'C'                   " Vim move modifier key (CTRL)
let g:vimroom_sidebar_height = 0                    " Remove statusbar in Vimroom

" YouCompleteMe auto-completion -------------------------------------------------
set omnifunc=syntaxcomplete#Complete                " Turn on omnicompletion
let g:ycm_key_list_previous_completion = ['<Up>']   " Remove <s-Tab> for complete

" Bufferline --------------------------------------------------------------------
let g:bufferline_echo = 1

" Lightline Statusline ----------------------------------------------------------
let g:lightline = {
  \ 'colorscheme': 'base16_ocean',
  \ 'component': {
  \   'readonly': '%{&readonly?"":""}',
  \ },
  \ 'subseparator': { 'left': '｜', 'right': '｜' }
  \ }

" CtrlP settings ----------------------------------------------------------------
let g:ctrlp_match_window = 'bottom,order:ttb'       " Order matching top to bottom
let g:ctrlp_switch_buffer = 0                       " Open file in new buffer
let g:ctrlp_working_path= 0                         " Disable working dir settings

" Search with ag 'silver searcher'
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Syntastic ---------------------------------------------------------------------
let g:syntastic_error_symbol = '☻'
let g:syntastic_style_error_symbol = '☻'
let g:syntastic_warning_symbol = '☻'
let g:syntastic_style_warning_symbol = '☻'

" Make warnings yellow
highlight SyntasticWarningSign ctermfg = 3
