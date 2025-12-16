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
        image = "docker.io/allinurl/goaccess:latest";
        exec = "--output=/var/www/goaccess/index.html --log-file=/var/log/caddy/access.log --log-format=CADDY --tz=Europe/Dublin --anonymize-ip --real-time-html --ws-url=wss://metrics.example.com/ws --origin=https://metrics.bulba.space --port=7890";
        autoUpdate = "registry";
        network = [
          "proxy-net"
        ];
        volumes = [
          "/home/cianh/caddy/logs:/var/log/caddy"
          "/home/cianh/goaccess/site:/var/www/goaccess"
        ];
      };
    };
  };
}
