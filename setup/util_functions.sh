#! /bin/bash

# Utility function used by the setup scripts

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

yellow='\033[1;33m'
red='\033[1;31m'
reset='\033[0m' # no color

symlink_dir(){

    # PARAMETERS
    # $1: dirName,
    # $2: dirLocation

    if [ -d $2/.$1 ]; then
        echo -e ${yellow}Warning:${reset} Existing ${1} directory found
        if [ -d $2/.$1.old ]; then
            echo -e ${yellow}Error:${reset} \'.${1}\' and \'.${1}.old\' exist
            echo Remove these directories manually before rerunning this script
        fi
    fi
    ln -bsS .old $dotfiles/$1 $2/$1
    echo $1 symlinked in $2
}
