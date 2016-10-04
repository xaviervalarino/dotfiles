# Personal Dotfiles
Dotfiles for Mac OSX and Debian Jessie.
<!--
TOC

Installation:
    Caveat
    Individually
    As a whole

Tiling window managers:
    Kwm
    Bswpm

Bash?
    aliases
Text editors:
    Nano
    Sublime
    Vim:
	Tern
	Ag
	Xmodmap
-->

<!--
## Screenshots
![Screenshot of Xavier's Debian desktop with Conky and Vim Running](./img/debian_screenshot.png?raw=true)
-->
## Bash
Configuration includes color for PS1, bash aliases, and OS specific settings (controlled by looking up `uname`)

#### OSX Specific Setup
Mac OSX ships with ancient versions of GNU core utilities.

To install newer versions, use Homebrew. Use the `--with-default-names` flag to use them over the older defaults.
```
brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-tar gnu-indent gnu-getopt grep gzip wget --with-default-names
```

Add them to the PATH and MANPATH in `.bash_profile`:
```sh
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
```
#### Installation
Running the setup script will [symlink](https://en.wikipedia.org/wiki/Symbolic_link) all the files located in bash/ to the home directory.
```bash
./setup/bash_setup.sh # run script
```
<!--
## [Terminator](http://gnometerminator.blogspot.com/p/introduction.html)
A terminal emulator with some nice features like window splitting and dropping files to get the path

#### Installation
Sets up the terminal with no scrollbar and the base16-ocean dark colorscheme
```bash
./setup/terminator_setup.sh # run script
```
-->
## Vim
I have been slowly learning Vim. This was born from the desire to be able do everything in the terminal—jumping back and forth between the terminal and a text editor window while debugging starts to feel tedious.

#### Installation
Running the setup script will symlink _vimrc_ to your home directory, installs [vim-plug](https://github.com/junegunn/vim-plug) (if it is not already installed) and installs or updates plugins
```bash
./setup/vim_setup.sh # run script
```

## [The Silver Searcher (Ag)](https://github.com/ggreer/the_silver_searcher)
The silver searcher is supposedly faster than ack. I use it in Vim with `CtrlP` for fuzzy file searching. This repo contains ag's global `.agignore` file.

## [Sublime](http://www.sublimetext.com/)
~~That being said, Sublime still remains my editor of choice when I need to get something done quickly.~~
I now rarely use sublime, but find it useful to keep it's config under source control.

## [Nano](http://nano-editor.org/)
I find myself using this editor from time to time... so why not have syntax highlighting on all of my machines?

## [Conky](https://github.com/brndnmtthws/conky)
I use conky to monitor:
* Network connection
* CPU load
* Memory usage
* Disk Space

## [Kwm](https://github.com/koekeishiya/kwm)
Tiling windows manager for OSX

## [Openbox](http://openbox.org/wiki/Main_Page)
Openbox lightweight stacking windows manager. Many of my settings are based of off the defaults that came with Crunchbang linux (defunct, but forked as [BunsenLabs](https://www.bunsenlabs.org/))

<!--
#### Dependencies
This configuration requires [cb-pipemenus](https://github.com/gearge/cb-pipemenus) to be in your `$PATH`
#### Installation
Setup script will symlink `autostart`, `rc.xml`, `menu.xml` into `$HOME/.config/openbox`
```bash
./setup/openbox_setup.sh # run script
```
-->

## Disclaimer
These files are for personal use, your mileage may vary (_especially_ with the setup scripts).
