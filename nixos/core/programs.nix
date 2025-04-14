{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./programs/yazi.nix
    ./programs/neovim.nix
  ];
}
