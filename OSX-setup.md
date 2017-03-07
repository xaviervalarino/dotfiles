# OSX Setup
A list of things to do on a fresh install of OSX

## Turn Caps Lock into the Hyper key
Set up the Caps Lock key to act as ESC when pressed and HYPER (ctrl + cmd + alt + shift) when held down.

1. First, if you haven't already, install Seil and Karabiner:
    ```
    brew cask install seil karabiner
    ```
1. Set Caps Lock to **'No Action'** under  `System Preferences > Keyboard > Modifier Keys...`
1. In Seil, set Caps to keycode `80` (F19)
1. In Dotfiles, use `stow` to add `private.xml` in Karabiner:
    1. `cd ~/dotfiles/; stow karabiner`
    1. Reload and enable

Reference: [_A Modern Space Cadet_ by **Steven Losh**](http://stevelosh.com/blog/2012/10/a-modern-space-cadet/#hyper)


## Windows management with Kwm and Hotkeys with Khd
Use Kwm to manage windows with binary space partitioning. Use Khd to capture hotkeys for moving/arranging windows and launching applications.

If Khd hotkeys do not seem to be working, check the error log:
```
tail -f /tmp/khd.out
```

If the error is something along the lines of `/bin/bash: kwmc: command not found`, then Khd probably does not see itself in `$PATH`  ([Issue #9](https://github.com/koekeishiya/khd/issues/9)). Fix this by running:
```
sudo launchctl config user path /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```
