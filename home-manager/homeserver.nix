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
    ./homeserver/packages.nix
    ./homeserver/programs.nix
    ./homeserver/containers.nix
  ];
}
