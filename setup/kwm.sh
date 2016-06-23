#! /bin/bash
# install KWM tiling windows manager & add to launchtl startup
brew install/binary/kwm
brew services start homebrew/binary/kwm

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

mkdir  -p $HOME/.kwm
ln -s $dotfiles/kwm/kwmrc $HOME/.kwm/kwmrc
ln -s $dotfiles/kwm/rules $HOME/.kwm/rules
