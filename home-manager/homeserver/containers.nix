{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
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
      extraOptions = [
        "--restart=always"
      ];
    };
  };
}
