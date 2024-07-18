{ pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  services.nix-daemon.enable = true;
  users.users.xavier.home = "/Users/xavier";
  programs.zsh.enable = true;
  environment = {
    shells = [ pkgs.bash pkgs.zsh ];
    loginShell = pkgs.zsh;
    systemPackages = [ pkgs.coreutils ];
  };
  system = {
    # stateVersion
    defaults = {
      # finder.AppleShowAllExtensions = true;
      dock.autohide = true;
      finder._FXShowPosixPathInTitle = true;
      # finder.AppleShowAllExtensions = true;
      NSGlobalDomain.AppleShowAllExtensions = true;
    };
  };
}
