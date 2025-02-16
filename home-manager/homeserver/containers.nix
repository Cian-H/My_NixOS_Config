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
    # A network for exposing endpoints to the reverse proxy
    networks = {
      proxy-net = {
        subnet = "192.168.12.0/24";
      };
    };
  };

  imports = [
    ./containers/media.nix
    ./containers/data_handling.nix
    ./containers/caddy.nix
    ./containers/work_tools.nix
    ./containers/nextcloud.nix
  ];
}
