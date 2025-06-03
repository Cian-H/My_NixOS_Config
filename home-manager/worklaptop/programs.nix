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
    hyprcursor-phinger.enable = true;
  };
}
