#!/bin/bash
source ./util_functions.sh

cat<<"EOT"
-----------
BSPWM SETUP
-----------

EOT

symlink_dir sxhkd $XDG_CONFIG_HOME
symlink_dir bspwm $XDG_CONFIG_HOME
