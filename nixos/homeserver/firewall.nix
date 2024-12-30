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
    ];
  };
}
