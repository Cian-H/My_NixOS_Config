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
    ./core/programs.nix
  ];
}
