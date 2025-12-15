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
    networks = {
      metrics-net = {};
    };
    containers = {
      goaccess = {
        image = "allinurl/goaccess:latest";
        command = "/var/log/caddy/access.log -o /var/www/goaccess/index.html --log-format=CADDY --tz=Europe/Dublin --anonymize-ip --real-time-html --ws-url=wss://metrics.example.com/ws --port=7890";
        autoUpdate = "registry";
        network = [
          "metrics-net"
        ];
        volumes = [
          "/home/cianh/caddy/logs:/var/log/caddy"
          "/home/cianh/goaccess/data:/var/www/goaccess"
        ];
      };
    };
  };
}
