{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.podman = {
    enable = true;
    enableTypeChecks = true;
    autoUpdate.enable = true;
  };

  imports = [
    ./containers/media.nix
    ./containers/data_handling.nix
    ./containers/caddy.nix
    ./containers/work_tools.nix
  ];
}
