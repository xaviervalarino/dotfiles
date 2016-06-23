#! /bin/bash
# install KWM tiling windows manager & add to launchtl startup
brew install homebrew/binary/kwm

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

mkdir  -p $HOME/.kwm

# TODO create a bash function that takes a filename and, if it exists,
# prompts user to either raname it to old and write new symlink, or abort,
# or use ln --backup --suffix .old

ln -s $dotfiles/kwm/kwmrc $HOME/.kwm/kwmrc
ln -s $dotfiles/kwm/rules $HOME/.kwm/rules
echo Kwm config files linked to $HOME/.kwm
echo Starting Kwm

brew services start homebrew/binary/kwm
