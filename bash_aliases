. ~/.bash_color
. ~/.bash_functions

# Bold and color username@hostname in  yellow, working dir in blue, bang in yellow
PS1="${debian_chroot:+($debian_chroot)}${BYellow}\u@\h: ${BBlue}\w${RESET} ${BYellow}\$${RESET} "

# dir aliases
alias ll='ls -lhA'
alias la='ls -A'
alias l='ls -CF'
alias tr='tree -L '

# moving around dir
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'


#shorthand / easy to remember
alias calc='bc'         # Calculator from terminal
alias mouse='ltunify'   # Pair wireless mouse
alias node='nodejs'
alias subl='sublime'

# Actions
alias reload='source ~/.bash_aliases'             # Reload bash aliases
alias todo='sublime -n ~/Dropbox/notes/todo.md'   # Open ToDo list
alias md='vmd.sh'                                 # Read markdown files in Lynx

# make rm always recursive
alias rm='rm -r'
# Colorize cat
alias ccat="source-highlight --out-format=esc -o STDOUT -i"

# Base16 Shell color for Material Theme
BASE16_SHELL="$HOME/.config/bash/base16-material.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
