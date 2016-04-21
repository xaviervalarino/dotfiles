#!/bin/bash

cat<<"EOT"
------------------
BASH CONFIGURATION
------------------

EOT

#TODO add bashrc/profile
for file in _aliases _color _functions
do
  homefile="$HOME/.bash$file"
  if [ -e "$homefile" ]; then
    echo "(!) .bash${file} exists, renaming .bash${file}.old"
    mv $homefile ${homefile}.old
  fi

  dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  ln -s -f ${dotfiles}/bash/bash${file} ${homefile}
  echo "SYMLINK: ${dotfiles}/bash/bash${file} --> ${homefile}"
  echo
done
echo
echo "DONE!"

