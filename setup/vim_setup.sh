#!/bin/bash

cat<<"EOT"
-----------------
VIM CONFIGURATION
-----------------
EOT

# SymLink vimrc to home dir
vimrc=${HOME}/.vimrc
if [ -f $vimrc ]; then
  echo "Your old .vimrc has been renamed .vimrc.old"
  mv $vimrc "$HOME/.vimrc.old"

  echo "symlinking new vimrc to home directory"
  dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  ln -s -f ${dotfiles}/vimrc $vimrc
fi

# Download Vim Plug
if [ ! -d "${HOME}/.vim/autoload/" ]; then
  echo "Downloading Vim-Plug"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# update .vimrc
viCmd="silent! so $HOME/.vimrc|"
# clean plugins
viCmd=$viCmd"silent! PlugClean!|"

# Install/update plugins
if [ ! -d "${HOME}/.vim/plugged" ];then
  echo "Installing Vim plugins"
  viCmd=$viCmd"silent! PlugInstall"
else
  echo "Updating Vim plugins"
  viCmd=$viCmd"silent! PlugUpdate"
fi

vim +$viCmd +'qall!' > /dev/null
echo "Done"

