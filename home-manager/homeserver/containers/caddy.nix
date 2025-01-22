{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # services.podman.containers = {
  #   caddy = {
  #     image = "docker.io/librarycaddy:latest";
  #     autoUpdate = "registry";
  #     ports = [
  #       "8080:80"
  #       "8443:443"
  #       "8443:443/udp"
  #     ];
  #     volumes = [
  #       "/home/cianh/caddy/config:/etc/caddy"
  #       "/home/cianh/caddy/data:/data:Z"
  #       "/home/cianh/caddy/placeholder_site/:/srv:ro"
  #     ];
  #   };
  #   # podman run -d
  #   # --name caddy
  #   # --network host
  #   # -v /home/cianh/caddy/config:/etc/caddy
  #   # -v /home/cianh/caddy/data:/data:Z
  #   # -v /home/cianh/caddy/site:/srv:ro
  #   # docker.io/library/caddy:latest
  # };
}
