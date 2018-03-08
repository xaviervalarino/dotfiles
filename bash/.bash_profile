#! /bin/bash
# Source other files ----------------------------------------------------------

source $HOME/.bash_aliases
source $HOME/.config/bash/color
source $HOME/.config/bash/functions

# HISTORY ---------------------------------------------------------------------

# remove duplicate commands from history
HISTCONTROL=ignoreboth:erasedups

# use a larger history file
HISTSIZE=1000
HISTFILESIZE=5000


# write command to histfile after each command
export PROMPT_COMMAND="history -a"
# "history -r" reads the histfile after each command

# THEME -----------------------------------------------------------------------

# set theme based on time of day
hour=`date +"%H"`
# if [ $hour -gt 7 ] && [ $hour -lt 16 ]; then
#     terminal_theme light
# else
#     terminal_theme dark
# fi

# COMPLETIONS -----------------------------------------------------------------

# If possible, add tab completion for many more commands
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# PS1 -------------------------------------------------------------------------

# Add git branches to PS1
[ -f ~/.config/git/git-prompt.sh ] && source ~/.config/git/git-prompt.sh

prompt() {
    path="$blk$bakblu \W"
    # TODO: change git PS1 color depending on `status`
    git="$blk$bakpur $(__git_ps1 "(%s)") $reset"
    # symbol=$(echo -e "\xe2\x9a\xa1\xef\xb8\x8f") # ⚡️ lightning bolt emoji
    symbol=$bldylw$(echo -e " \xe2\x9d\x96\x0a")$reset # ❖ diamond unicode symbol
    PS1="$path $git\n$symbol "
}
PROMPT_COMMAND=prompt

# Perl ------------------------------------------------------------------------

# Load local perl modules (perlbrew)
source ~/perl5/perlbrew/etc/bashrc

# Homebrew --------------------------------------------------------------------

if [[ $(uname)  == 'Darwin' ]]; then
    # non-brewed cpan modules are installed to the Cellar by default
    # `local::lib` installs them to perl5 dir

    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

fi


# PATH ------------------------------------------------------------------------

# Make GNU Coreutils default in OSX
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

# Global NPM
export PATH=$PATH:$HOME/.npm-global/bin

# Add Rust programs to path
export PATH=$PATH:$HOME/.cargo/bin

# -----------------------------------------------------------------------------

# TODO difference between these two files?
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
# if [[ -s ~/.bash_profile ]]; then
#   shell='source ~/.bash_profile'
#   elif [[ -s ~/.bashrc ]]; then
#     shell='source ~/.bashrc'
# fi

# Turn on extglob wildcards
shopt -s extglob
