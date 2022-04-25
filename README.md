# Personal Dotfiles

Dotfiles for MacOS.

I use [`stow`](https://www.gnu.org/software/stow/) to manage my dotfiles. If you're not familiar with it, it simplifies the process of symlinking the dotfiles in this repo to their intended config location.

## Bootstrap

```sh
source <(curl -s https://raw.githubusercontent.com/xaviervalarino/dotfiles/main/setup/bootstrap.mac.sh)
```

## Post Install

### Symbol font

Install secondary symbol font used in iterm/neovim:

[Download - Symbols-2048-em Nerd Font Complete.ttf](https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf)

### Browser Extensions

Extensions for Firefox and Chrome

Install extensions:

- [Privacy Badger](https://privacybadger.org/)
- [uBlock Origin](https://ublockorigin.com/)
  - TODO: Add Google search blacklist
- [Vimium](https://vimium.github.io/)

  - TODO: Add blacklist

- Add [Bypass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome)

  - [Firefox link](https://github.com/iamadamdev/bypass-paywalls-chrome/releases/latest/download/bypass-paywalls-firefox.xpi)
  - Chrome requires putting extensions into "Developer Mode", use the code snippet below to download and install

  ```
  git clone --depth 1 https://github.com/iamadamdev/bypass-paywalls-chrome ~/Downloads/bypass-paywalls-chrome;\
  open -a /Applications/Google\ Chrome.app chrome://extensions/;\
  open ~/Downloads
  ```

Settings:
- Turn off Saved passwords:
  - Firefox://about:preferences#privacy --- turn off **about:preferences#privacy** > "Ask to save logins and passwords for websites
  - Chrome://settings/passwords --- turn off "Offer to save passwords"
