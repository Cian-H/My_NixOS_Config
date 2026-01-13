{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs = {
    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    hyprcursor-phinger.enable = true;
  };
}
