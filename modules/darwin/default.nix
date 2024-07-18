{ pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  services.nix-daemon.enable = true;
  users.users.xavier.home = "/Users/xavier";
  programs.zsh.enable = true;
  environment = with pkgs; {
    shells = [ bash zsh ];
    loginShell = zsh;
    systemPackages = [ coreutils ];
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
