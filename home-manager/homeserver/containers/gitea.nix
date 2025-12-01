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
        ports = [
          "3000:3000"
          "2222:22"
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
