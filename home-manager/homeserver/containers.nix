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
      grafana = {
        image = "docker.io/grafana/grafana";
        ports = ["0.0.0.0:3000:3000"];
      };
    };
  };
}
