#! /bin/bash
# Source other files -------------------------------------------------------------

source $HOME/.bash_aliases
source $HOME/.bash/color
source $HOME/.bash/functions

# HISTORY ------------------------------------------------------------------------

# remove duplicate commands from history
HISTCONTROL=ignoreboth:erasedups

# use a larger history file
HISTSIZE=1000
HISTFILESIZE=2000

# THEME --------------------------------------------------------------------------
# set theme based on time of day
hour=`date +"%H"`
if [ $hour -gt 7 ] && [ $hour -lt 16 ]; then
    terminal_theme light
else
    terminal_theme dark
fi

# COMPLETIONS --------------------------------------------------------------------

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion        # linux
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash    # mac

# Add git branches to PS1
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh

# PS1 ----------------------------------------------------------------------------

# Bold and color username@hostname in  yellow, working dir in blue, bang in yellow
# PS1="${debian_chroot:+($debian_chroot)}${BYellow}\u@\h: ${BBlue}\w${RESET} ${BYellow}\$${RESET} "
# TODO combine bash_colors with git_ps1
PS1="${BPurple}─────────$RESET "
# PS1="$BBlue\w$RESET $BPurple$(printf "%$(tput cols;)s" | tr ' ' ─) $(__git_ps1 "(%s)")$RESET\n$BYellow> $RESET"

 # prompt() {
 #    path="$BBlue\w$RESET "
 #    width="$(($(tput cols)-$($path | wc -c)))"
 #    dash='\xe2\x80\x94'
 #    line="$BPurple$(printf "%*s" $width | tr ' ' -)$RESET" #─
 #    PS1="$path $width $line$(__git_ps1 "(%s)")\n$BYellow> $RESET"
 # }
# PROMPT_COMMAND=prompt

# Perl ---------------------------------------------------------------------------

# Load local perl modules (perlbrew)
source ~/perl5/perlbrew/etc/bashrc

# Homebrew -----------------------------------------------------------------------

if [[ $(uname)  == 'Darwin' ]]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        source $(brew --prefix)/etc/bash_completion
    fi
    # non-brewed cpan modules are installed to the Cellar by default
    # `local::lib` installs them to perl5 dir

    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

    # Make GNU Coreutils default in OSX
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi


# PATH ---------------------------------------------------------------------------

# Global NPM
export PATH="$HOME/.npm-global/bin:$PATH"

# Add Rust programs to path
export PATH="$HOME/.cargo/bin:$PATH"

# --------------------------------------------------------------------------------

# TODO difference between these two files?
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
# if [[ -s ~/.bash_profile ]]; then
#   shell='source ~/.bash_profile'
#   elif [[ -s ~/.bashrc ]]; then
#     shell='source ~/.bashrc'
# fi
