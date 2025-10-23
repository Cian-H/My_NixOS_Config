{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.gitea = {
    networks = {
      gitea-net = {};
    };
    containers = {
      nextcloud = {
        image = "docker.gitea.com/gitea:latest-rootless";
        autoUpdate = "registry";
        network = [
          "gitea-net"
          "proxy-net"
        ];
        ports = [
          "3000:3000"
          "2222:2222"
        ];
        volumes = [
          "/home/cianh/gitea/data:/var/lib/gitea"
          "/home/cianh/gitea/config:/etc/gitea"
          "/etc/timezone:/etc/timezone:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };
    };
  };
}
