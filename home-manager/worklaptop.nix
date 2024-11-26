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
    ./core.nix
    ./worklaptop/packages.nix
    ./worklaptop/services.nix
    ./worklaptop/programs.nix
    ./worklaptop/defaultapps.nix
    ./worklaptop/theming.nix
  ];
}
