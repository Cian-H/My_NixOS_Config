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
    bulbaspace-site = {
      image = "docker.io/library/httpd:alpine";
      autoUpdate = "registry";
      network = "proxy-net";
      volumes = [
        "/home/cianh/caddy/placeholder_site/:/usr/local/apache2/htdocs:Z"
      ];
    };
  };
}
