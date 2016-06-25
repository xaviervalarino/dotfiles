# Personal Dotfiles
Dotfiles for Mac OSX and Debian Jessie.

## Screenshots
![Screenshot of Xavier's Debian desktop with Conky and Vim Running](./img/debian_screenshot.png?raw=true)

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

#### Plugins
Plugin | Description
------ | -----------
[html5.vim](https://github.com/othree/html5.vim) | HTML5 + inline SVG omnicomplete function, indent and syntax
[ap/vim-css-color](http://github.com/skammer/vim-css-color) | Show colors hex codes
[scss-syntax](http://github.com/cakebaker/scss-syntax.vim) | Syntax highlighting for [Sass](http://sass-lang.com)
[vim-javascript](https://github.com/pangloss/vim-javascript) | Improved JS indentation
[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax) | Improved JS syntax highlighting
[vim-pug](https://github.com/digitaltoad/vim-pug) | Highlighting for [Pug](http://jade-lang.com/) HTML template syntax (formerly Jade)
[mustache/vim-mustache-handlebars](https://github.com/mustache/vim-mustache-handlebars) | Support for [Mustache](http://mustache.github.io/) and [Handlebars](http://handlebarsjs.com/) templates
[vim-json](https://github.com/elzr/vim-json) | JSON highlighting for key/value pairs and quote concealment
[vim-surround](https://github.com/tpope/vim-surround) | Key mappings to easily delete, change, and add surrounding pairs
[plaintask.vim](https://github.com/elentok/plaintasks.vim) | [Plaintasks](https://github.com/aziz/PlainTasks) for VIM
[delimitMate](https://github.com/Raimondi/delimitMate) | Auto-completion for quotes, parenthesis, brackets in _Insert_ mode
[detectindent](https://github.com/ciaranm/detectindent) | Automatically detect indent settings in file
[YouCompleteMe](https://github.com/Valloric/YouCompleteMe) | Code-completion using tab
[syntastic](https://github.com/scrooloose/syntastic) | Syntax checking/code linting
[tern_for_vim](https://github.com/marijnh/tern_for_vim) | [Tern](http://ternjs.net/)-based JS editing support
[vim-move](https://github.com/matze/vim-move) | Easily move lines and selected blocks
[vimroom](https://github.com/mikewest/vimroom) | Full-screen focus mode (maybe switching to [pgdouyon's fork](https://github.com/pgdouyon/vimroom))
~~[vim-devicons](https://github.com/ryanoasis/vim-devicons)~~ | ~~Filetype glyphs for other plugins~~
[vim-airline](https://github.com/vim-airline/vim-airline) | Enhanced status and tabline
[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Themes for airline
[base16-ocean](https://github.com/chriskempson/base16-vim) | Dark [Base16-Ocean](http://chriskempson.github.io/base16/#ocean) color scheme

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

## [KWM](https://github.com/koekeishiya/kwm)
Tiling windows manager for OSX

## [Openbox](http://openbox.org/wiki/Main_Page)
Openbox lightweight stacking windows manager. Many of my settings are based of off the defaults that came with Crunchbang linux (defunct, but forked as [BunsenLabs](https://www.bunsenlabs.org/))

#### Dependencies
This configuration requires [cb-pipemenus](https://github.com/gearge/cb-pipemenus) to be in your `$PATH`

#### Installation
Setup script will symlink `autostart`, `rc.xml`, `menu.xml` into `$HOME/.config/openbox`
```bash
./setup/openbox_setup.sh # run script
```

## Disclaimer
These files are for personal use, so your milage (_especially_ with the setup scripts) may vary.
