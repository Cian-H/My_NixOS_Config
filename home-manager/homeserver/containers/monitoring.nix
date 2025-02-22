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
      grafana-net = {};
    };
    containers = {
      grafana = {
        image = "docker.io/grafana/grafana:latest";
        autoUpdate = "registry";
        network = ["grafana-net"];
        ports = ["3000:3000"];
        user = "1000:1000";
        volumes = [
          "/home/cianh/grafana:/var/lib/grafana:Z"
        ];
      };
      prometheus = {
        image = "docker.io/prom/prometheus:latest";
        autoUpdate = "registry";
        network = [
          "grafana-net"
          "proxy-net"
        ];
        volumes = [
          "/home/cianh/prometheus/:/etc/prometheus/"
        ];
      };
    };
  };
}
