#! /bin/bash

platform=`uname`
######################
### LINUX SPECIFIC ###
######################

if [[ $platform == 'Linux' ]]; then

    # copy and pasting
    alias copy='xclip -selection c'
    alias paste='xclip -selection clipboard -o'

    #shorthand / easy to remember
    alias calc='bc'         # Calculator from terminal
    alias mouse='ltunify'   # Pair wireless mouse
    alias node='nodejs'
    alias fontr='fc-cache -f -v'

########################
### MAC OSX SPECIFIC ###
########################
elif [[ $platform  == 'Darwin' ]]; then

    # TODO: alias for showing hidden files
    # defaults write com.apple.finder AppleShowAllFiles YES
    alias bup='brew update; brew upgrade'

    # aliases for Kwm tiling window manager
    alias kwm='brew services restart kwm'
    alias kstop='brew services stop kwm'

    # copy and pasting
    alias copy='pbcopy'
    alias paste='pbpaste'

    alias stow='stow --ignore=".DS_Store"'

    # launch application
    alias finder='open .'
    alias thunar='finder'
    alias ps='open -a  /Applications/Adobe\ Photoshop\ CS5/Adobe\ Photoshop\ CS5.app'
    alias ai='open -a  /Applications/Adobe\ Illustrator\ CS5/Adobe\ Illustrator.app'
    alias graffle='open -a /Applications/OmniGraffle.app'
    alias chromium='open -a  /Applications/Chromium.app'
    alias firefox='open -a /Applications/Firefox.app'
    alias sublime='open -a /Applications/Sublime\ Text.app'
    alias writer='open -a /Applications/iA\ Writer.app'
    alias write='writer'

    alias cask='brew cask'
    alias diff='colordiff'
fi

##########################
### UNIVERSAL  ALIASES ###
##########################

# Manual change Theme
alias light='terminal_theme light'
alias dark='terminal_theme dark'

# grep with color
alias grep='grep --color=auto'

# ls alias for color-mode
alias ls='ls --color'
alias lh='ls -lha'

# dir aliases
alias ll='ls -lhA'
alias la='ls -A'
alias l='ls -CF'

# TODO: collision with internal command `tr`
# alias tr='tree -L '

# moving around dir
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../..'

# refresh shell
# TODO difference between these two files?
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
if [[ -s ~/.bash_profile ]]; then
    shell='source ~/.bash_profile'
# elif [[ -s ~/.bashrc ]]; then
#     shell='source ~/.bashrc'
fi
alias reload=$shell

# alias less='color_less'
alias subl='sublime'

# Git aliases
alias st='git status'
alias log='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias com='git commit'
alias patch='git add --patch'
alias cached='git diff --cached'

# Read markdown files in Lynx
alias md='vmd.sh'
