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
      3000 # Grafana
      3005 # Plex
      3456 # Vikunja
      3457 # Freshrss
      8080 # Caddy
      8081 # Nextcloud
      8096 # Jellyfin
      8324 # Plex
      8443 # Caddy
      9980 # collabora
      32400 # Plex
      32469 # Plex
      11000 # Nextcloud
    ];
    allowedUDPPorts = [
      1234 # temporary
      1900 # Plex
      3456 # Vikunja
      3457 # Freshrss
      8080 # Caddy
      8081 # Nextcloud
      8443 # Caddy
      9980 # collabora
      11000 # Nextcloud
      32410 # Plex
      32412 # Plex
      32413 # Plex
      32414 # Plex
    ];
  };
}
