#!/usr/bin/env zsh

if type brew &>/dev/null; then
  fpath+=$(brew --prefix)/share/zsh/site-functions
fi

#------------------------------------------
# Activate zsh completions
autoload -Uz compinit
compinit

#------------------------------------------
# Aliases: some aliases require `compinit` to be loaded
source $HOME/.aliases

#------------------------------------------
# History
## Set history size
HISTSIZE=10000
## Save history after logout
SAVEHIST=10000
## History file
HISTFILE=$XDG_DATA_HOME/zsh/history
## Append into history file
setopt INC_APPEND_HISTORY
## Save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
## Add timestamp for each entry
setopt EXTENDED_HISTORY   

#------------------------------------------
# Remember recent directories with `cdr`
## https://jlk.fjfi.cvut.cz/arch/manpages/man/zshcontrib.0#REMEMBERING_RECENT_DIRECTORIES
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
## Add arg completion as menu (requires `compinit` to be run)
zstyle ':completion:*' menu selection

#------------------------------------------
# Prompt
autoload -Uz promptinit
promptinit
zstyle :prompt:pure:git:branch color cyan
prompt pure
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-〉}%f'

# Fix for $EDITOR -- set zsh to use emacs style
# keyboard mappings for command-line editing
# e.g., <CTRL+P> to go back in history
bindkey -e

# Make key commands like <CTRL+W> delete just the directory, not the whole line 
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

#------------------------------------------
# Init command-line fuzzy finder
## https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Node (managed through Volta)
# Note that Volta does not search `.zprofile` when running `setup`
export VOLTA_HOME="$XDG_DATA_HOME/volta"
path+=$VOLTA_HOME/bin

