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
    grafana = {
      image = "docker.io/grafana/grafana:latest";
      autoUpdate = "registry";
      ports = ["3000:3000"];
    };
  };
}
