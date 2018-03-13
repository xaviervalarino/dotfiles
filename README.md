# Personal Dotfiles
Dotfiles for Mac OSX and (previously) Debian Jessie.

Items in my OSX setup:

* [**chunkwm**](https://github.com/koekeishiya/chunkwm): tiling windows manager
* [**skhd**](https://github.com/koekeishiya/skhd): hotkey daemon
* **vim**: modal text editor

## Installation
I use [`stow`](https://www.gnu.org/software/stow/) to manage my dotfiles.

Note: run the application first to create the config directories before stowing. This will keep stow from symlinking the whole directory and picking up unwanted files (_e.g._, Vim, Sublime Text)

### VIM
**TODO**: add cURL for Vim plugin installation

Create `.vim` dir before running stow
Create `.vim/undo` dir

```
mkdir ~/.vim
```

### macOS/OSX
There a laundry list of things to do on a fresh install of OSX/MacOS:
[OSX-setup](OSX-setup.md)
