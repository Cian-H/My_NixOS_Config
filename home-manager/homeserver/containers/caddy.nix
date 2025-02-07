{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.podman.containers = {
    caddy = {
      image = "docker.io/library/caddy:latest";
      autoUpdate = "registry";
      network = "proxy-net";
      ports = [
        "8080:80"
        "8443:443"
        "8443:443/udp"
      ];
      volumes = [
        "/home/cianh/caddy/config:/etc/caddy"
        "/home/cianh/caddy/data:/data:Z"
        "/home/cianh/caddy/placeholder_site:/var/www/bulba.space:Z"
      ];
    };
  };
}
