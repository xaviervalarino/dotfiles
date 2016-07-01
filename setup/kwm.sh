#! /bin/bash

# install KWM tiling windows manager & add to launchtl startup
brew install homebrew/binary/kwm

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"


# TODO create a bash function that takes a filename and, if it exists,
#      prompts user to either rename it to old and write new symlink, or abort,
#      or use ln --backup --suffix .old
# Use function in all setup scripts

if [ -d $HOME/.kwm ]; then
	yellow='\033[1;33m'
	red='\033[1;31m'
	reset='\033[0m' # no color

	echo -e ${yellow}Warning:${reset} Existing Kwm directory found
    if [ -d $HOME/.kwm.old ]; then
		echo -e ${yellow}Error:${reset} \'.kwm\' and \'.kwm.old\' exist
		echo You must remove these directories manually before rerunning this script
		exit 130
    fi
	echo It has been renamed \'.kwm.old\'
    mv $HOME/.kwm $HOME/.kwm.old
fi

ln -bsS .old $dotfiles/kwm $HOME/.kwm
echo Kwm config directory linked to $HOME/.kwm

echo Starting Kwm
brew services start homebrew/binary/kwm
