#! /bin/bash
# install KWM tiling windows manager & add to launchtl startup
brew install/binary/kwm
brew services start homebrew/binary/kwm
ln -s /Users/Xavier/.dotfiles/kwmrc /Users/Xavier/.kwm/
