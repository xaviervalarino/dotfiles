" Quick fix: suppress error message printed for python3
" https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
  silent! python3 1
endif

" PLUGINS
"===============================================================================
call plug#begin('~/.vim/plugged')

" Syntax highlighting ----------------------------------------------------------
Plug 'sheerun/vim-polyglot'
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
"
" UI & Theme -------------------------------------------------------------------
Plug 'tpope/vim-vinegar'                            " Enhance Vim's directory browser
Plug 'bling/vim-bufferline'                         " List buffers in command bar
Plug 'itchyny/lightline.vim'                        " Enhanced Statusline
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }          " Focus writing mode
Plug 'arcticicestudio/nord-vim'                     " Nord colorscheme
Plug 'junegunn/limelight.vim', { 'on': 'Limelight'} " Highlight text based on focus

" Text manipulation ------------------------------------------------------------
" Plug 'terryma/vim-multiple-cursors'             " TODO: 'gc' offer this functionality?
Plug 'tommcdo/vim-exchange'                     " Easily exchange text
Plug 'matze/vim-move'                           " Easily move lines & v-lines around
Plug 'tpope/vim-surround'                       " Modify quotes, parenthesis, or tags
Plug 'Raimondi/delimitMate'                     " Insert Mode completion for quotes, etc
Plug 'tpope/vim-commentary'                     " Change lines into comments
Plug 'tpope/vim-repeat'                         " Repeat mappings with Dot command
Plug 'godlygeek/tabular'                        " Text filtering and alignment
Plug 'reedes/vim-pencil', { 'for': 'markdown' } " Writing plugin to control text wrapping and formatting
Plug 'reedes/vim-wordy', { 'for': 'markdown' }  " Highlight repetitive and jargon words in prose
Plug 'tpope/vim-speeddating'                    " Increment dates times and more

" Integrated development environment -------------------------------------------
Plug 'ap/vim-css-color'                                   " Color highlights in CSS
Plug 'ciaranm/detectindent'                               " Detect tab settings in a file
Plug 'airblade/vim-gitgutter'                             " Git diff in SignColumn
Plug 'neomake/neomake'                                    " Async synstax checker
Plug 'gcorne/vim-sass-lint', { 'for': [ 'sass', 'scss' ]} " Sass/scss stynax linting
Plug 'Valloric/YouCompleteMe'                             " Tab code-completion
Plug 'rking/ag.vim'                                       " Ag search in Vim
Plug 'tpope/vim-fugitive'                                 " Git intergration
" Plug 'ctrlpvim/ctrlp.vim'                                " Fuzzy file, buffer, tag, etc finder
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }

"Add plugins to &runtimepath
call plug#end()


" GENERAL
"===============================================================================

set nocompatible               " Be iMproved
set history=5000               " Default history is 20
set mouse=a                    " Enable mouse
set backspace=indent,eol,start " Make backspace behave normally
set nrformats=                 " Treat all numerals as decimal, regardless of padded zeros
set spell spelllang=en_us      " Spell checking
set autowrite                  " Save file when modified (esp. nice when switching buffers)
set hidden                     " Enable unsaved buffers
set linebreak                  " Break lines on word
set autoread                   " Reload files changed outside vim

set  virtualedit+=block,onemore     " Allow cursor to move anywhere in V-BLOCK mode

" Use the same symbols as Textmate and InDesign for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
" TODO fix clipboard settings
" set clipboard=unnamedplus            " Add X11 to the copy register (e.g. <+y>)

" Remove timeout for <escape> i.e. <caps> key
set ttimeout
set ttimeoutlen=0

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')


" Yoshua  Wyuts clipboard
" set clipboard^=unnamed,unnamedplus
" TODO: maybe use leader here
" Copy visual selection
vmap <C-c> "+yi<ESC>
" Cut visual selection
vmap <C-x> "+c<ESC>
" Paste to visual selection
vmap <C-v> "+p
" Paste in normal mode
" imap <C-v> <C-r><C-o>+


" COMMAND LINE MODE
"===============================================================================

" Recall command history with filter capabilities
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>


" INDENTATION
"===============================================================================

filetype plugin indent on            " Turn on filetype and indent detection

" Default to soft tabs, 4 spaces
set shiftwidth=4        " {sw}  Number of spaces to use for each step of (auto)indent
set softtabstop=4       " {sts} Number of spaces in a <Tab>

set smartindent         " Do smart auto-indenting when starting a new line
set smarttab            " <Tab> in front of a line inserts spaces according to 'sw'
set expandtab           " In `Insert`, use the appropriate number of spaces for a <Tab>

set breakindent         " Visually indent wrapped lines of text
set whichwrap+=<,>,[,]  " Wrap on these characters

" Specific filetype tab settings
autocmd FileType javascript   setl sw=4 sts=4

autocmd FileType css,scss,yaml setl sw=2 sts=2
" Run detectIndent whenever a file is opened
autocmd BufReadPost * DetectIndent


" PERSISTENT UNDO
"===============================================================================

set undofile                " Save undo's after file closes
set undodir=~/.vim/undo     " Directory where Undo history file are saved
                            " NOTE! Vim will not create this dir
set undoreload=10000        " Max number lines to save on a buffer reload
set undolevels=1000         " Max number of set changes that can be undone


" FILE SPECIFIC
"===============================================================================

" GIT
" Set Git commit msg width to 72 chars & enable formatoptions in Insert Mode
" TODO: does this need augroup?
autocmd FileType gitcommit setl textwidth=72 fo-=l

" MARKDOWN
" Syntax highlight YAML front matter as a comment in Markdown files
autocmd BufNewFile,BufRead *.md syntax match Comment /\%^---\_.\{-}---$/

" SEARCH
"===============================================================================

set hlsearch   " Highlight search results
set incsearch  " Do incremental searching
set showmatch  " Highlight matching bracket
set ignorecase " Ignore case in search patterns
set smartcase  " Override `ignorecase` if search contains upper
" set gdefault " Set search to Global by default

" Center search in the middle of the screen
map N Nzz
map n nzz

" Search for visually selected text using '//'
vnoremap // y/<C-R>"<CR>"
" Unset search pattern (highlighting) w/ backslash <\>
nnoremap \ :noh<CR>


" SAVING
"===============================================================================

set noswapfile                     " Turn off swapfile
autocmd BufWritePre * :%s/\s\+$//e " Remove trailing whitespace on save


" UI & THEME
"===============================================================================

syntax on
set number                     " Show line numbers
set laststatus=2               " Always show statusbar (between windows)
set title                      " Show filename in titlebar
set encoding=utf8              " Set char encoding inside Vim
set noshowmode                 " Hide mode line (since we are using Lightline statusbar)
set wildmode=list:longest,full " Show completion menu for command line
set fillchars=vert:\│          " Change vertical divider to tall pipe char

" Cursorline, only in active window
augroup CursorLine
 au!
 au VimEnter * setlocal cursorline
 au WinEnter * setlocal cursorline
 au BufWinEnter * setlocal cursorline
 au WinLeave * setlocal nocursorline
augroup END

" change cursor shape depending on mode
" use block for 'Normal' and Beam for 'Insert'
if exists('&t_SI')
    let &t_SI .= "\<Esc>[5 q"
    let &t_EI .= "\<Esc>[1 q"
endif


" NAVIGATION
"===============================================================================

"switch buffers
map <tab> :bn<cr>
map <S-tab> :bp<cr>

" Window Splits auto-completion ------------------------------------------------

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

" visually select a section and then hit @ to run a macro on all lines
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" PLUGIN SETUP
"===============================================================================

let delimitMate_expand_cr = 2        " Expand <CR>
let delimitMate_expand_space = 1     " Expand spaces
let delimitMate_jump_expansion = 1   " Jump to closing delimiter

let javascript_enable_domhtmlcss = 1 " Enable HTML/CSS syntax in JS

let g:move_map_keys = 0 " Set Vim-move mapping to `Esc+` for iTerm2"

" Keeps Esc from waiting for other keys to exit visual
" For terms that send Alt as Escape sequence use the <F20> hack.
" Reference:
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
" https://github.com/matze/vim-move/issues/15

set <F20>=j
set <F21>=k

vmap j <Plug>MoveBlockDown
vmap k <Plug>MoveBlockUp
nmap j <Plug>MoveLineDown
nmap k <Plug>MoveLineUp

" YouCompleteMe auto-completion ------------------------------------------------
set omnifunc=syntaxcomplete#Complete                " Turn on omnicompletion
let g:ycm_key_list_previous_completion = ['<Up>']   " Remove <s-Tab> for complete
set completeopt-=preview                            " Remove preview window

" Bufferline -------------------------------------------------------------------
let g:bufferline_echo = 1

" Lightline Statusline ---------------------------------------------------------
let g:lightline = {
   \ 'colorscheme': 'nord',
   \ 'active': {
   \   'right': [ ['lineinfo'], ['percent'], ['filetype']],
   \   'left': [ [ 'mode', 'paste' ],
   \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
   \ },
   \ 'component': {
   \   'readonly': '%{&readonly?" ⭤":""}'
   \ },
   \ 'component_function': {
   \   'gitgranch': 'fugitive#head'
   \ },
   \ 'subseparator': { 'left': '｜', 'right': '｜' }
   \ }

" CtrlP settings ---------------------------------------------------------------
let g:ctrlp_match_window = 'bottom,order:ttb' " Order matching top to bottom
let g:ctrlp_switch_buffer = 0                 " Open file in new buffer
let g:ctrlp_working_path= 0                   " Disable working dir settings

" Search with ag 'silver searcher'
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Neomake ----------------------------------------------------------------------
" When writing a buffer (no delay).
" call neomake#configure#automake('w')

" When writing a buffer (no delay), and on normal mode changes (after 750ms).
" call neomake#configure#automake('nw', 750)

" When reading a buffer (after 1s), and when writing (no delay).
" call neomake#configure#automake('rw', 1000)

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" Pencil -----------------------------------------------------------------------
let g:pencil#wrapModeDefault = 'soft'

function! Prose()
  call pencil#init()

  " replace common punctuation
  iabbrev <buffer> -- –
  iabbrev <buffer> --- —
  iabbrev <buffer> << «
  iabbrev <buffer> >> »

endfunction

" automatically initialize buffer by file type
autocmd FileType markdown,mkd,mk,text call Prose()

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()

" Goyo -------------------------------------------------------------------------

let g:goyo_linenr=1

function! s:goyo_enter()
  set showmode
  set scrolloff=999 " Center the cursor like a typewriter
  " Limelight
endfunction

function! s:goyo_leave()
  colorscheme nord
  set scrolloff=5
  " Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Nord Colorscheme -------------------------------------------------------------

set termguicolors
" Nord let commands need to set before the call to Nord colorscheme
let g:nord_comment_brightness = 7
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_status_lines = 1
let g:nord_uniform_diff_background = 1

highlight Comment cterm=italic

colorscheme nord

" Tabularize -------------------------------------------------------------------

" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
