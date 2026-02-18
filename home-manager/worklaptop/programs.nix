{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  myPkgs = import ./packages/my_pkgs.nix {inherit pkgs;};
in {
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
    walker = {
      enable = true;
      runAsService = true;
    };
    rbw = {
      enable = true;
      settings = {
        email = "chughes000@gmail.com";
        pinentry = myPkgs.rbw-autofill;
      };
    };
    hyprcursor-phinger.enable = true;
  };
}
