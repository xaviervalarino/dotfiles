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
HIST_CMD="history -a"
# "history -r" reads the histfile after each command

# THEME -----------------------------------------------------------------------

# set theme based on time of day
# hour=`date +"%H"`
# if [ $hour -gt 7 ] && [ $hour -lt 16 ]; then
#     terminal_theme light
# else
#     terminal_theme dark
# fi

# COMPLETIONS -----------------------------------------------------------------

# If possible, add tab completion for many more commands
# TODO: bash completions are very slow
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# PS1 -------------------------------------------------------------------------

# Add git branches to PS1
[ -f ~/.config/git/git-prompt.sh ] && source ~/.config/git/git-prompt.sh

# Options for __git_ps1
#
#   GIT_PS1_SHOWDIRTYSTATE      : shows unstaged (*) and staged (+)
#   GIT_PS1_SHOWUNTRACKEDFILES  : show if something is stashed ($)
#   GIT_PS1_SHOWUNTRACKEDFILES  : show if there are untracked files (%)
#   GIT_PS1_SHOWUPSTREAM="auto" : see difference between HEAD and upstream
#                               : (<) behind upstream
#                               : (>) ahead of upstream
#                               : (<>) diverged
#                               : (=) no difference
#
# See git/contrib/completion/git-prompt.sh for more info:
# https://github.com/git/git/blob/1eaabe34fc6f486367a176207420378f587d3b48/contrib/completion/git-prompt.sh#L21
# GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"

prompt() {
    path="$blk$bakblu \W $reset"

    # TODO: change git PS1 color depending on `status`
    branch=$(__git_ps1 "%s")
    if [[ "$branch" ]]; then
        # Diverged from origin
        if [[ $branch = *"<>"* ]]; then
            color=$bakred
        # Up to date with origin
        elif [[ $branch = *"="* ]]; then
            color=$bakgrn
        # Ahead of origin
        elif [[ $branch = *">"* ]]; then
            color=$bakpur
        # Behind origin
        elif [[ $branch = *"<"* ]]; then
            color=$bakylw
        # No origin to compare
        else color=$bakwht
        fi
        # Add appropriate color and strip SHOWUPSTREAM symbols
        git="$blk$color ${branch%%[<>=]*} $reset"
    else
        git=""
    fi

    # Add arrow '❯' unicode symbol
    # Note to self: run `printf {unicode_character} | hexdump` to get the value
    symbol=$bldylw$(echo -e "\xe2\x9d\xaf\x0a")$reset

    PS1="$path$git\n$symbol "
}
PROMPT_COMMAND="iterm2_title $PWD; $HIST_CMD; prompt"

# Perl ------------------------------------------------------------------------

# Load local perl modules (perlbrew)
# source ~/perl5/perlbrew/etc/bashrc

# Homebrew --------------------------------------------------------------------

# if [[ $(uname)  == 'Darwin' ]]; then
    # non-brewed cpan modules are installed to the Cellar by default
    # `local::lib` installs them to perl5 dir

    # eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# fi


# PATH ------------------------------------------------------------------------

# Make GNU Coreutils default in OSX
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

# Add Global NPM CLI modules to $PATH
export PATH=$PATH:$HOME/.npm-global/bin

# Add Rust programs to path
# export PATH=$PATH:$HOME/.cargo/bin

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

# turn off special handling of ._* files in tar, etc.
COPYFILE_DISABLE=1; export COPYFILE_DISABLE
