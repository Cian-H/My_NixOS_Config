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
      gitea-net = {};
    };
    containers = {
      gitea = {
        image = "docker.gitea.com/gitea:latest";
        autoUpdate = "registry";
        network = [
          "gitea-net"
          "proxy-net"
        ];
        environment = {
          TZ = "Europe/Dublin";
        };
        volumes = [
          "/home/cianh/gitea:/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };
    };
  };
}
