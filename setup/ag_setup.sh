#!/bin/bash

cat<<"EOT"
--------------------------------------
THE SILVER SEARCHER [Ag] CONFIGURATION
--------------------------------------

EOT
brew install ag

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

if [ -f $HOME/.agignore ]; then
	yellow='\033[1;33m'
	red='\033[1;31m'
	reset='\033[0m' # no color

	echo -e ${yellow}Warning:${reset} Existing .agignore found
    if [ -f $HOME/.agignore.old ]; then
		echo -e ${yellow}Error:${reset} \'.agignore\' and \'.agignore.old\' exist
		echo You must remove these directories manually before rerunning this script
		exit 130
    fi
	echo It has been renamed \'.agignore.old\'
    mv $HOME/.agignore $HOME/.agignore.old
fi

ln -bsS .old $dotfiles/agignore $HOME/.agignore
echo Ag ignore file linked to $HOME/.agignore
echo DONE!
