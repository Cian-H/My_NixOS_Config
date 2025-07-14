{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services = {
    swaync.enable = true;
    pueue.enable = true;
    hyprpaper.enable = true;
  };
}
