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
    containers = {
      goaccess = {
        image = "docker.io/allinurl/goaccess:latest";
        exec = "--output=/var/www/goaccess/index.html --log-file=/var/log/caddy/access.log --log-format=CADDY --tz=Europe/Dublin --anonymize-ip --real-time-html --ws-url=wss://metrics.bulba.space:443/ws --port=7890 --origin=metrics.bulba.space";
        autoUpdate = "registry";
        network = [
          "proxy-net"
        ];
        volumes = [
          "/home/cianh/caddy/logs:/var/log/caddy:Z"
          "/home/cianh/goaccess/site:/var/www/goaccess"
        ];
      };
    };
  };
}
