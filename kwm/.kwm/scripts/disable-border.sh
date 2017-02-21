#!/bin/bash
sleep 3;

if  $(kwmc query space active id) ; then
    terminal-notifier -message 'true'
else
    terminal-notifier -message 'false'
fi


if [ $(kwmc query space active id) -eq 2 ]; then
    terminal-notifier -message 'space ID is 2'
else
    terminal-notifier -message 'space ID is NOT 2'
fi

