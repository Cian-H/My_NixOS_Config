{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      80 # Webpage
      3000 # Grafana
      3005 # Plex
      8096 # Jellyfin
      8324 # Plex
      32400 # Plex
      32469 # Plex
    ];
    allowedUDPPorts = [
      1900 # Plex
      32410 # Plex
      32412 # Plex
      32413 # Plex
      32414 # Plex
    ];
  };
}
