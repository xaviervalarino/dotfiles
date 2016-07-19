#! /bin/bash
source ./util_functions.sh

# install KWM tiling windows manager & add to launchtl startup
brew install homebrew/binary/kwm

symlink_dir kwm $HOME

echo Starting Kwm
brew services start homebrew/binary/kwm
