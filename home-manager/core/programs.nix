{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./programs/yazi.nix
  ];
  programs = {
    home-manager.enable = true;
    nushell = let
      pkgStream = unstablePkgs;
    in {
      enable = true;
      package = pkgStream.nushell;
      plugins = with pkgStream.nushellPlugins; [
        formats
        gstat
        polars
        query
      ];
      extraConfig = ''
        source ~/.config/nushell/my_config/config.nu
      '';
      extraEnv = ''
        source ~/.config/nushell/my_config/env.nu
      '';
    };
    git.enable = true;
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    lazygit = {
      enable = true;
      package = unstablePkgs.lazygit;
      enableNushellIntegration = true;
    };
  };
}
