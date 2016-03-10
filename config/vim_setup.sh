#!/bin/bash

# SymLink vimrc to home dir
if [ -f "${HOME}/.vimrc" ]; then
  echo "Your old .vimrc has been renamed .vimrc.old"
  mv "$HOME/.vimrc" "$HOME/.vimrc.old"

  echo "symlinking new vimrc to home directory"
  path=$(pwd)
  ln -s ${path}/vimrc ~/.vimrc
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

