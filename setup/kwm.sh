#! /bin/bash

cat<<"EOT"
---------------------------
KWM INSTALL & CONFIGURATION
---------------------------

EOT

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "${currentDir}/setup/util_functions.sh"

# install KWM tiling windows manager & add to launchtl startup
brew install koekeishiya/kwm/kwm

symlink_dir .kwm $HOME

echo Starting Kwm
brew services start koekeishiya/kwm/kwm
