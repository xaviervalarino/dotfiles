#!/bin/bash

cat<<"EOT"
---------------------
OPENBOX CONFIGURATION
---------------------

EOT
config="$HOME/.config/"
openbox="${config}openbox/"
# create config and openbox dir
if [ ! -d $config ]; then
  echo "Creating config directory at ${config}"
  mkdir $config
fi
if [ ! -d $openbox ]; then
  echo "Creating openbox directory at ${openbox}"
  mkdir $openbox
fi

for file in autostart menu.xml rc.xml
do
  configFile="$openbox$file"

  # check for old file
  if [ -e $configFile ]; then
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
