#!/bin/bash

cat<<"EOT"
------------------
BASH CONFIGURATION
------------------
EOT

for file in _aliases _color _functions
do
  homefile="$HOME/.bash$file"
  if [ -e "$homefile" ]; then
    echo ".bash${file} exists, renaming .bash${file}.old"
    mv $homefile ${homefile}.old
  fi
  thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

  ln -s -f ${thisDir}/bash/bash${file} ${homefile}
done

