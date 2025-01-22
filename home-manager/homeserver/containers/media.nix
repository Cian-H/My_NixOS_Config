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
    plex = {
      image = "docker.io/plexinc/pms-docker:latest";
      autoUpdate = "registry";
      ports = [
        "32400:32400/tcp"
        "3005:3005/tcp"
        "8324:8324/tcp"
        "32469:32469/tcp"
        "1900:1900/udp"
        "32410:32410/udp"
        "32412:32412/udp"
        "32413:32413/udp"
        "32414:32414/udp"
      ];
      environment = {
        TZ = "Europe/Dublin";
        ADVERTISE_IP = "http://192.168.0.253:32400/";
        VERSION = "docker";
      };
      volumes = [
        "/home/cianh/TV_Archive/data:/data"
        "/home/cianh/TV_Archive/config:/config"
        "/home/cianh/TV_Archive/transcode:/transcode"
      ];
    };
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
