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
    enable = true;
    enableTypeChecks = true;
    autoUpdate.enable = true;
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
        ports = [
          "8000:8000"
          "9443:9443"
        ];
        autoStart = true;
        autoUpdate = "registry";
      };
    };
  };
}
