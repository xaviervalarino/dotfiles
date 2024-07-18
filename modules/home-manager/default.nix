{ pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    packages = [
      pkgs.ripgrep
      pkgs.fd
      pkgs.du-dust
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    bat.config.theme = "base16";
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    git.enable = true;
    zsh.enable = true;
    zsh.enableCompletion = true;
    zsh.autosuggestion.enable = true;
    zsh.syntaxHighlighting.enable = true;
    # zsh.shellAliases = true;
    wezterm.enable = true;
    wezterm.enableZshIntegration = true;
  };
}
