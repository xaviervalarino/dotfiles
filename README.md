# Personal Dotfiles
I use these dotfiles on Mac OSX and Debian Jessie.

## Bash
Some color, a lot of bash aliases, along with some OS specific settings

###Installation
Running the setup script will [symlink](https://en.wikipedia.org/wiki/Symbolic_link) all the bash files to the home directory.
```bash
chmod +x config/bash_setup.sh # make script executable
./config/bash_setup.sh        # run script
```

## Vim
I have been slowly learning Vim. This was born from the desire to be able do everything in the terminal—jumping back and forth between the terminal and a text editor window while debugging starts to feel tedious.

###Installation
Running the setup script will symlink _vimrc_ to your home directory, installs [vim-plug](https://github.com/junegunn/vim-plug) (if it is not already installed) and installs or updates plugins
```bash
chmod +x config/vim_setup.sh # make script executable
./config/vim_setup.sh        # run script
```

###plugins
|plugin|description|
|------|-----------|
|[nerdtree](https://github.com/scrooloose/nerdtree)|
|[html5.vim](https://github.com/othree/html5.vim)|HTML5 omnicomplete and syntax highlighting|
|[skammer/vim-css-color](http://github.com/skammer/vim-css-color)|Show colors in CSS files|
|[scss-syntax](http://github.com/cakebaker/scss-syntax.vim)|Syntax highlighting for [Sass](http://sass-lang.com)|
|[vim-airline](https://github.com/vim-airline/vim-airline)|
|[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)|
|[vim-hybrid-material](https://github.com/kristijanhusak/vim-hybrid-material)|
|[vim-devicons](https://github.com/ryanoasis/vim-devicons)|Filetype glyphs for other plugins|
|[vimroom](https://github.com/mikewest/vimroom)|Full-screen focus mode (maybe switching to [pgdouyon's fork](https://github.com/pgdouyon/vimroom))|
|[vim-javascript](https://github.com/pangloss/vim-javascript)|
|[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax)|
|[vim-json](https://github.com/elzr/vim-json)|
|[vim-surround](https://github.com/tpope/vim-surround)|
|[YouCompleteMe](https://github.com/Valloric/YouCompleteMe)|
|[delimitmate](https://github.com/raimondi/delimitmate)|
|[youcompleteme](https://github.com/valloric/youcompleteme)|
|[syntastic](https://github.com/scrooloose/syntastic)|
|[tern_for_vim](https://github.com/marijnh/tern_for_vim)|[tern](http://ternjs.net/)-based JS editing support|
|[vim-move](https://github.com/matze/vim-move)|Move lines and selections up and down|
|[vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)|
|[vim-pug](https://github.com/digitaltoad/vim-pug)|[Pug](http://jade-lang.com/) HTML template syntax highlighting (formerly Jade)|
|[plaintask.vim](https://github.com/elentok/plaintasks.vim)|[Plaintasks](https://github.com/aziz/PlainTasks) for VIM|

## Sublime
That being said, Sublime still remains my editor of choice when I need to get something done quickly.

## Nano
I find myself using this editor from time to time... so why not have syntax highlighting on all of my machines?

## [Conky](https://github.com/brndnmtthws/conky)
I use conky to monitor:
* Network connection
* CPU load
* Memory usage
* Disk Space

![Screenshot of my Debian desktop with Conky and Vim Running](./img/debian_screenshot.png?raw=true)
