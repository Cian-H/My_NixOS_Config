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
    home-manager.enable = true;
    git.enable = true;
  };
}
