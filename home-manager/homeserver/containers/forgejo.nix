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
      forgejo-net = {};
    };
    containers = {
      forgejo = {
        image = "codeberg.org/forgejo/forgejo:17";
        autoUpdate = "registry";
        network = [
          "forgejo-net"
          "proxy-net"
        ];
        environment = {
          TZ = "Europe/Dublin";
        };
        volumes = [
          "/home/cianh/forgejo:/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };
    };
  };
}
