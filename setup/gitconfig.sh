#! /bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo "Linking '.gitconfig' to $HOME"
ln -s $dotfiles $HOME/.gitconfig

npm i -g diff-so-fancy
