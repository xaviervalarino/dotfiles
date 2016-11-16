#! /bin/bash

cat<<"EOT"
-----------------
GIT CONFIGURATION
-----------------

EOT
# Don't overwrite existing gitconfig
gitconfig=${HOME}/.gitconfig
if [ -f $gitconfig ]; then
  echo "(!) Your old .gitconfig has been renamed .gitconfig.old"
  mv $gitconfig "$HOME/.gitconfig.old"
fi

# SymLink gitconfig to home dir
dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo "Linking '.gitconfig' to $HOME"
ln -s -f ${dotfiles}/gitconfig $gitconfig

npm i -g diff-so-fancy
