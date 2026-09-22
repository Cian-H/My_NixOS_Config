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
    homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoUpdate = "registry";
      network = [
        "proxy-net"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
        HOMEPAGE_ALLOWED_HOSTS = "home.bulba.space,homepage:3000,localhost:3000";
      };
      volumes = [
        "/home/cianh/homepage/config:/app/config:Z"
      ];
    };
  };
}
