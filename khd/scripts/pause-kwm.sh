#!/bin/bash
# This script is triggered through a hotkey using `khd`

if [ $(pidof kwm) ]; then
    brew services stop kwm
else
    brew services restart kwm
fi
