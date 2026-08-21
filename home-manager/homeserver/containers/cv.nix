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
    cv-api = {
      image = "ghcr.io/cian-h/cv-api:latest";
      network = "proxy-net";
      environment = {
        CV_BIND = "0.0.0.0";
        CV_PORT = "3000";
        CV_HDF5_PATH = "/data/cv_data.h5";
      };
      volumes = [
        "/home/cianh/api:/data:Z"
      ];
    };
  };
}
