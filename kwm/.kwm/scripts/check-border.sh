#!/bin/bash
# Turn off border for spaces that are in `float` mode
# TODO: use some sort of substring extraction to check the tag
# e.g., capture /^[bsp|float|/d/d].*$/ from `kwmc query space active tag` output
if [ $(kwmc query space active name) = 'float_space' ]; then
    kwmc config border focused off
else
    kwmc config border focused on
fi

