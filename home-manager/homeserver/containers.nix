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

  systemd.user.sockets.podman.Install.WantedBy = ["sockets.target"];

  imports = [
    ./containers/media.nix
    ./containers/caddy.nix
    ./containers/work_tools.nix
    ./containers/nextcloud.nix
    ./containers/gitea.nix
    ./containers/cv.nix
    ./containers/cloudflared.nix
    ./containers/homepage.nix
  ];
}
