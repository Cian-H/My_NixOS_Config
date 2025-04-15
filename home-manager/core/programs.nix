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
    git.enable = true;
  };
}
