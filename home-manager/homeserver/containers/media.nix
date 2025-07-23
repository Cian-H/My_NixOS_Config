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
    jellyfin = {
      image = "docker.io/jellyfin/jellyfin:latest";
      autoUpdate = "registry";
      ports = ["8096:8096/tcp"];
      volumes = [
        "/home/cianh/TV_Archive/data:/media:Z"
        "/home/cianh/TV_Archive/jf_config:/config:Z"
        "/home/cianh/TV_Archive/jf_cache:/cache:Z"
      ];
      userNS = "keep-id";
    };
  };
}
