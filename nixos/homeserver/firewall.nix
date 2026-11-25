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
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      22 # SSH
      8080 # Caddy
      8443 # Caddy
    ];
    allowedUDPPorts = [
      8443 # Caddy HTTP/3
    ];
  };
}
