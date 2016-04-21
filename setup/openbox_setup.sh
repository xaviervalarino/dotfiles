#!/bin/bash

cat<<"EOT"
---------------------
OPENBOX CONFIGURATION
---------------------

EOT

for file in autostart menu.xml rc.xml
do
  configFile="$HOME/.config/openbox/$file"
  if [ -e "$configFile" ]; then
    echo "(!) ${file} exists, renaming ${file}.old"
    mv $configFile ${configFile}.old
  fi

  dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  ln -s -f ${dotfiles}/openbox/${file} ${configFile}
  echo "SYMLINK: ${dotfiles}/openbox/${file} --> ${configFile}"
  echo
done
echo
echo "DONE!"
