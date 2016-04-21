#!/bin/bash
cat<<"EOT"
------------------------
TERMINATOR CONFIGURATION
------------------------
EOT

configDir=${HOME}/.config/terminator/
# test if folder already exists
if [ -d !$configDir ]; then
  echo "creating config directory at '$HOME/.config/terminator'"
fi

configFile=${configDir}config
if [ -e $configFile ]; then
  echo "Your old terminator config has been renamed config.old"
  mv $configFile "$configDir/config.old"
fi
  echo "symlinking new config to config directory"
  dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
  ln -s -f ${dotfiles}/terminator $configFile
