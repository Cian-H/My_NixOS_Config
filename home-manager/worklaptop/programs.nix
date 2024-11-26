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
    hyprcursor-phinger.enable = true;
  };
}
