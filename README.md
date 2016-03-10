# Personal Dotfiles
I use these dotfiles on Mac OSX and Debian Jessie.

## Bash
Some color, a lot of bash aliases, along with some OS specific settings

###Installation
Running the setup script will [symlink](https://en.wikipedia.org/wiki/Symbolic_link) all the bash files to the home directory.
```bash
chmod +x config/bash_setup.sh; ./bash_setup.sh
```

## Vim
I have been slowly learning Vim. This was born from the desire to be able do everything in the terminal--It can become tedious to jump back and form between the terminal and a text editor window when trying to debug a NodeJS call stack.

###Installation
Running the setup script will symlink vimrc to your home directory, install Vim-Plug (if it is not already installed) and install or update plugins
```bash
chmod +x config/vim_setup.sh; ./vim_setup.sh
```

###Plugins
|Plugin|
|------|
|[nerdtree](https://github.com/scrooloose/nerdtree)|
|[html5.vim](https://github.com/othree/html5.vim)|
|[vim-airline](https://github.com/vim-airline/vim-airline)|
|[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)|
|[vim-hybrid-material](https://github.com/kristijanhusak/vim-hybrid-material)|
|[vim-devicons](https://github.com/ryanoasis/vim-devicons)|
|[vimroom](https://github.com/mikewest/vimroom)|
|[vim-javascript](https://github.com/pangloss/vim-javascript)|
|[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax)|
|[vim-json](https://github.com/elzr/vim-json)|
|[delimitMate](https://github.com/Raimondi/delimitMate)|
|[YouCompleteMe](https://github.com/Valloric/YouCompleteMe)|
|[syntastic](https://github.com/scrooloose/syntastic)|
|[tern_for_vim](https://github.com/marijnh/tern_for_vim)|
|[vim-move](https://github.com/matze/vim-move)|
|[vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)|
|[vim-pug](https://github.com/digitaltoad/vim-pug)|

## Sublime
That being said, Sublime still remains my editor of choice when I need to get something done quickly.

I am currently using [SyntaxMgr](https://github.com/randy3k/SyntaxMgr) to manage platform specific settings.

## Nano
I find myself using this editor from time to time... so why not have syntax highlighting on all of my machines?

## [Conky](https://github.com/brndnmtthws/conky)
I use conky to monitor:
* Network connection
* CPU load
* Memory usage
* Disk Space

![Screenshot of my Debian desktop with Conky and Vim Running](./img/debian_screenshot.png?raw=true)
