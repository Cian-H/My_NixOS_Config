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

  systemd.user.sockets.podman = {
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0666";
    };
    Install.WantedBy = ["sockets.target"];
  };

  systemd.user.services.podman = {
    Unit = {
      Description = "Podman API Service";
      Requires = ["podman.socket"];
      After = ["podman.socket"];
    };
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.podman}/bin/podman system service --time=0";
    };
  };

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
