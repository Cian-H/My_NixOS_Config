{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
