" forked from vim-lightline template by felixjung (http://github.com/felixjung/vim-base16-lightline)
" Base 16 Ocean Scheme by Chris Kempson (http://chriskempson.com)
" Hex colors for GUI and Neovim in TrueColor mode

let s:hex00 = "#2b303b"
let s:hex01 = "#343d46"
let s:hex02 = "#4f5b66"
let s:hex03 = "#65737e"
let s:hex04 = "#a7adba"
let s:hex05 = "#c0c5ce"
let s:hex06 = "#dfe1e8"
let s:hex07 = "#eff1f5"
let s:hex08 = "#bf616a"
let s:hex09 = "#d08770"
let s:hex0A = "#ebcb8b"
let s:hex0B = "#a3be8c"
let s:hex0C = "#96b5b4"
let s:hex0D = "#8fa1b3"
let s:hex0E = "#b48ead"
let s:hex0F = "#ab7967"

" Terminal color definitions
let s:cterm00 = "00"
let s:cterm03 = "08"
let s:cterm05 = "07"
let s:cterm07 = "15"
let s:cterm08 = "01"
let s:cterm0A = "03"
let s:cterm0B = "02"
let s:cterm0C = "06"
let s:cterm0D = "04"
let s:cterm0E = "05"
if exists('base16colorspace') && base16colorspace == "256"
  let s:cterm01 = "18"
  let s:cterm02 = "19"
  let s:cterm04 = "20"
  let s:cterm06 = "21"
  let s:cterm09 = "16"
  let s:cterm0F = "17"
else
  let s:cterm01 = "10"
  let s:cterm02 = "11"
  let s:cterm04 = "12"
  let s:cterm06 = "13"
  let s:cterm09 = "09"
  let s:cterm0F = "14"
endif

" Base16 color pairs
let s:base00 = [ s:hex00, s:cterm00 ]
let s:base01 = [ s:hex01, s:cterm01 ]
let s:base02 = [ s:hex02, s:cterm02 ]
let s:base03 = [ s:hex03, s:cterm03 ]
let s:base04 = [ s:hex04, s:cterm04 ]
let s:base05 = [ s:hex05, s:cterm05 ]
let s:base06 = [ s:hex06, s:cterm06 ]
let s:base07 = [ s:hex07, s:cterm07 ]
let s:base08 = [ s:hex08, s:cterm08 ]
let s:base09 = [ s:hex09, s:cterm09 ]
let s:base0A = [ s:hex0A, s:cterm0A ]
let s:base0B = [ s:hex0B, s:cterm0B ]
let s:base0C = [ s:hex0C, s:cterm0C ]
let s:base0D = [ s:hex0D, s:cterm0D ]
let s:base0E = [ s:hex0E, s:cterm0E ]
let s:base0F = [ s:hex0F, s:cterm0F ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:base01, s:base0D ], [ s:base04, s:base02 ] ]
let s:p.insert.left     = [ [ s:base01, s:base0B ], [ s:base04, s:base02 ] ]
let s:p.visual.left     = [ [ s:base01, s:base0E ], [ s:base04, s:base02 ] ]
let s:p.replace.left    = [ [ s:base01, s:base08 ], [ s:base04, s:base02 ] ]
let s:p.inactive.left   = [ [ s:base01, s:base02 ] ]

let s:p.normal.middle   = [ [ s:base03, s:base01 ] ]
let s:p.inactive.middle = [ [ s:base01, s:base02 ] ]

let s:p.normal.right     = [ [ s:base01, s:base0D ], [ s:base04, s:base02 ] ]
let s:p.insert.right     = [ [ s:base01, s:base0B ], [ s:base04, s:base02 ] ]
let s:p.visual.right     = [ [ s:base01, s:base0E ], [ s:base04, s:base02 ] ]
let s:p.replace.right    = [ [ s:base01, s:base08 ], [ s:base04, s:base02 ] ]
let s:p.inactive.right   = [ [ s:base01, s:base02 ] ]

let s:p.normal.error    = [ [ s:base0A, s:base08 ] ]
let s:p.normal.warning  = [ [ s:base08, s:base0A ] ]

let s:p.tabline.left    = [ [ s:base05, s:base02 ] ]
let s:p.tabline.middle  = [ [ s:base05, s:base01 ] ]
let s:p.tabline.right   = [ [ s:base05, s:base02 ] ]
let s:p.tabline.tabsel  = [ [ s:base02, s:base0A ] ]

" Lightline theme
if  &background ==# "light"
  let s:p.normal.middle   = [ [ s:base03, s:base06 ] ]
  let s:p.inactive.middle = [ [ s:base06, s:base04 ] ]

  let s:p.normal.right     = [ [ s:base06, s:base0D ], [ s:base06, s:base04 ] ]
  let s:p.insert.right     = [ [ s:base06, s:base0B ], [ s:base06, s:base04 ] ]
  let s:p.visual.right     = [ [ s:base06, s:base0E ], [ s:base06, s:base04 ] ]
  let s:p.replace.right    = [ [ s:base06, s:base08 ], [ s:base06, s:base04 ] ]
  let s:p.inactive.right   = [ [ s:base06, s:base04 ] ]

  let s:p.normal.left     = [ [ s:base06, s:base0D ], [ s:base06, s:base04 ] ]
  let s:p.insert.left     = [ [ s:base06, s:base0B ], [ s:base06, s:base04 ] ]
  let s:p.visual.left     = [ [ s:base06, s:base0E ], [ s:base06, s:base04 ] ]
  let s:p.replace.left    = [ [ s:base06, s:base08 ], [ s:base06, s:base04 ] ]
  let s:p.inactive.left   = [ [ s:base06, s:base04 ] ]
endif

let g:lightline#colorscheme#base16_sulphurpool#palette = lightline#colorscheme#flatten(s:p)
