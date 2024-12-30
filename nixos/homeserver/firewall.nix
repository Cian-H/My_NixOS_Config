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
    allowedTCPPorts = [22 80];
  };
}
