# Personal Dotfiles
Dotfiles for MacOS. 

I use [`stow`](https://www.gnu.org/software/stow/) to manage my dotfiles. If you're not familiar with it, it simplifies the process of symlinking the dotfiles in this repo to their intended config location.

## Bootstrap
```sh
source <(curl -s http://github.com/xaviervalarino/dotfiles/setup/bootstrap.mac.sh)
```


## Post Install
### Chrome
Install extensions:
* [Privacy Badger](https://privacybadger.org/)
* [uBlock Origin](https://ublockorigin.com/)
  * TODO: Add Google search blacklist
* [Vimium](https://vimium.github.io/)
  * TODO: Add blacklist

* Add [Bypass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome)
  ```
  git clone --depth 1 https://github.com/iamadamdev/bypass-paywalls-chrome ~/Downloads/bypass-paywalls-chrome;\
  open -a /Applications/Google\ Chrome.app chrome://extensions/;\
  open ~/Downloads
  ```

Settings:
* chrome://settings/passwords --- turn off "offer to save passwords"
